@echo off

rem Updated 04/12/2012 by HDomos and Fabio Gonella
rem Updated 09/11/2013 by Fabio Gonella
rem Updated 19/04/2017 by Gauthier Nottret

echo Compile Pak128
echo ==============
echo.
echo This batch compiles to folder simutrans/pak128.
echo It requires the file makeobj.exe to be in the same
echo folder as this file pak128.bat.
echo.
if not exist makeobj.exe goto abort

rem delete old
rem  ------------------------
del pak128.zip
if errorlevel 1 goto skip_delete
rem if folder does not exist, skip deleting old data
echo removing old data
rmdir /s /q simutrans\pak128
:skip_delete

mkdir simutrans\pak128

rem copy config & translation
rem  ------------------------
xcopy /E pak128.prototype\*.* simutrans\pak128\
rem for newer Windows versions can be added /EXCLUDE:svn

rem new writing
rem  ------------------------
( 
  echo obj=ground>version-pak128.dat
  echo name=Outside>>version-pak128.dat
  echo copyright="pak128 2.10.0 for 124.3" >>version-pak128.dat
)
makeobj.exe pak128 simutrans/pak128/ground.Outside.pak version-pak128.dat
del version-pak128.dat

rem symbol.biglogo.pak must stay a single file - so it is copied into the pak folder before the others are moved and merged
makeobj.exe pak128 simutrans/pak128/symbol.BigLogo.pak base/misc_GUI/BigLogo.dat

