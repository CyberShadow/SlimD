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
	string entry = "start";
	string dflags = "-betterC -release";
	string compiler;
	string linker;

	struct Paths
	{
		string dmd      = "dmd";
		string unilink  = "ulink";
		string mslink   = "link";
		string crinkler = "crinkler";
	}
	Paths paths;
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
				enforce(n < args.length, "No value for parameter" ~ args[n]);
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
	inis =
	[
		root.buildPath("local.ini"),
		slimIni,
		"local.ini",
	];

	Config result = loadInis!Config(inis);
	cmdlineConfig.parseIniInto(result);
	config = result;
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
	auto res = spawnProcess(args).wait();
	enforce(res == 0, "Command exited with status %d".format(res));
}

void main()
{
	enforce(config.name, "'name' not specified, indicate project name");

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
	string exe = "%s.exe".format(config.name);
	auto dflags = config.dflags.split();
	auto libs = config.libs.split();
	string omfLibPath = root.buildPath("libs", "omf");
	auto subsystem = config.console ? "CONSOLE" : "WINDOWS";

	string[] sources = inis.dup.filter!exists.array;
	sources ~= thisExePath;
	sources ~= modules;

	T selectTool(T)(string name)
	{
		if (!name)
		{
			vlog("No '%s' specified, defaulting to %s.".format(T.stringof.toLower(), T.init));
			return T.init;
		}
		return to!T(name.split('-').camelCaseJoin());
	}

	enum Compiler { dmd }
	auto compiler = selectTool!Compiler(config.compiler);

	if (config.verbose)
		final switch (compiler)
		{
			case Compiler.dmd:
				dflags ~= ["-v"];
				break;
		}

	enum Linker { optlink, unilink, mslink, crinkler }
	auto linker = selectTool!Linker(config.linker);

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
					run(
						[config.paths.dmd] ~
						dflags ~
						modules ~
						[
							"-c",           // Compile only, do not link
							"-of" ~ omf,    // Output file
						]
					);
					break;
			}
	}

	void needCoff()
	{
		if (shouldBuild(sources, coff))
			final switch (compiler)
			{
				case Compiler.dmd:
					run(
						[config.paths.dmd] ~
						dflags ~
						modules ~
						[
							"-c",           // Compile only, do not link
							"-m32mscoff",   // Create 32-bit COFF object file
							"-of" ~ coff,   // Output file
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
			needOmf();
			obj = omf;
			break;

		case Linker.mslink:
		case Linker.crinkler:
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
			run(
				[config.paths.dmd] ~
				dflags ~
				obj ~
				libs ~
				[
					"-L/ENTRY:_" ~ config.entry,          // Entry point
					"-L/SUBSYSTEM:" ~ subsystem,          // Subsystem
					"-L+" ~ omfLibPath ~ `\`,             // Library search path
					"-of" ~ exe,                          // Output file
				]
			);
			break;

		case Linker.unilink:
			run(
				[config.paths.unilink] ~
				obj ~
				libs ~
				[
					"-q",                                 // Suppress banner
					"-GS:*=*",                            // Merge all sections
					"-Gh",                                // Strip unused PE directories
					"-ZX-",                               // Minimal DOS stub

					"-e_" ~ config.entry,                 // Entry point
					"-a" ~ (config.console ? 'p' : 'a'),  // Subsystem
					"-L" ~ omfLibPath,                    // Library search path
					"-ZO" ~ exe,                          // Output file
				]
			);
			break;

		case Linker.mslink:
			run(
				[config.paths.mslink] ~
				obj ~
				libs ~
				[
					"/NOLOGO",                            // Suppress banner
					"/MERGE:.text=.slimd",                // Merge code section into .slimd
					"/MERGE:.rdata=.slimd",               // Merge read-only data section into .slimd
					"/MERGE:.data=.slimd",                // Merge data section into .slimd
					"/SECTION:.slimd,ERW",                // Set .slimd section flags
					"/IGNORE:4254",                       // Ignore "section 'section1' (offset) merged into 'section2' (offset) with different attributes"
					"/FIXED",                             // Disable relocations

					"/ENTRY:" ~ config.entry,             // Entry point
					"/SUBSYSTEM:" ~ subsystem,            // Subsystem
					"/OUT:" ~ exe,                        // Output file
				]
			);
			break;

		case Linker.crinkler:
			run(
				[config.paths.crinkler] ~
				obj ~
				libs ~
				["kernel32.lib"] ~                        // kernel32.dll is always needed for Crinkler's GetProcAddress call
				[
					"/COMPMODE:SLOW",                     // Use best compression
					"/ORDERTRIES:1000",                   // Try a thousand section order combinations
					"/UNSAFEIMPORT",                      // Save more space by assuming all DLLs will be present

					"/ENTRY:" ~ config.entry,             // Entry point
					"/SUBSYSTEM:" ~ subsystem,            // Subsystem
					"/OUT:" ~ exe,                        // Output file
				]
			);
			break;
	}
}
