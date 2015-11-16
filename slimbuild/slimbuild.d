import core.runtime;

import std.algorithm;
import std.array;
import std.conv;
import std.exception;
import std.file;
import std.path;
import std.process;
import std.stdio;
import std.string;

import ae.sys.file;
import ae.utils.aa;
import ae.utils.array;
import ae.utils.meta;
import ae.utils.path;
import ae.utils.sini;
import ae.utils.text;

struct Config
{
	bool verbose;
	bool force;

	string name;
	string modules;
	string libs;
	bool console;
	bool dll;
	string entry = "start";
	string dflags = "-release";
	string compiler;
	string linker;
	string model = "32";
	bool demangle; // demangle linker output

	struct LibPath
	{
		string[string] omf, coff32, coff64;
	}
	LibPath libPath;

	struct Tool
	{
		string command;
		string path;
		string[string] env, args;
	}

	struct Tools
	{
		Tool dmd       = Tool("dmd"      );
		Tool ldc       = Tool("ldc2"     );
		Tool unilink   = Tool("ulink"    );
		Tool mslink    = Tool("link"     );
		Tool crinkler  = Tool("crinkler" );
		Tool golink    = Tool("golink"   );
		Tool watcom    = Tool("wlink"    );
		Tool gcc       = Tool("gcc"      );
		Tool ddemangle = Tool("ddemangle");
	}
	Tools tools;
}

immutable Config config;
immutable string[] inis;
immutable string root; // Root dir of SlimD

shared static this()
{
	string slimIni = "slim.ini";
	string[] cmdlineConfig = ["[]"];

	auto args = Runtime.args[1..$];
	for (size_t n=0; n<args.length; )
	{
		if (args[n] == "-v")
			args[n] = "--verbose=true";
		if (args[n] == "-h" || args[n] == "--help")
			throw new Exception("Usage: slimbuild [-v] [INI-FILE] [--SETTING=VALUE...]");
		if (args[n] == "-f" || args[n] == "--force")
			args[n] = "--force=true";
		if (args[n].startsWith("--"))
		{
			if (args[n].canFind('='))
			{
				cmdlineConfig ~= args[n][2..$];
				args = args[0..n] ~ args[n+1..$];
			}
			else
			{
				enforce(n+1 < args.length, "No value for parameter " ~ args[n]);
				cmdlineConfig ~= args[n][2..$] ~ '=' ~ args[n+1];
				args = args[0..n] ~ args[n+2..$];
			}
		}
		else
			n++;
	}
	enforce(args.length <= 1, "Too many arguments");
	if (args.length)
		slimIni = args[0];

	root = thisExePath.dirName().dirName();

	string[] defaultConfig = [
		"libPath.omf.slimd=" ~ root.buildPath("libs", "omf")
	];

	inis =
	[
		root.buildPath("local.ini"),
		slimIni,
		"local.ini",
	];

	Config result = loadInis!Config(inis);
	cmdlineConfig.parseIniInto(result);
	defaultConfig.parseIniInto(result);
	config = cast(immutable)result;
}

void log(string s)
{
	stderr.writeln("slimbuild: ", s);
}

void vlog(string s)
{
	if (config.verbose) log(s);
}

void run(string[] args)
{
	log("Exec: " ~ args.escapeShellCommand());

	int res;
	if (!config.demangle)
		res = spawnProcess(args).wait();
	else
	{
		auto p = pipe();
		auto demangleCommand = [config.tools.ddemangle.command] ~ config.tools.ddemangle.args.sortedValues;
		auto demangler = spawnProcess(demangleCommand, p.readEnd, stdout, stderr);
		auto tool = spawnProcess(args, stdin, p.writeEnd, p.writeEnd);
		res = tool.wait();
		p.close();
		demangler.wait();
	}

	enforce(res == 0, "Command exited with status %d".format(res));
}

void runTool(ref in Config.Tool tool, string[] args)
{
	auto oldEnv = environment.toAA();
	scope(exit)
	{
		foreach (k, v; oldEnv)
			if (k.length)
				environment[k] = v;
		foreach (k, v; environment.toAA())
			if (k.length && k !in oldEnv)
				environment.remove(k);
	}

	if (tool.path.length)
		environment["PATH"] = tool.path ~ pathSeparator ~ oldEnv["PATH"];

	foreach (k, v; tool.env)
		environment[k] = v;

	run([tool.command] ~ tool.args.sortedValues ~ args);
}

