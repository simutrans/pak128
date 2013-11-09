These files are sources of sources, do not compile them. For compiling, the actual 
data is split into more files across more folders.

================================================================================

How to use the vbs scripts to obtain Makeobj sorces from GIMP files (MS Windows only)

Preliminary steps:
1) Make sure you have ImageMagick installed (see: www.imagemagick.org) and its 
   convert.exe executable in a folder in path.
2) Make sure you have Optipng installed (see optipng.sourceforge.net) and its
   executable is in a folder in path.

How to edit sources of sources:
1) Open xxxxxxxx-zzzzzzz.xcf.bz2 with GIMP and edit the appropriate layers.
2) Export two files with filename xxxxxxxx-yy.png with the following naming convention:
      xxxxxxx : name of the GIMP file truncated at the first dash (-)
	  yy      : to digits number, typically 01 for summer version (snow layers hidden) 
	            and 02 for winter version (snow layers activated)
   Note that Simutrans Tools for GIMP ver. 0.7+ (http://forum.simutrans.com/index.php?topic=9500) 
   include a tool to export in png format adding a Simutrans transparency (#E7FFFF) 
   background if missing.
3) Edit xxxxxxxx.tdat in a text editor. This is a dat file template.
   Most entries are in the same format as in dat files. Image references however differ
   and are in the following format:
      !nn@zz.y.x (sometimes with trailing offsets ,ox,oy)
   where
      !nn is the number used for seasonal versions (typically 01 for summer and 02 for winter)
	  @zz is an optional column offset, e.g. !nn@20.0.24 actually points to !nn.0.4
4) Run compile.vbs script.
   It will output individual makeobj sources (both png and dat) for each object 
   in ./output/ subfolder. Another *.tmp folder will be created, but it can be safely deleted.
5) For your convenience, run output.vbs script.
   It will move the objects in output subfolder to the appropriate folder (e.g. tunnels
   with tunnels, bridges with bridges and so on) IF the newly created file is new or differs 
   from the existing one. It will also compress pngs using optipng -o7