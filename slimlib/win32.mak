
DMD=dmd

DFLAGS=-O -release -inline -nofloat -w -d -Isrc -Iimport

SLIMLIB_BASE=slimlib
SLIMLIB=lib\$(SLIMLIB_BASE).lib

MSVCRT=lib\msvcrt.lib

target : $(SLIMLIB) $(MSVCRT)

SRCS= \
	src\object.d

################### Library generation #########################

$(SLIMLIB): $(SRCS) win32.mak
	$(DMD) -lib -of$(SLIMLIB) -Xfslimlib.json $(DFLAGS) $(SRCS)

# We could supply a .def file, but Digital Mars implib crashes on it :|
$(MSVCRT): win32.mak
	implib $(MSVCRT) $(WINDIR)\System32\msvcrt.dll
