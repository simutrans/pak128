# Makefile for pak128
# run "make all" to compile the pak
# run "make zip" to make a zip out of an already compiled pak
# run "make clean" to remove both compiled pak and zip file

# Just run
#   make clean all archives
# to get fresh and ready to deploy .tbz2 and .zip archives

MAKEOBJ ?= ./makeobj
LIGHTMAP ?= ./lightmap

PAKID ?= pak128 2.10.0 for 124.3

DESTDIR  ?= simutrans
PAKDIR   ?= $(DESTDIR)/pak128
ADDONDIR ?= $(DESTDIR)/addons/pak128
DESTFILE ?= simupak128

OUTSIDE :=
OUTSIDE += base/special

DIRS64 :=
DIRS64 += base/misc_GUI_64

DIRS128 :=
DIRS128 += base/misc_GUI
DIRS128 += base/pedestrians
DIRS128 += base/smokes
DIRS128 += citycars
DIRS128 += cityhouses/com
DIRS128 += cityhouses/com/no-winter
DIRS128 += cityhouses/ind
DIRS128 += cityhouses/ind/no-winter
DIRS128 += cityhouses/res
DIRS128 += cityhouses/res/blocks
DIRS128 += cityhouses/res/pioneer
DIRS128 += factories
DIRS128 += factories/powerplants
DIRS128 += infrastructure/airport_buildings_towers
DIRS128 += infrastructure/airport_depots
DIRS128 += infrastructure/airport_ways_items
DIRS128 += infrastructure/catenary_all
DIRS128 += infrastructure/depots_rail_road_tram
DIRS128 += infrastructure/headquarters
DIRS128 += infrastructure/rail_bridges
DIRS128 += infrastructure/rail_elevated
DIRS128 += infrastructure/rail_signals
DIRS128 += infrastructure/rail_stations
DIRS128 += infrastructure/rail_tracks
DIRS128 += infrastructure/rail_tunnels
DIRS128 += infrastructure/rail_water_crossings
DIRS128 += infrastructure/roads
DIRS128 += infrastructure/road_bridges
DIRS128 += infrastructure/road_elevated
DIRS128 += infrastructure/road_rail_crossings
DIRS128 += infrastructure/road_signs
DIRS128 += infrastructure/road_stops
DIRS128 += infrastructure/road_tunnels
DIRS128 += infrastructure/road_water_crossings
DIRS128 += infrastructure/schwebebahn_all
DIRS128 += infrastructure/station_buildings
DIRS128 += infrastructure/tram_tracks
DIRS128 += infrastructure/water_all
DIRS128 += landscape/groundobj_static
DIRS128 += landscape/grounds
DIRS128 += landscape/rivers
DIRS128 += landscape/trees
DIRS128 += special_buildings/city
DIRS128 += special_buildings/city/no-winter
DIRS128 += special_buildings/landscape
DIRS128 += special_buildings/landscape/no-winter
DIRS128 += special_buildings/monuments
DIRS128 += special_buildings/townhalls
DIRS128 += vehicles/monorail
DIRS128 += vehicles/rail-cargo
DIRS128 += vehicles/rail-engines
DIRS128 += vehicles/rail-psg+mail
DIRS128 += vehicles/road-cargo
DIRS128 += vehicles/road-psg+mail
DIRS128 += vehicles/trams

DIRS176 :=
DIRS176 += infrastructure/powerlines
DIRS176 += vehicles/airplanes

DIRS250 :=
DIRS250 += vehicles/ships-ferries
DIRS250 += vehicles/ships-cargo


ADDON_DIRS64 :=


DIRS := $(DIRS64) $(DIRS128) $(DIRS176) $(DIRS250)


.PHONY: $(DIRS) $(OUTSIDE) $(ADDON_DIRS64) copy tar zip

all: zip

archives: tar zip

tar: $(DESTFILE).tbz2
zip: $(DESTFILE).zip

install_win: pakset
	@rm -rf "C:\ProgramData\Simutrans\pak128"
	@cd simutrans
	@cp -R Simutrans/pak128 "C:\ProgramData\Simutrans"

$(DESTFILE).tbz2: pakset
	@echo "===> TAR $@"
	@tar cjf $@ $(DESTDIR)

$(DESTFILE).zip: pakset
	@echo "===> ZIP $@"
	@zip -rq $@ $(DESTDIR)

pakset: copy $(DIRS) $(OUTSIDE)

copy:
	@echo "===> COPY"
	@rm -rf $(PAKDIR)
	@mkdir -p $(PAKDIR)
	@cp -rp pak128.prototype/*  $(PAKDIR)
	@cp -p history-pak128-svn.txt $(PAKDIR)/doc
	@cp -p LICENSE.txt $(PAKDIR)/doc

$(DIRS64): copy
	@echo "===> PAK64 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) PAK $(PAKDIR)/ $@/ > /dev/null

$(DIRS128): copy
	@echo "===> PAK128 $@"
	@mkdir -p $(PAKDIR)
	@rm -f $@/*.pak
	@$(MAKEOBJ) verbose PAK128 $@/ $@/ > /dev/null
	@$(MAKEOBJ) quiet merge $(PAKDIR)/`echo $@ | sed s_/_._g`.all.pak $@/*.pak > /dev/null
	@rm -f $@/*.pak

$(DIRS176): copy
	@echo "===> PAK176 $@"
	@mkdir -p $(PAKDIR)
	@rm -f $@/*.pak
	@$(MAKEOBJ) verbose PAK176 $@/ $@/ > /dev/null
	@$(MAKEOBJ) quiet merge $(PAKDIR)/`echo $@ | sed s_/_._g`.all.pak $@/*.pak > /dev/null
	@rm -f $@/*.pak

$(DIRS250): copy
	@echo "===> PAK250 $@"
	@mkdir -p $(PAKDIR)
	@rm -f $@/*.pak
	@$(MAKEOBJ) verbose PAK250 $@/ $@/ > /dev/null
	@$(MAKEOBJ) quiet merge $(PAKDIR)/`echo $@ | sed s_/_._g`.all.pak $@/*.pak > /dev/null
	@rm -f $@/*.pak

$(OUTSIDE): copy
	@echo "===> Grounds calculations"
	@echo "===> OUTSIDE with REVISION and grounds"
	@mkdir -p $(PAKDIR)
	@echo "Id string: \"$(PAKID) git r`git rev-list --count --first-parent HEAD` hash `git rev-parse --short HEAD`"
	@printf "Obj=ground\nName=Outside\ncopyright=$(PAKID) git r%s hash %s\nImage[0][0]=tile.1.1\n-" `git rev-list --count --first-parent HEAD` `git rev-parse --short HEAD` > $@/outside.dat
	$(MAKEOBJ) quiet PAK128 $(PAKDIR)/ $@/ > /dev/null
	@rm $@/outside.dat

calclight:
	@echo "===> MAKE lightmaps and borders (not recommended)"
	@$(LIGHTMAP) -pak128 -marker16 -c#0xFF8000 landscape/grounds/marker.png
	@$(LIGHTMAP) -pak128 -marker16 -c#0x202020 landscape/grounds/borders.png
	@$(LIGHTMAP) -pak128 -slope16 -bright128 landscape/grounds/texture-lightmap.png

merge:

clean:
	@echo "===> CLEAN"
#	@rm ground/marker.png
#	@rm ground/borders.png
#	@rm ground/texture-lightmap.png
	@rm -fr $(PAKDIR) $(DESTFILE).tbz2 $(DESTFILE).zip

