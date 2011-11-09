import win32.windows;

void start()
{
	MessageBox(null, "Hello, world!", "SlimD", 0);
	ExitProcess(0);
}
pragma(startaddress, start);
