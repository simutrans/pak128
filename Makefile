# Makefile for pak128
# run "make all" to compile the pak
# run "make zip" to make a zip out of an already compiled pak
# run "make clean" to remove both compiled pak and zip file

MAKEOBJ = ./makeobj
DEST = ./simutrans/pak128/
ZIPFILE = ./pak128.zip

all:
	make clean
	mkdir -p $(DEST)
	make pakFiles
	cp -r pak128.prototype/* $(DEST)/
	make zip

.PHONY: $(DIRS) zip clean pakFiles

pakFiles: \
$(DEST)/symbol.BigLogo.pak\
$(DEST)/base.pak\
$(DEST)/ground.Outside.pak\
$(DEST)/pedestrian.all.pak\
$(DEST)/smokes.all.pak\
$(DEST)/airports.buildings.pak\
$(DEST)/airports_depots.pak\
$(DEST)/airports.misc.pak\
$(DEST)/catenary.all.pak\
$(DEST)/way.crossing.road_rail.pak\
$(DEST)/way.crossing.road_water.pak\
$(DEST)/way.crossing.rail_water.pak\
$(DEST)/depots.some.pak\
$(DEST)/building.hq.all.pak\
$(DEST)/powerlines.all.pak\
$(DEST)/way.rail_bridges.all.pak\
$(DEST)/way.rail_elevated.all.pak\
$(DEST)/rail_signals.all.pak\
$(DEST)/rail_stations.all.pak\
$(DEST)/way.rail_tracks.all.pak\
$(DEST)/way.rail_tunnels.all.pak\
$(DEST)/way.road_bridges.all.pak\
$(DEST)/way.road_elevated.all.pak\
$(DEST)/road_signs.all.pak\
$(DEST)/building.road_stop.all.pak\
$(DEST)/way.road_tunnels.all.pak\
$(DEST)/way.road.all.pak\
$(DEST)/schwebebahn.all.pak\
$(DEST)/ext_buildings.pak\
$(DEST)/way.tram_track.all.pak\
$(DEST)/water_buildings.all.pak\
$(DEST)/citycar.all.pak\
$(DEST)/city_com.all.pak\
$(DEST)/city_ind.all.pak\
$(DEST)/city_res.all.pak\
$(DEST)/building.RES_blocks.pak\
$(DEST)/factories.all.pak\
$(DEST)/powerplants.all.pak\
$(DEST)/groundobj.all.pak\
$(DEST)/ground.all.pak\
$(DEST)/rivers.all.pak\
$(DEST)/trees.all.pak\
$(DEST)/building.special.city.pak\
$(DEST)/building.special.landscape.pak\
$(DEST)/building.special.monuments.pak\
$(DEST)/building.special.townhalls.pak\
$(DEST)/airplanes.all.pak\
$(DEST)/monorail_vehicles.all.pak\
$(DEST)/rail_cargo.all.pak\
$(DEST)/locomotives.all.pak\
$(DEST)/passenger_trains.all.pak\
$(DEST)/trucks.all.pak\
$(DEST)/buses.all.pak\
$(DEST)/ships.all.pak\
$(DEST)/ferries.all.pak\
$(DEST)/trams.all.pak

zip:
	zip -rq $(ZIPFILE) $(DEST)

clean:
	rm -f $(ZIPFILE)
	rm -rf $(DEST)


# symbol.biglogo.pak cannot be merged in multiple pak files, must stay as a single file.
$(DEST)/symbol.BigLogo.pak: ./base/misc_GUI/BigLogo.dat ./base/misc_GUI/biglogo.png
	$(MAKEOBJ) pak128 $@ $<

$(DEST)/base.pak:
	$(MAKEOBJ) pak128 ./base/misc_GUI/ ./base/misc_GUI/
	rm -f ./base/misc_GUI/symbol.BigLogo.pak
	$(MAKEOBJ) pak ./base/misc_GUI_64/ ./base/misc_GUI_64/
	$(MAKEOBJ) merge $@ ./base/misc_GUI/*.pak ./base/misc_GUI_64/*.pak
	rm ./base/misc_GUI/*.pak ./base/misc_GUI_64/*.pak

$(DEST)/ground.Outside.pak: ./base/version-pak128.dat ./base/tile.png
	$(MAKEOBJ) pak128 $@ $<

$(DEST)/pedestrian.all.pak:
	$(MAKEOBJ) pak128 $@ ./base/pedestrians/

$(DEST)/smokes.all.pak:
	$(MAKEOBJ) pak128 $@ ./base/smokes/

$(DEST)/airports.buildings.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/airport_buildings_towers/

$(DEST)/airports_depots.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/airport_depots/

$(DEST)/airports.misc.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/airport_ways_items/

$(DEST)/catenary.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/catenary_all/

$(DEST)/way.crossing.road_rail.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/road_rail_crossings/

$(DEST)/way.crossing.road_water.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/road_water_crossings/

$(DEST)/way.crossing.rail_water.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/rail_water_crossings/

$(DEST)/depots.some.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/depots_rail_road_tram/

$(DEST)/building.hq.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/headquarters/

$(DEST)/powerlines.all.pak:
	$(MAKEOBJ) pak176 $@ ./infrastructure/powerlines/

$(DEST)/way.rail_bridges.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/rail_bridges/

$(DEST)/way.rail_elevated.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/rail_elevated/

$(DEST)/rail_stations.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/rail_stations/

$(DEST)/rail_signals.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/rail_signals/

$(DEST)/way.rail_tracks.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/rail_tracks/

$(DEST)/way.rail_tunnels.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/rail_tunnels/

$(DEST)/way.road_bridges.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/road_bridges/

$(DEST)/way.road_elevated.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/road_elevated/

$(DEST)/road_signs.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/road_signs/

$(DEST)/building.road_stop.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/road_stops/

$(DEST)/way.road_tunnels.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/road_tunnels/

$(DEST)/way.road.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/roads/

$(DEST)/schwebebahn.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/schwebebahn_all/

$(DEST)/ext_buildings.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/station_buildings/

$(DEST)/way.tram_track.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/tram_tracks/

$(DEST)/water_buildings.all.pak:
	$(MAKEOBJ) pak128 $@ ./infrastructure/water_all/

$(DEST)/citycar.all.pak:
	$(MAKEOBJ) pak128 $@ ./citycars/

$(DEST)/city_com.all.pak:
	$(MAKEOBJ) pak128 $@ ./cityhouses/com/

$(DEST)/city_ind.all.pak:
	$(MAKEOBJ) pak128 $@ ./cityhouses/ind/

$(DEST)/city_res.all.pak:
	$(MAKEOBJ) pak128 $@ ./cityhouses/res/

$(DEST)/building.RES_blocks.pak:
	$(MAKEOBJ) pak128 $@ ./cityhouses/res/blocks/

$(DEST)/factories.all.pak:
	$(MAKEOBJ) pak128 $@ ./factories/

$(DEST)/powerplants.all.pak:
	$(MAKEOBJ) pak128 $@ ./factories/powerplants/

$(DEST)/groundobj.all.pak:
	$(MAKEOBJ) pak128 $@ ./landscape/groundobj_static/

$(DEST)/ground.all.pak:
	$(MAKEOBJ) pak128 $@ ./landscape/grounds/

$(DEST)/rivers.all.pak:
	$(MAKEOBJ) pak128 $@ ./landscape/rivers/

$(DEST)/trees.all.pak:
	$(MAKEOBJ) pak128 $@ ./landscape/trees/

$(DEST)/building.special.city.pak:
	$(MAKEOBJ) pak128 $@ ./special_buildings/city/

$(DEST)/building.special.landscape.pak:
	$(MAKEOBJ) pak128 $@ ./special_buildings/landscape/

$(DEST)/building.special.monuments.pak:
	$(MAKEOBJ) pak128 $@ ./special_buildings/monuments/

$(DEST)/building.special.townhalls.pak:
	$(MAKEOBJ) pak128 $@ ./special_buildings/townhalls/

$(DEST)/airplanes.all.pak:
	$(MAKEOBJ) pak176 $@ ./vehicles/airplanes/

$(DEST)/monorail_vehicles.all.pak:
	$(MAKEOBJ) pak128 $@ ./vehicles/monorail/

$(DEST)/rail_cargo.all.pak:
	$(MAKEOBJ) pak128 $@ ./vehicles/rail-cargo/

$(DEST)/locomotives.all.pak:
	$(MAKEOBJ) pak128 $@ ./vehicles/rail-engines/

$(DEST)/passenger_trains.all.pak:
	$(MAKEOBJ) pak128 $@ ./vehicles/rail-psg+mail/

$(DEST)/trucks.all.pak:
	$(MAKEOBJ) pak128 $@ ./vehicles/road-cargo/

$(DEST)/buses.all.pak:
	$(MAKEOBJ) pak128 $@ ./vehicles/road-psg+mail/

$(DEST)/ships.all.pak:
	$(MAKEOBJ) pak250 $@ ./vehicles/ships-cargo/

$(DEST)/ferries.all.pak:
	$(MAKEOBJ) pak250 $@ ./vehicles/ships-ferries/

$(DEST)/trams.all.pak:
	$(MAKEOBJ) pak128 $@ ./vehicles/trams/

