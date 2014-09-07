/// Calculates the sum of all integers from 1 to N, where
/// N is given as the first argument on the command line.

module sum;

import core.stdc.stdio;
import core.stdc.wchar_;
import core.sys.windows.windows;

// We can use Phobos functions, as long as they are @nogc
// and nothrow.

// Memory allocations invoke the GC, which pulls in a huge
// part of the runtime, and requires initialization.
// Runtime initialization would mean that we'd need to use
// the D main() function as our entry point. It would also
// pull in the C main and its dependencies from the C
// runtime as well.

// We can't use exceptions because they require memory
// allocation, and thus cause all of the above problems as
// well.

import std.algorithm;
import std.conv;
import std.range;

// Why is this not in Phobos already?
inout(wchar)[] fromWStringz(inout(wchar)* p)
{
	return p ? p[0..wcslen(p)] : null;
}

extern(C)
void start() nothrow @nogc
{
	// Get command line. There is no args[] or
	// argc/argv passed to us, we have to query it
	// (the runtime usually does this for you).
	int argc;
	auto argv = CommandLineToArgvW(GetCommandLineW(), &argc);

	// swscanf because std.conv.to/parse may throw
	int n; swscanf(argv[1], "%d", &n);

	// reduce with seed because seedless version throws on
	// an empty range
	auto sum = reduce!"a+b"(0, iota(n+1));

	// printf, because writeln may throw/allocate
	printf("%d\n", sum);
}

pragma(startaddress, start);
