module dll;

import core.sys.windows.windows;

/// Like WinMain, DllMain is not the true entry point of DLLs.
/// Rather, the C runtime calls DllMain after initializing itself.
/// We can circumvent the C runtime dependency by declaring the
/// entry point ourselves, which incidentally has the same
/// signature as DllMain.
extern(System)
BOOL DllEntryPoint(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved) nothrow @nogc
{
	return TRUE;
}

pragma(startaddress, DllEntryPoint);
