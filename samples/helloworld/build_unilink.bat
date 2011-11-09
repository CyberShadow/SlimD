@dmd -I..\..\slimlib\src -c hello.d && ulink -L..\..\slimlib\lib -LC:\dm\lib -zslimlib -zkernel32;advapi32;user32;wsock32;shell32 -ZX- hello.obj
