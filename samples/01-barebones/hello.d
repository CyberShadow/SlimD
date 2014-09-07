// This example doesn't use the runtime at all, since
// it specifies the entry point and doesn't use any
// language facilities that require runtime support.
// Therefore, it doesn't even require slimlib.

// The makefile has two targets: optlink (default) and
// unilink. UniLink will produce a much smaller executable.

// The compiler will emit some meta-information for
// every module. It's only a few bytes in size, though.
module hello;

// We only need this for the function signatures.
import win32.windows;

// No magic names needed.
extern(C)
void start()
{
	MessageBox(null, "Hello, world!", "SlimD", MB_ICONINFORMATION);

	// Omitting ExitProcess may work on some systems,
	// but will cause a crash on exit on others.
//	ExitProcess(0);
}

// pragma(startaddress) sets the executable's real entry point,
// as it will end up in the PE header. We do this to bypass
// runtime initialization and all its dependencies.
// Unfortunately DMD does not emit the correct information to
// COFF object files:
// https://issues.dlang.org/show_bug.cgi?id=13431
// So for COFF linkers it is passed on the linker's command
// line. The name can be overridden in the makefile.
//pragma(startaddress, start);

// If linking with DMD, DMD will automatically add kernel32
// and user32 to the linker's command line. Otherwise, these
// libraries need to be specified here, or in the makefile.
// Some linkers don't understand lib pragmas, though, so
// you'll need to list the libraries in the makefile instead.
//pragma(lib, "kernel32");
//pragma(lib, "user32");
