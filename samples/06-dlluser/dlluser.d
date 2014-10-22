import dllfuns;

extern(C)
void start()
{
	fun();
}
pragma(startaddress, start);
