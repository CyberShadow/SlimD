module a;

import win32.windows;
import b;

extern(C)
void start()
{
	MessageBox(null, getMessage(), getTitle(), MB_ICONINFORMATION);
}

pragma(startaddress, start);
