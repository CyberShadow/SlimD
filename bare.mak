DC=dmd
DFLAGS=-betterC
SUBSYSTEM?=WINDOWS
MODULES?=$(NAME).d

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)/local.mak

SLIMLIB=$(SLIM)\libs

target : optlink

.SUFFIXES: .d .obj

$(NAME).obj : $(MODULES) Makefile
	$(DC) $(DFLAGS) -c $(MODULES) -of$@

$(NAME).coff.obj : $(MODULES) Makefile
	$(DC) $(DFLAGS) -c -m32mscoff $(MODULES) -of$@

optlink : $(NAME).obj
	$(DC) $(DFLAGS) $(NAME).obj $(LIBS) -L/SUBSYSTEM:$(SUBSYSTEM) -L+$(subst \,\\,$(SLIMLIB))\\omf\\ 

#optlink : $(NAME).obj
#	link $(NAME).obj

unilink : $(NAME).obj
	ulink -GM:_TEXT=_DATA $(NAME).obj $(LIBS)

mslink : $(NAME).coff.obj
	link $(NAME).coff.obj $(LIBS) /ENTRY:start /SUBSYSTEM:$(SUBSYSTEM) /MERGE:.text=.slimd /MERGE:.rdata=.slimd /MERGE:.data=.slimd /SECTION:.slimd,ERW /NOLOGO /IGNORE:4254 /OUT:$(NAME).exe /FIXED

crinkler : $(NAME).coff.obj
	crinkler $(NAME).coff.obj $(LIBS) kernel32.lib /ENTRY:start /SUBSYSTEM:$(SUBSYSTEM) /COMPMODE:SLOW /ORDERTRIES:1000 /UNSAFEIMPORT /OUT:$(NAME).exe
