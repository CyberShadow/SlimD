module hello;

import core.stdc.stdio;

extern(C)
void start()
{
	puts("Hello, world!");
}

pragma(startaddress, start);