void main()
{
	enforce(config.name, "'name' not specified, indicate project name");
	enforce(config.model.isOneOf("32", "64"), "Invalid model, must be '32' or '64'");

	string[] modules;
	if (config.modules)
		modules = config.modules.split();
	else
	{
		modules = [config.name ~ ".d"];
		vlog("No 'modules' specified, implying from name: " ~ modules[0]);
	}

	string omf = "%s.omf.obj".format(config.name);
	string coff = "%s.coff.obj".format(config.name);
	string exe = "%s.%s".format(config.name, config.dll ? "dll" : "exe");
	auto dflags = config.dflags.split();
	auto libs = config.libs.split();
	auto subsystem = config.console ? "CONSOLE" : "WINDOWS";

	string[] sources = inis.dup.filter!exists.array;
	sources ~= thisExePath;
	sources ~= modules;

	T selectTool(T)(string name, T defaultValue = T.init)
	{
		if (!name)
		{
			vlog("No '%s' specified, defaulting to %s.".format(T.stringof.toLower(), defaultValue));
			return defaultValue;
		}
		return to!T(name.split('-').camelCaseJoin());
	}

	enum Compiler { dmd, ldc }
	auto compiler = selectTool!Compiler(config.compiler);

	if (config.verbose)
		final switch (compiler)
		{
			case Compiler.dmd:
			case Compiler.ldc:
				dflags ~= ["-v"];
				break;
		}

	enum Linker { optlink, unilink, unilinkCoff, mslink, crinkler, golink, watcom, gcc }
	auto linker = selectTool!Linker(config.linker, config.model == "32" ? Linker.optlink : Linker.mslink);

	bool shouldBuild(string[] sources, string target)
	{
		if (config.force || sources.anyNewerThan(target))
			return true;
		vlog(target ~ " up to date.");
		return false;
	}

	void needOmf()
	{
		if (shouldBuild(sources, omf))
			final switch (compiler)
			{
				case Compiler.dmd:
					enforce(config.model == "32", "DMD can only generate 32-bit OMF files");
					runTool(config.tools.dmd,
						dflags ~
						modules ~
						[
							"-c",           // Compile only, do not link
							"-betterC",     // Disable Druntime helpers
							"-of" ~ omf,    // Output file
							"-m32",         // Generate 32-bit OMF file
						]
					);
					break;
				case Compiler.ldc:
					throw new Exception("%s cannot generate OMF object files".format(compiler));
			}
	}

	void needCoff()
	{
		if (shouldBuild(sources, coff))
			final switch (compiler)
			{
				case Compiler.dmd:
					runTool(
						config.tools.dmd,
						dflags ~
						modules ~
						[
							"-c",           // Compile only, do not link
							"-betterC",     // Disable Druntime helpers
							"-m" ~ (config.model == "32" ? "32mscoff" : "64"), // Create COFF object file
							"-of" ~ coff,   // Output file
						]
					);
					break;
				case Compiler.ldc:
					runTool(
						config.tools.ldc,
						dflags ~
						modules ~
						[
							"-c",           // Compile only, do not link
							"-m" ~ config.model, // Create COFF object file
							"-fdata-sections",
							"-ffunction-sections",
							"-Oz",          // Smallest input file
							"-of=" ~ coff,  // Output file
						]
					);
					break;
			}
	}

	string obj;

	final switch (linker)
	{
		case Linker.optlink:
		case Linker.unilink:
		case Linker.watcom:
			needOmf();
			obj = omf;
			break;

		case Linker.unilinkCoff:
		case Linker.mslink:
		case Linker.crinkler:
		case Linker.golink:
		case Linker.gcc:
			needCoff();
			obj = coff;
			break;
	}

	sources ~= obj;
	if (!shouldBuild(sources, exe))
		return;

	final switch (linker)
	{
		case Linker.optlink:
			runTool(
				config.tools.dmd,
				dflags ~
				obj ~
				libs ~
				[
					"-L/SUBSYSTEM:" ~ subsystem,          // Subsystem
					"-of" ~ exe,                          // Output file
				] ~
				                                          // Library search paths
				config.libPath.omf.sortedValues.map!(path => "-L+" ~ path.includeTrailingPathSeparator).array ~
				                                          // Entry point
				(config.entry.length ? "-L/ENTRY:_" ~ config.entry : []) ~
				(config.dll ? ["-L/IMPLIB"] : [])         // Generate an import library
			);
			break;

		case Linker.unilink:
		case Linker.unilinkCoff:
			runTool(
				config.tools.unilink,
				obj ~
				libs ~
				[
					"-q",                                 // Suppress banner
					"-GS:*=*",                            // Merge all sections
					"-Gh",                                // Strip unused PE directories
					"-ZX-",                               // Minimal DOS stub
					"-a" ~ (config.console ? 'p' : 'a'),  // Subsystem
					                                      // Target type
					"-Tp" ~ (config.dll ? 'd' : 'e') ~ (config.model == "64" ? "+" : ""),
					"-ZO" ~ exe,                          // Output file
				] ~
					                                      // Entry point
				(config.entry.length ? ["-e" ~ (linker == Linker.unilink ? "_" : "") ~ config.entry] : []) ~
				                                          // Library search path
				(linker == Linker.unilink
					? config.libPath.omf
					: config.model == "32"
						? config.libPath.coff32
						: config.libPath.coff64)
					.sortedValues.map!(path => "-L" ~ path.excludeTrailingPathSeparator).array ~
				                                          // Generate an import library (in OMF/COFF format)
				(config.dll ? [linker == Linker.unilink ? "-Gi" : "-Gic"] : [])
			);
			break;

		case Linker.mslink:
			runTool(
				config.tools.mslink,
				obj ~
				libs ~
				[
					"/NOLOGO",                            // Suppress banner
					"/MERGE:.text=.slimd",                // Merge code section into .slimd
					"/MERGE:.rdata=.slimd",               // Merge read-only data section into .slimd
					"/MERGE:.data=.slimd",                // Merge data section into .slimd
					"/SECTION:.slimd,ERW",                // Set .slimd section flags
					"/IGNORE:4254",                       // Ignore "section 'section1' (offset) merged into 'section2' (offset) with different attributes"
					config.dll ? "/DLL" : "/FIXED",       // DLL / Disable relocations

					"/SUBSYSTEM:" ~ subsystem,            // Subsystem
					"/OUT:" ~ exe,                        // Output file
				] ~
				                                          // Library search path
				(config.model == "32"
					? config.libPath.coff32
					: config.libPath.coff64)
					.sortedValues.map!(path => "/LIBPATH:" ~ path.excludeTrailingPathSeparator).array ~
				                                          // Entry point
				(config.entry.length ? ["/ENTRY:" ~ config.entry] : [])
			);
			break;

		case Linker.crinkler:
			enforce(!config.dll, "Crinkler does not support DLL files.");
			runTool(
				config.tools.crinkler,
				obj ~
				libs ~
				["kernel32.lib"] ~                        // kernel32.dll is always needed for Crinkler's GetProcAddress call
				[
					"/COMPMODE:SLOW",                     // Use best compression
					"/ORDERTRIES:1000",                   // Try a thousand section order combinations
					"/UNSAFEIMPORT",                      // Save more space by assuming all DLLs will be present

					"/SUBSYSTEM:" ~ subsystem,            // Subsystem
					"/OUT:" ~ exe,                        // Output file
				] ~
				                                          // Library search path
				(config.model == "32"
					? config.libPath.coff32
					: config.libPath.coff64)
					.sortedValues.I!(paths =>
						paths.length == 0 ? [] : ["/LIBPATH:" ~ paths.map!excludeTrailingPathSeparator.join(";")]) ~
				                                          // Entry point
				(config.entry.length ? ["/ENTRY:" ~ config.entry] : [])
			);
			break;

		case Linker.golink:
			runTool(
				config.tools.golink,
				obj ~
				libs.map!(lib => lib.setExtension(".dll")).array ~
				(config.verbose ? ["/files"] : []) ~
				(config.console ? ["/console"] : []) ~    // Subsystem
				[
					"/mix",
					"/fo", exe,                           // Output file
				] ~
				                                          // Entry point
				(config.entry.length ? ["/entry", "_" ~ config.entry] : [])
			);
			break;

		case Linker.watcom:
			runTool(
				config.tools.watcom,
				[
					"name", config.name,
					"file", obj,
					"system", config.console ? "nt" : "nt_win",
					"option", "NORELOCS",
				] ~
				libs.map!(lib => ["library", lib]).join
			);
			break;

		case Linker.gcc:
			runTool(
				config.tools.gcc,
				obj ~
				[
					"-Wl,--gc-sections",                  // Garbage-collect sections. Doesn't seem to be implemented for COFF/PE.
					"-nostdlib",                          // Inhibit linking with libc

					"-o", exe,                            // Output file
					"-Wl,-subsystem," ~
						subsystem.toLower(),              // Subsystem
				] ~
				(config.entry.length ? ["-Wl,-e_" ~ config.entry] : []) ~
				libs.map!(lib => "-l" ~ lib.stripExtension()).array()
			);
			break;
	}
}
