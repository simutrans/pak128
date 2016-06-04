@echo off

rem Updated 04/12/2012 by HDomos and Fabio Gonella
rem Last update 09/11/2013 by Fabio Gonella

echo Compile Pak128
echo ==============
echo.
echo This batch compiles to folder simutrans/pak128.
echo It requires the file makeobj.exe to be in the same
echo folder as this file pak128.bat.
echo.
if not exist .\makeobj.exe goto abort

rem delete old
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
rmdir /Q /S scenario
cd..
cd..
:skip_delete

rem copy config & translation

rem  ------------------------
xcopy /E pak128.prototype\*.* simutrans\pak128\
rem for newer Windows versions can be added /EXCLUDE:svn

rem new writing
rem  ------------------------
cd base
..\makeobj.exe pak128 ../simutrans/pak128/ ./ >..\err.txt

cd .\misc_GUI
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

echo Compiling Pedestrians

cd ..\pedestrians
..\..\makeobj.exe pak128 ../../simutrans/pak128/pedestrian.all.pak ./ >>..\..\err.txt

echo Compiling Smokes

cd ..\smokes
..\..\makeobj.exe pak128 ../../simutrans/pak128/smokes.all.pak ./ >>..\..\err.txt

echo Compiling Airport Tools

cd ..\..\infrastructure\airport_buildings_towers
..\..\makeobj.exe pak128 ../../simutrans/pak128/airports.buildings.pak ./ >>..\..\err.txt

cd ..\airport_depots
..\..\makeobj.exe pak128 ../../simutrans/pak128/airports.depots.pak ./ >>..\..\err.txt

cd ..\airport_ways_items
..\..\makeobj.exe pak128 ../../simutrans/pak128/airports.misc.pak ./ >>..\..\err.txt

echo Compiling Catenaries

cd ..\catenary_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/catenary.all.pak ./ >>..\..\err.txt

echo Compiling Crossings

cd ..\road_rail_crossings
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.crossing.road_rail.pak ./ >>..\..\err.txt

cd ..\road_water_crossings
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.crossing.road_water.pak ./ >>..\..\err.txt

cd ..\rail_water_crossings
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.crossing.rail_water.pak ./ >>..\..\err.txt

echo Compiling Depots

cd ..\depots_rail_road_tram
..\..\makeobj.exe pak128 ../../simutrans/pak128/depots.some.pak ./ >>..\..\err.txt

echo Compiling Headquarters

cd ..\headquarters
..\..\makeobj.exe pak128 ../../simutrans/pak128/building.hq.all.pak ./ >>..\..\err.txt

echo Compiling Powerlines

cd ..\powerlines
..\..\makeobj.exe pak176 ../../simutrans/pak128/powerlines.all.pak ./ >>..\..\err.txt

echo Compiling Rail tools

cd ..\rail_bridges
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.rail_bridges.all.pak ./ >>..\..\err.txt

cd ..\rail_elevated
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.rail_elevated.all.pak ./ >>..\..\err.txt

cd ..\rail_signals
..\..\makeobj.exe pak128 ../../simutrans/pak128/rail_signals.all.pak ./ >>..\..\err.txt

cd ..\rail_stations
..\..\makeobj.exe pak128 ../../simutrans/pak128/rail_station.all.pak ./ >>..\..\err.txt

cd ..\rail_tracks
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.rail_track.all.pak ./ >>..\..\err.txt

cd ..\rail_tunnels
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.rail_tunnels.all.pak ./ >>..\..\err.txt

echo Compiling Road Tools

cd ..\road_bridges
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.road_bridges.all.pak ./ >>..\..\err.txt

cd ..\road_elevated
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.road_elevated.all.pak ./ >>..\..\err.txt

cd ..\road_signs
..\..\makeobj.exe pak128 ../../simutrans/pak128/road_signs.all.pak ./ >>..\..\err.txt

cd ..\road_stops
..\..\makeobj.exe pak128 ../../simutrans/pak128/building.road_stop.all.pak ./ >>..\..\err.txt

cd ..\road_tunnels
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.road_tunnels.all.pak ./ >>..\..\err.txt

cd ..\roads
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.road.all.pak ./ >>..\..\err.txt

echo Compiling Monorail tools

cd ..\schwebebahn_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/schwebebahn.all.pak ./ >>..\..\err.txt

echo Compiling Station Buildings

cd ..\station_buildings
..\..\makeobj.exe pak128 ../../simutrans/pak128/ext_buildings.pak ./ >>..\..\err.txt

echo Compiling Tram tools

