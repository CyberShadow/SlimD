DC=dmd
DFLAGS=-betterC

target : optlink

.SUFFIXES: .d .obj

.d.obj:
	$(DC) $(DFLAGS) -c $<

$(NAME).coff.obj : $(NAME).d Makefile
	$(DC) $(DFLAGS) -c -m32mscoff $(NAME).d -of$(NAME).coff.obj

optlink : $(NAME).obj
	$(DC) $(DFLAGS) $(NAME).obj

#optlink : $(NAME).obj
#	link $(NAME).obj

unilink : $(NAME).obj
	ulink -GM:_TEXT=_DATA $(NAME).obj

mslink : $(NAME).coff.obj
	link $(NAME).coff.obj /ENTRY:start /SUBSYSTEM:WINDOWS /MERGE:.text=.slimd /MERGE:.rdata=.slimd /MERGE:.data=.slimd /SECTION:.slimd,ERW /OUT:$(NAME).exe /FIXED

crinkler : $(NAME).coff.obj
	crinkler /ENTRY:start /COMPMODE:SLOW $(NAME).coff.obj user32.lib kernel32.lib /ORDERTRIES:1000 /UNSAFEIMPORT /OUT:$(NAME).exe
