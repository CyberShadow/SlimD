/// Calculates the sum of all integers from 1 to N, where
/// N is given as the first argument on the command line.

module sum;

import core.stdc.stdio;
import core.stdc.wchar_;
import core.sys.windows.windows;

import std.algorithm;
import std.conv;
import std.range;

inout(wchar)[] fromWStringz(inout(wchar)* p)
{
	return p ? p[0..wcslen(p)] : null;
}

extern(C)
void start() nothrow @nogc
{
	int argc;
	auto argv = CommandLineToArgvW(GetCommandLineW(), &argc);
	int n; swscanf(argv[1], "%d", &n);
	auto sum = reduce!"a+b"(0, iota(n+1));
	printf("%d\n", sum);
}

pragma(startaddress, start);
