This weak attempt at documentation should roughly describe what these tools do. Most of them operate on two assumptions:
1) user knows what he is doing and has backups
2) specifying objects one by one would be a pain so at first everything is loaded and only later used only what is needed.

Most of these are Python scripts, and quite some of them (the best at least) use PyGame.

All of them should run with CPython version 2.6, and some 3.1, too.

-----------------

compat-trans-lift.py
 - Takes old translation folder and compat.tab, copies translations over to new folder where new items are translated to what the old ones were.

extract-copyright.py
 - Checks status of objects and authors. Creates csv files raw.csv with all objects, empty-copyright.csv with objects that do not have set copyright entry and final-analysis.csv that lists all empty and with unknown authors. Authors are listed in simuauthors.py - see below.

extract-objects-translator-reduced.py
 - Since SimuTranslator can not take all data, this loads objects and outputs "stump" objects in new folder with no more than 4 graphics suitable for uploading. You have to convert output images from bmp to png yourself.

extract-stats.py
 - reads data from extract-copyright.py and sums up in numbers.

extract-translator-object-list.py
 - outputs names of objects in translation file

house-spectrogram.py
 - Draws a graph how many houses are available at some time and at some level. Finds itself all com,res,ind.

list-all-objects.py
 - lists objects in directory tree

listpng.py
 - Checks all png files if they have correct format (24bit rgb) and reports these that are bad

merge128.php, merge_general.php
 - Napik's image mergers. You need a web server (php+gd) to use them. They take a bunch of pictures in folder "join" and create a new picture with all the parts. Good for Raven's things if you have some.

pakmak.py (one folder higher)
 - The build system for pak128. Not much documentation... if there is a lot of interest, I can document make a new thread about this one.

report-trees.py
 - Loads all trees in subfolders and builds a graphical overview table with their climates.

report-unused-images.py
 - loads all dats in subfolders and looks at all png files there, too, then compares which tiles of these are used and generates reports - copies of pong images with used tiles replaced by red

simuauthors.py, simutools.py
 - Libraries for all the nice stuff. You can't run them, but you might want to change the list of authors to match your pakset, and if you want to write tools like mine, simutools has a complete parser for DAT files and so on.

split-houses-multitile.py
 - Splits houses like citycars. The fact that there are many tiles is masked by simply stacking them to output as they come. Does not copy FrontImage since 128 has none of these.

split-houses-singletile.py
 - Like above, but wit the restriction on only one building tile (dims start as 1,1). This allows some guessing of nicer layouts than plain dump. Buggy - run check-houses.py (see above) on output to find what didn't go through and correct manually. It's still a lifesaver though... at least for me.

split-vehicles.py
 - Splits vehicles to one file per object.

tab2html.py
 - Turns translation files exported from SimuTranslator into HTML with correct character encoding.

timeline-chart.py
 - Creates a graphical timeline overview for vehicles.

tree-align-interactive.py
 - Interactive re-alignment tool for trees.

veh-speeds.py
 - Reads all vehicles and creates speed statistics in csv format.
