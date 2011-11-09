DC=dmd
DFLAGS=

target : optlink

hello.obj : hello.d Makefile
	$(DC) $(DFLAGS) -c hello.d

#optlink : hello.d
#	$(DC) $(DFLAGS) hello.d

optlink : hello.obj
	link hello.obj

unilink : hello.obj
	ulink hello.obj
