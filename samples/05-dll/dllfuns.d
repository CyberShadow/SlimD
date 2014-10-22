/// Actual functions declared by this DLL.

module dllfuns;

import core.sys.windows.windows;

export void fun()
{
	MessageBoxA(null, "Hello DLL world!", null, 0);
}
