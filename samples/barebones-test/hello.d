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
void start()
{
	//MessageBox(null, "Hello, world!", "Barebones D", MB_ICONINFORMATION);

	// Omitting ExitProcess may work on some systems,
	// but will cause a crash on exit on others.
	ExitProcess(0);
}

// Set the entry point to bypass runtime initialization and
// all its dependencies.
pragma(startaddress, start);

// If linking with DMD, DMD will automatically add kernel32
// and user32 to the linker's command line. Otherwise, these
// libraries need to be specified here, or in the makefile.
pragma(lib, "kernel32");
pragma(lib, "user32");
