# Makefile based on the pak64 Makefile. Thank you prissi et al!
# Makefile for pak128-britain standard and experimental
# 2010-06 sdog 
# 2010-06 neroden
# 2011-01 sdog (adopting for pak128)
#
# Just run
#   make clean all archives
# to get fresh and ready to deploy .tbz2 and .zip archives
#
# version in pak128 svn by sdog, downloaded from:
# https://github.com/sdog/simutrans-pak128/raw/master/Makefile
#
CONFIG ?= config.default
-include $(CONFIG)

MAKEOBJ ?= ./makeobj

PAKNAME ?= pak128
DESTDIR  ?= .
PAKDIR   ?= $(DESTDIR)/$(PAKNAME)
DESTFILE ?= $(PAKNAME)

NAMEPREFIX ?=
NAMESUFFIX ?=

CPFILES ?= pak128.prototype/*

DIRS64 :=
DIRS64 += base/misc_GUI_64

#DIRS128VEHICLES := airplanes
DIRS128VEHICLES += monorail
DIRS128VEHICLES += rail-cargo
DIRS128VEHICLES += rail-engines
DIRS128VEHICLES += rail-psg+mail
DIRS128VEHICLES += road-cargo
DIRS128VEHICLES += road-psg+mail
DIRS128VEHICLES += trams

DIRS128 := $(addprefix vehicles/,$(DIRS128VEHICLES))

DIRS128 += factories 
DIRS128 += factories/powerplants
DIRS128 += cityhouses/com 
DIRS128 += cityhouses/ind
DIRS128 += cityhouses/res 
DIRS128 += special_buildings/monuments
DIRS128 += special_buildings/townhalls
DIRS128 += citycars
DIRS128 += trees
DIRS128 += base

BASE128 :=
BASE128 += airport_buildings_towers
BASE128 += airport_depots
BASE128 += airport_ways_items
BASE128 += catenary_all
BASE128 += crossings_all
BASE128 += depots_rail_road_tram
BASE128 += headquarters
BASE128 += pedestrians
BASE128 += powerlines
BASE128 += rail_bridges
BASE128 += rail_signals
BASE128 += rail_stations
BASE128 += rail_tracks
BASE128 += road_bridges
BASE128 += road_signs
BASE128 += road_stops
BASE128 += roads
BASE128 += schwebebahn_all
BASE128 += smokes
BASE128 += station_buildings
BASE128 += tram_tracks
BASE128 += tunnels_all
BASE128 += water_all

DIRS128 += $(addprefix base/,$(BASE128))

#those two will get special treatment below
DIRGROUNDS:= base/grounds
DIRLOGO := base/misc_GUI


#other sizes for boats etc
DIRS176 := vehicles/airplanes

DIRS250 := vehicles/ships-cargo
DIRS250 += vehicles/ships-ferries

DIRS := $(DIRS64) $(DIRS128) $(DIRS176) $(DIRS250) $(DIRLOGO) $(DIRGROUNDS)

#generating filenames
#with this function the filenames are assembled, by removing the dir, adding prefix
#and suffix
make_name = $(NAMEPREFIX)$(subst /,.,$(subst psg+mail,pax,$1))$(NAMESUFFIX).pak
#make_name = $(NAMEPREFIX)$(notdir $1)$(NAMESUFFIX)


.PHONY: $(DIRS) copy tar zip clean

all: copy $(DIRS)

archives: tar zip

tar: $(DESTFILE).tbz2
zip: $(DESTFILE).zip

$(DESTFILE).tbz2: $(PAKDIR)
	@echo "===> TAR $@"
	@tar cjf $@ $(DESTDIR)

$(DESTFILE).zip: $(PAKDIR)
	@echo "===> ZIP $@"
	@zip -rq $@ $(DESTDIR)

copy:
	@echo "===> COPY"
	@mkdir -p $(PAKDIR)
	@cp -prt $(PAKDIR) $(CPFILES)

$(DIRS64):
	@echo "===> PAK64 $@"
	@mkdir -p $(PAKDIR)
	$(MAKEOBJ) quiet PAK $(PAKDIR)/base.gui64.pak $@/ > /dev/null
	#$(MAKEOBJ) quiet PAK $(PAKDIR)/$(call make_name,$@) $@/ > /dev/null

$(DIRS128):
	@echo "===> PAK128 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) PAK128 $(PAKDIR)/$(call make_name,$@) $@/ > /dev/null

$(DIRS176):
	@echo "===> PAK176 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK176 $(PAKDIR)/$(call make_name,$@) $@/ > /dev/null

$(DIRS250):
	@echo "===> PAK250 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK250 $(PAKDIR)/$(call make_name,$@) $@/ > /dev/null


$(DIRGROUNDS):
	@echo "===> ground.Outside.pak"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK128 temp.pak $@/ > /dev/null
	@$(MAKEOBJ) quiet EXTRACT temp.pak > /dev/null
	@rm temp.pak
	@mv ground.Outside.pak $(PAKDIR)/
	@$(MAKEOBJ) quiet MERGE $(PAKDIR)/$(call make_name,$@) *.pak > /dev/null
	@rm *.pak

$(DIRLOGO):
	@echo "===> logo & misc gui"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK128 tmp.pak $@/ > /dev/null
	@$(MAKEOBJ) quiet EXTRACT tmp.pak > /dev/null
	@rm tmp.pak
	@mv symbol.BigLogo.pak $(PAKDIR)/
	@$(MAKEOBJ) quiet MERGE $(PAKDIR)/base.gui128.pak *.pak > /dev/null
	@rm *.pak



clean:
	@echo "===> CLEAN"
	@rm -fr $(PAKDIR) $(DESTFILE).tbz2 $(DESTFILE).zip
