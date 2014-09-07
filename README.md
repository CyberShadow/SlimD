SlimD
=====

Bare-bones D on Win32.

[Announcement](http://forum.dlang.org/post/qcbicxrtmjmwiljsyhdf@forum.dlang.org).

Setup
-----

Copy `local.mak.sample` to `local.mak` and edit accordingly.

Usage
-----

See `samples` for examples.

To build a sample, run:

    $ make LINKER

where `LINKER` is one of:

 * `optlink` (default)  
   Link using OPTLINK (DMD's default 32-bit linker on Windows).
 * `unilink`  
   Link using [Unilink](ftp://ftp.styx.cabel.net/pub/UniLink/).
 * `mslink`  
   Link using the Microsoft linker. `link.exe` must be in `PATH`.
 * `crinkler`  
   Link using [Crinkler](http://www.crinkler.net/).
