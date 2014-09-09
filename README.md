SlimD
=====

Bare-bones D on Win32.

[Announcement](http://forum.dlang.org/post/qcbicxrtmjmwiljsyhdf@forum.dlang.org).

Setup
-----

1. Clone the repository:

        git clone --recursive https://github.com/CyberShadow/SlimD

2. Build the build tool:

        cd SlimD
        rdmd --build-only slimbuild\slimbuild

3. Add `slimbuild` to the system `PATH` (optional);

4. Copy `local.ini.sample` to `local.ini` and edit according to the comments (optional).

Usage
-----

See `samples` for examples. Run `slimbuild` from within a sample's directory to build it.

The build tool will use configuration from INI files and the command line.
Configuration is applied in the following order:

1. `local.ini` in `slimbuild`'s parent directory (the repository root);
2. `slim.ini` in the current directory;
3. `local.ini` in the current directory;
4. The command line (`--option=value`).
