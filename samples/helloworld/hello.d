import win32.windows;

extern(Windows)
void start()
{
	MessageBox(null, "Hello, world!", "SlimD", 0);
	ExitProcess(0);
}
