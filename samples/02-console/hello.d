module hello;

import core.stdc.stdio;

extern(C)
void start()
{
	printf("Hello, world!\n");
}

pragma(startaddress, start);
