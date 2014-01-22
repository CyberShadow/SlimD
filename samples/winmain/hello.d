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

import slim.rt.winmain;

extern (Windows)
int WinMain(HINSTANCE hInstance,
	HINSTANCE hPrevInstance,
	LPSTR lpCmdLine,
	int nCmdShow)
{
	MessageBox(null, "Hello, world!", "Barebones D", MB_ICONINFORMATION);
	return 0;
}
