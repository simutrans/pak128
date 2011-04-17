#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2008 - 2011
#  Python 2.6, 3.1
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#

# read all dat files in all subfolders
# keep only vehicles
# split by waytype and chart speeds over time
# outputs csv files

import os, math

import simutools

#-----

class VehicleDates :
	def __init__(self, intro, outro, speed) :
		self.intro = intro
		self.outro = outro
		self.speed = speed
	def __repr__(self) :
		return "intro: " + str(self.intro) + ", outro: " + str(self.outro) + ", speed = " + str(self.speed)

#-----

Data = []

simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data) # load stuff

i = len(Data) - 1
while i > -1 :
	d = Data[i]
	if d.ask("obj","").lower() != "vehicle" :
		del Data[i] # is not a vehicle
	i = i - 1
# keep only vehicles

timedata = {
	"road": [],
	"air": [], 
	"water": [],
	"track": [],
	"tram_track": [],
	"monorail_track": [],
	"maglev_track": [],
	"narrowgauge_track": [],
	}

for veh in Data :
	intro = veh.ask("intro_year", 0)
	outro = veh.ask("retire_year", 5000)
	speed = veh.ask("speed", 0)
	way = veh.ask("waytype")
	if way != None and speed > 0 :
		# is real?
		obj = VehicleDates(intro, outro, speed)
		way = way.lower()
		if way == "schiene_tram" :
			way = "tram_track"
		elif way == "electrified_track" :
			way = "track"
		# correct old waytypes
		timedata[way].append(obj)
		# sort into categories by waytype
# vehicle dates are now prepared

for waytype in timedata.keys() :
	f = open("vehtimedata-" + waytype + ".csv", 'w')
	f.write("year;min;med;avg;max\n")
	for year in range(1830, 2080, 1) :
		yeardata = []
		eternal = True
		for veh in timedata[waytype] :
			if veh.intro <= year and veh.outro > year :
				yeardata.append(veh.speed)
				if veh.outro != 5000 :
					eternal = False
		if len(yeardata) > 1 :
			yeardata.sort()
			min = yeardata[0]
			max = yeardata[-1]
			med = yeardata[int(math.ceil(len(yeardata)/2.0))]
			avg = sum(yeardata) / float(len(yeardata))
			f.write(str(year) + ";" + str(min) + ";" + str(med) + ";" + str(avg) + ";" + str(max) + "\n")
		elif len(yeardata) == 1 :
			val = yeardata[0]
			f.write(str(year) + ";" + str(val) + ";" + str(val) + ";" + str(val) + ";" + str(val) + "\n")
		elif len(yeardata) == 0 :
			# no vehicles => nothing is eternal :-)
			eternal = False
		if eternal :
			break
	f.write("\n\n")
	f.close()
# browse data and construct min, max, average and median

# EOF