cd ..\tram_tracks
..\..\makeobj.exe pak128 ../../simutrans/pak128/way.tram_track.all.pak ./ >>..\..\err.txt

echo Compiling Water Tools

cd ..\water_all
..\..\makeobj.exe pak128 ../../simutrans/pak128/water_buildings.all.pak ./ >>..\..\err.txt

echo Compiling Citycars

cd ..\..\citycars
..\makeobj.exe pak128 ../simutrans/pak128/citycar.all.pak ./ >>..\err.txt

echo Compiling Cityhouses

cd ..\cityhouses\com
..\..\makeobj.exe pak128 ../../simutrans/pak128/city_com.all.pak ./ >>..\..\err.txt

cd ..\ind
..\..\makeobj.exe pak128 ../../simutrans/pak128/city_ind.all.pak ./ >>..\..\err.txt

cd ..\res
..\..\makeobj.exe pak128 ../../simutrans/pak128/city_res.all.pak ./ >>..\..\err.txt

cd ..\res\blocks
..\..\..\makeobj.exe pak128 ../../../simutrans/pak128/building.RES_blocks.pak ./ >>..\..\err.txt

echo Compiling factories

cd ..\..\..\factories
..\makeobj.exe pak128 ../simutrans/pak128/factories.all.pak ./ >>..\err.txt

cd ..\factories\powerplants
..\..\makeobj.exe pak128 ../../simutrans/pak128/powerplants.all.pak ./ >>..\..\err.txt

echo Compiling landscape

cd ..\..\landscape\groundobj_static
..\..\makeobj.exe pak128 ../../simutrans/pak128/groundobj.all.pak ./ >>..\err.txt

cd ..\grounds
..\..\makeobj.exe pak128 ../../simutrans/pak128/ground.all.pak ./ >..\..\err.txt

cd ..\rivers
..\..\makeobj.exe pak128 ../../simutrans/pak128/rivers.all.pak ./ >>..\err.txt

cd ..\trees
..\..\makeobj.exe pak128 ../../simutrans/pak128/trees.all.pak ./ >>..\err.txt

echo Compiling special buildings

cd ..\..\special_buildings\city
..\..\makeobj.exe pak128 ../../simutrans/pak128/building.special.city.pak ./ >>..\err.txt

cd ..\landscape
..\..\makeobj.exe pak128 ../../simutrans/pak128/building.special.landscape.pak ./ >>..\err.txt

cd ..\monuments
..\..\makeobj.exe pak128 ../../simutrans/pak128/building.special.monuments.pak ./ >>..\err.txt

cd ..\townhalls
..\..\makeobj.exe pak128 ../../simutrans/pak128/building.special.townhalls.pak ./ >>..\err.txt

echo Compiling Airplanes

cd ..\..\vehicles\airplanes
..\..\makeobj.exe pak176 ../../simutrans/pak128/airplanes.all.pak ./ >>..\..\err.txt

echo Compiling Monorail velicles

cd ..\monorail
..\..\makeobj.exe pak128 ../../simutrans/pak128/monorail_vehicles.all.pak ./ >>..\..\err.txt

echo Compiling Rail vehicles

cd ..\rail-cargo
..\..\makeobj.exe pak128 ../../simutrans/pak128/rail_cargo.all.pak ./ >>..\..\err.txt

cd ..\rail-engines
..\..\makeobj.exe pak128 ../../simutrans/pak128/locomotives.all.pak ./ >>..\..\err.txt

cd ..\rail-psg+mail
..\..\makeobj.exe pak128 ../../simutrans/pak128/passenger_trains.all.pak ./ >>..\..\err.txt

echo Compiling Road Vehicles

cd ..\road-cargo
..\..\makeobj.exe pak128 ../../simutrans/pak128/trucks.all.pak ./ >>..\..\err.txt

cd ..\road-psg+mail
..\..\makeobj.exe pak128 ../../simutrans/pak128/buses.all.pak ./ >>..\..\err.txt

echo Compiling Ships

cd ..\ships-cargo
..\..\makeobj.exe pak250 ../../simutrans/pak128/ships.all.pak ./ >>..\..\err.txt

cd ..\ships-ferries
..\..\makeobj.exe pak250 ../../simutrans/pak128/ferries.all.pak ./ >>..\..\err.txt

echo Compiling Trams

cd ..\trams
..\..\makeobj.exe pak128 ../../simutrans/pak128/trams.all.pak ./ >>..\..\err.txt

cd..
cd..

echo DONE
goto end

:abort
echo ERROR: makeobj.exe was not found in current folder.
pause

:end