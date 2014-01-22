SLIMLIB=..\..\slimlib

DC=dmd
DFLAGS=-I$(SLIMLIB)\src -defaultlib=slimlib

target : optlink

hello.obj : hello.d Makefile
	$(DC) $(DFLAGS) -c hello.d

#optlink : hello.d
#	$(DC) $(DFLAGS) hello.d

optlink : hello.obj
	link hello.obj $(SLIMLIB)\lib\ 

unilink : hello.obj
	ulink -L$(SLIMLIB)\lib -zslimlib -ZX- hello.obj
