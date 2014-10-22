/// Actual functions declared by this DLL.
/// We place the exported functions in a separate
/// module from the DLL entry point, so that this
/// module can be imported by DLL users (see
/// 06-dlluser).

module dllfuns;

import core.sys.windows.windows;

export void fun()
{
	MessageBoxA(null, "Hello DLL world!", null, 0);
}