makeobj.exe pak128 base/misc_GUI/ base/misc_GUI/
del base/misc_GUI/symbol.BigLogo.pak
makeobj.exe pak base/misc_GUI_64/ base/misc_GUI_64/
makeobj.exe merge simutrans/pak128/base.pak base/misc_GUI/*.pak base/misc_GUI_64/*.pak
del simutrans/pak128/base.pak base/misc_GUI/*.pak base/misc_GUI_64/*.pak

echo Compiling Pedestrians
makeobj.exe pak128 simutrans/pak128/pedestrian.all.pak base/pedestrians/

echo Compiling Smokes
makeobj.exe pak128 simutrans/pak128/smokes.all.pak base/smokes/

echo Compiling Airport Tools
makeobj.exe pak128 simutrans/pak128/airports.buildings.pak infrastructure/airport_buildings_towers/
makeobj.exe pak128 simutrans/pak128/airports.depots.pak infrastructure/airport_depots/
makeobj.exe pak128 simutrans/pak128/airports.misc.pak infrastructure/airport_ways_items/

echo Compiling Catenaries
makeobj.exe pak128 simutrans/pak128/catenary.all.pak infrastructure/catenary_all/

echo Compiling Crossings
makeobj.exe pak128 simutrans/pak128/way.crossing.road_rail.pak infrastructure/road_rail_crossings/
makeobj.exe pak128 simutrans/pak128/way.crossing.road_water.pak infrastructure/road_water_crossings/
makeobj.exe pak128 simutrans/pak128/way.crossing.rail_water.pak infrastructure/rail_water_crossings/

echo Compiling Depots
makeobj.exe pak128 simutrans/pak128/depots.some.pak infrastructure/depots_rail_road_tram/

echo Compiling Headquarters
makeobj.exe pak128 simutrans/pak128/building.hq.all.pak infrastructure/headquarters/

echo Compiling Powerlines
makeobj.exe pak176 simutrans/pak128/powerlines.all.pak infrastructure/powerlines/

echo Compiling Rail tools
makeobj.exe pak128 simutrans/pak128/way.rail_bridges.all.pak infrastructure/rail_bridges/
makeobj.exe pak128 simutrans/pak128/way.rail_elevated.all.pak infrastructure/rail_elevated/
makeobj.exe pak128 simutrans/pak128/rail_signals.all.pak infrastructure/rail_signals/
makeobj.exe pak128 simutrans/pak128/rail_station.all.pak infrastructure/rail_stations/
makeobj.exe pak128 simutrans/pak128/way.rail_track.all.pak infrastructure/rail_tracks/
makeobj.exe pak128 simutrans/pak128/way.rail_tunnels.all.pak infrastructure/rail_tunnels/

echo Compiling Road Tools
makeobj.exe pak128 simutrans/pak128/way.road_bridges.all.pak infrastructure/road_bridges/
makeobj.exe pak128 simutrans/pak128/way.road_elevated.all.pak infrastructure/road_elevated/
makeobj.exe pak128 simutrans/pak128/road_signs.all.pak infrastructure/road_signs/
makeobj.exe pak128 simutrans/pak128/building.road_stop.all.pak infrastructure/road_stops/
makeobj.exe pak128 simutrans/pak128/way.road_tunnels.all.pak infrastructure/road_tunnels/
makeobj.exe pak128 simutrans/pak128/way.road.all.pak infrastructure/roads/

echo Compiling Monorail tools
makeobj.exe pak128 simutrans/pak128/schwebebahn.all.pak infrastructure/schwebebahn_all/

echo Compiling Station Buildings
makeobj.exe pak128 simutrans/pak128/ext_buildings.pak infrastructure/station_buildings/

echo Compiling Tram tools
makeobj.exe pak128 simutrans/pak128/way.tram_track.all.pak infrastructure/tram_tracks/

echo Compiling Water Tools
makeobj.exe pak128 simutrans/pak128/water_buildings.all.pak infrastructure/water_all/

echo Compiling Citycars
makeobj.exe pak128 simutrans/pak128/citycar.all.pak citycars/

echo Compiling Cityhouses
makeobj.exe pak128 simutrans/pak128/city_com.all.pak cityhouses/com/
makeobj.exe pak128 simutrans/pak128/city_com.no-winter.pak cityhouses/com/no-winter
makeobj.exe pak128 simutrans/pak128/city_ind.all.pak cityhouses/ind/
makeobj.exe pak128 simutrans/pak128/city_ind.no-winter.pak cityhouses/ind/no-winter
makeobj.exe pak128 simutrans/pak128/city_res.all.pak cityhouses/res/
makeobj.exe pak128 simutrans/pak128/city_res.blocks.pak cityhouses/res/blocks
makeobj.exe pak128 simutrans/pak128/city_res.pioneer.pak cityhouses/res/pioneer

echo Compiling factories
makeobj.exe pak128 simutrans/pak128/factories.all.pak factories/
makeobj.exe pak128 simutrans/pak128/powerplants.all.pak factories/powerplants/

echo Compiling landscape
makeobj.exe pak128 simutrans/pak128/groundobj.all.pak landscape/groundobj_static/
makeobj.exe pak128 simutrans/pak128/ground.all.pak landscape/grounds/
makeobj.exe pak128 simutrans/pak128/rivers.all.pak landscape/rivers/
makeobj.exe pak128 simutrans/pak128/trees.all.pak landscape/trees/

echo Compiling special buildings
makeobj.exe pak128 simutrans/pak128/building.special.city.pak  special_buildings/city/
makeobj.exe pak128 simutrans/pak128/building.special.city.no-winter.pak  special_buildings/city/no-winter
makeobj.exe pak128 simutrans/pak128/building.special.landscape.pak  special_buildings/landscape/
makeobj.exe pak128 simutrans/pak128/building.special.monuments.pak  special_buildings/monuments/
makeobj.exe pak128 simutrans/pak128/building.special.townhalls.pak  special_buildings/townhalls/

echo Compiling Airplanes
makeobj.exe pak176 simutrans/pak128/airplanes.all.pak vehicles/airplanes/

echo Compiling Monorail velicles
makeobj.exe pak128 simutrans/pak128/monorail_vehicles.all.pak vehicles/monorail/

echo Compiling Rail vehicles
makeobj.exe pak128 simutrans/pak128/rail_cargo.all.pak vehicles/rail-cargo/
makeobj.exe pak128 simutrans/pak128/locomotives.all.pak vehicles/rail-engines/
makeobj.exe pak128 simutrans/pak128/passenger_trains.all.pak vehicles/rail-psg+mail/

echo Compiling Road Vehicles
makeobj.exe pak128 simutrans/pak128/trucks.all.pak vehicles/road-cargo/
makeobj.exe pak128 simutrans/pak128/horses.all.pak vehicles/road-horses/
makeobj.exe pak128 simutrans/pak128/buses.all.pak vehicles/road-psg+mail/

echo Compiling Ships
makeobj.exe pak250 simutrans/pak128/ships.all.pak vehicles/ships-cargo/
makeobj.exe pak250 simutrans/pak128/ferries.all.pak vehicles/ships-ferries/

echo Compiling Trams
makeobj.exe pak128 simutrans/pak128/trams.all.pak vehicles/trams/

echo DONE
goto end

:abort
echo ERROR: makeobj.exe was not found in current folder.
pause

:end