# Makefile based on the pak64 Makefile. Thank you prissi et al!
# Makefile for pak128-britain standard and experimental
# 2010-06 sdog 
# 2010-06 neroden
# 2011-01 sdog (adopting for pak128)
# 2013-09 kierongreen
# 2013-11 Fabio Gonella
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
DIRS128 += special_buildings/city
DIRS128 += special_buildings/landscape
DIRS128 += special_buildings/monuments
DIRS128 += special_buildings/townhalls
DIRS128 += citycars
DIRS128 += landscape/grounds
DIRS128 += landscape/trees
DIRS128 += landscape/groundobj_static
DIRS128 += base
DIRS128 += base/pedestrians
DIRS128 += base/smokes
DIRS128 += landscape/rivers

INFRASTRUCTURE128 :=
INFRASTRUCTURE128 += airport_buildings_towers
INFRASTRUCTURE128 += airport_depots
INFRASTRUCTURE128 += airport_ways_items
INFRASTRUCTURE128 += catenary_all
#INFRASTRUCTURE128 += crossings_all
INFRASTRUCTURE128 += road_rail_crossings_all
INFRASTRUCTURE128 += road_water_crossings_all
INFRASTRUCTURE128 += rail_water_crossings_all
INFRASTRUCTURE128 += depots_rail_road_tram
INFRASTRUCTURE128 += headquarters
#INFRASTRUCTURE128 += powerlines
INFRASTRUCTURE128 += rail_bridges
INFRASTRUCTURE128 += rail_elevated
INFRASTRUCTURE128 += rail_signals
INFRASTRUCTURE128 += rail_stations
INFRASTRUCTURE128 += rail_tracks
INFRASTRUCTURE128 += rail_tunnels
INFRASTRUCTURE128 += road_bridges
INFRASTRUCTURE128 += road_elevated
INFRASTRUCTURE128 += road_signs
INFRASTRUCTURE128 += road_stops
INFRASTRUCTURE128 += road_tunnels
INFRASTRUCTURE128 += roads
INFRASTRUCTURE128 += schwebebahn_all
INFRASTRUCTURE128 += station_buildings
INFRASTRUCTURE128 += tram_tracks
INFRASTRUCTURE128 += water_all
INFRASTRUCTURE128 += compatibility

DIRS128 += $(addprefix infrastructure/,$(INFRASTRUCTURE128))

#these will get special treatment below
#DIRGROUNDS:= landscape/grounds
DIRLOGO := base/misc_GUI


#other sizes for boats etc
DIRS160 := infrastructure/powerlines

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

$(DIRS160):
	@echo "===> PAK160 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK160 $(PAKDIR)/$(call make_name,$@) $@/ > /dev/null	
	
$(DIRS176):
	@echo "===> PAK176 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK176 $(PAKDIR)/$(call make_name,$@) $@/ > /dev/null

$(DIRS250):
	@echo "===> PAK250 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK250 $(PAKDIR)/$(call make_name,$@) $@/ > /dev/null


#$(DIRGROUNDS):
#	@echo "===> ground.Outside.pak"
#	@mkdir -p $(PAKDIR)
#	@$(MAKEOBJ) quiet PAK128 $(PAKDIR)/$(call make_name,$@) $@/ > /dev/null
#	@$(MAKEOBJ) quiet PAK128 temp.pak $@/ > /dev/null
#	@$(MAKEOBJ) quiet EXTRACT temp.pak > /dev/null
#	@rm temp.pak
#	@mv ground.Outside.pak $(PAKDIR)/
#	@$(MAKEOBJ) quiet MERGE $(PAKDIR)/$(call make_name,$@) *.pak > /dev/null
#	@rm *.pak

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
