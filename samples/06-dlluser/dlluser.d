/// SlimD example of linking to a D DLL.
module dlluser;

/// We import the module from the DLL implementation which
/// defines the DLL functions. However, we only import it -
/// the module will not be compiled or linked with the DLL.
/// This allows us to use the same declaration for both the
/// DLL implementation and interface. Otherwise, we'd need to
/// have a separate .di file, or use extern(C) declarations
/// to declare the functions defined in the DLL.
import dllfuns;

extern(C)
void start()
{
	fun();
}
pragma(startaddress, start);
