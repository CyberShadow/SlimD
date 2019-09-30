module a;

import core.sys.windows.windows;
import b;

extern(C)
void start()
{
	MessageBox(null, getMessage(), getTitle(), MB_ICONINFORMATION);
}

pragma(startaddress, start);
