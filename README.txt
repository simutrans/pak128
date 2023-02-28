
This is source of pak128. It includes everything to produce an usable package, except for the compiler program(s).


Compilation
-----------

Currently these build systems are available:
* makefile
* Windows batch file (not tested)

A makeobj executable must be on path or next to script file. A make program is needed for the makefile, and Windows for the batch file. To create a revision, it is assumed that git is installed. (Not supported for windows.)

Result of compilation should be a directory "simutrans/pak128", and will be also zipped.


Documentation
-------------

Some basic general information is available in "devdocs" directory. If the directory contents are in any way significant or different, read accompanying "README.txt" files.

If you wish to use the set only as a reference, you will be mostly interested in items in folder "base".

The materials available here are only these specific to this set; general guides and references can be found at:
* https://simutrans-germany.com/wiki/wiki/tiki-index.php
* https://graphics.simutrans.com/


License matters
---------------

When reusing the material from this set, observe the terms of used license. Additionally, please provide some attribution, although this is not mandatory.

The license implicitly assumed for all graphical material is "Artistic license 2.0", unless specified otherwise individually. For license details, please see the accompanying file "LICENSE.txt". Configuration, text and script files are in public domain, unless specified otherwise.


Alternative forms of graphics
-----------------------------

Given how the source/compilation paradigm breaks when translated from "programming" to general data manipulation, the approach taken for our graphics is purely pragmatical.

Generally, user-level distribution form of material are compiled PAK files. Their sources are the PNG and DAT files available here, without exception. This fulfills at least the letter of the law of "being open source".

True "openess", however, suggests that the whole process should be replicable, which is not always possible. Still, in some cases, there are available initial or intermediate forms of material from which the graphics are rendered in some way. Providing these consistently is beyond the scope of this project, but encouraged. Folders or files that contain these usually contain "src" somewhere in their name.


Contact
-------

Pak128 is maintained by a number of Simutrans community members. Preferred method of communication is via the Simutrans International Forum, particularly the pak128 sub-boards:
https://forum.simutrans.com/index.php?board=26.0
