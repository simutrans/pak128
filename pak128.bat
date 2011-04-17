@echo off
echo works to folder simutrans/pak128
echo file pak128.bat and makeobj.exe in one folder
pause

rem altes löschen
rem  ------------------------
del pak128.zip
cd simutrans\pak128
if errorlevel 1 goto skip_delete
rem if folder does not exist, skip deleting old data
echo removing old data
del *.pak
del config\*.tab
del text\*.tab
del text\*.txt
del text\*.zip
del doc\*.txt
del sound\*.wav
del sound\*.tab
del scenario\*.tab
del scenario\*.sve
cd..
cd..
:skip_delete

rem copy config & translation

rem  ------------------------
xcopy /E pak128.prototype\*.* simutrans\pak128\
rem for newer Windows versions can be added /EXCLUDE:svn

rem neues schreiben
rem  ------------------------
cd base\misc_GUI
..\..\makeobj.exe pak128 >..\..\err.txt

rem symbol.biglogo.pak must stay a single file - so it is copied into the pak folder before the others are moved and merged
copy symbol.biglogo.pak ..\..\simutrans\pak128
del symbol.biglogo.pak

copy symbol.*.pak ..\misc_GUI_64
del symbol.*.pak
copy *.pak ..\..\simutrans\pak128\*.*
del *.pak

cd ..\misc_GUI_64
..\..\makeobj.exe pak >>..\..\err.txt
..\..\makeobj.exe merge symbol.all.pak symbol.*.pak >>..\..\err.txt
copy symbol.all.pak ..\..\simutrans\pak128\*.*
del symbol.*.pak
copy *.pak ..\..\simutrans\pak128\*.*
del *.pak

cd ..\grounds
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\smokes
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\airports_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\catenary_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\crossings_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\depots_rail_road_tram
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\headquarters
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\pedestrians
..\..\makeobj.exe pak128 ../../simutrans/pak128/pedestrian.all.pak ./ >>..\..\err.txt

cd ..\powerlines
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\rail_bridges
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\rail_signals
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\rail_stations
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\rail_tracks
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\road_bridges
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\road_signs
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\road_stops
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\roads
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\schwebebahn_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\station_buildings
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\tram_tracks
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\tunnels_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\water_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\..\citycars
..\makeobj.exe pak128 ../simutrans/pak128/citycar.all.pak ./ >>..\err.txt

cd ..\factories
..\makeobj.exe pak128 ../simutrans/pak128/factories.all.pak ./ >>..\err.txt

cd "..\cityhouses\com"
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd "..\ind"
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd "..\res"
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd "..\..\special_buildings"
..\makeobj.exe pak128 ../simutrans/pak128/building.special.pak ./ >>..\err.txt

cd ..\trees
..\makeobj.exe pak128 ../simutrans/pak128/trees.all.pak ./ >>..\err.txt

cd ..\vehicles\airplanes
..\..\makeobj.exe pak176 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\monorail
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\rail-cargo
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\rail-engines
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\rail-psg+mail
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\road-cargo
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\road-psg+mail
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\ships-cargo
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\ships-ferries
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd ..\trams
..\..\makeobj.exe pak128 ../../simutrans/pak128/ ./ >>..\..\err.txt

cd..
cd..

rem del simutrans\pak128\config\*.*
rem copy config\*.tab simutrans\pak128\config\*.tab

rem Archiv packen
rem start /w ZipBackup.exe pak128.txt pak128