
DMD=dmd

DFLAGS=-O -release -inline -nofloat -w -d -Isrc -Iimport

SLIMLIB_BASE=slimlib
SLIMLIB=lib\$(SLIMLIB_BASE).lib

target : $(SLIMLIB)

SRCS= \
	src\object.d \
	\
	src\rt\crt.d

################### Library generation #########################

$(SLIMLIB): $(SRCS) win32.mak
	$(DMD) -lib -of$(SLIMLIB) -Xfslimlib.json $(DFLAGS) $(SRCS)
