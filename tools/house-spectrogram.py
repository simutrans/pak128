#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2008
#  Python 2.5
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#

# read all dat files in all subfolders
# sort out houses
# build spectrogram-like image charts for count=f(level,year)

import os, copy
import simutools

Data = []
output = {"res":{}, "ind":{}, "com":{}, "*":{}} # init - dictionary of dictinaries

try :
	import pygame
	pygame.init()
except ImportError :
	print "This script needs PyGame to work!"
	print "Visit  http://www.pygame.org  to get it."
else :
	bkcolor = pygame.Color(0, 0, 128, 255)
	linecolor = pygame.Color(255, 255, 255, 255)
	textcolor = pygame.Color(255, 255, 255, 255)
	baseline = 64 # how much colour is added as zero level
	min_year = 1800 # start at 1800
	max_year = 2049 # finish in 2050
	year_diff = max_year - min_year
	year_step = 10 # number of years per grid part
	level_step = 5 # same for level
	m = 4 # size multiplier for chart images, must be > 1 or grid covers data, 4 fills screen nicely
	vspace = 20 # space on top and bottom of image, should be enough for label texts
	hspace = 20 # same for left & right
	
	fnt = pygame.font.SysFont('Verdana', 10)
	
	level_cap = 0
	
	# generate colourmaps - elements:
	cm_up1 = [i for i in xrange(0, 128, 4)] # ramp / 0-128
	cm_up2 = [i for i in xrange(128, 256, 4)] # ramp / 128-255
	cm_up = cm_up1 + cm_up2 # ramp / 0-255
	cm_eq0 = [0] * 32 # flat - 0
	cm_eq2 = [255] * 32 # flat - 255
	cm_down1 = copy.copy(cm_up2)
	cm_down1.reverse() # ramp \ 255-128
	cm_down2 = copy.copy(cm_up1)
	cm_down2.reverse() # ramp \ 128-0
	cm_down = cm_down1 + cm_down2 # ramp \ 255-0
	
	# generate colourmap - colour channels:
	jet_red = cm_eq0 * 3 + cm_up + cm_eq2 * 2 + cm_down1 # ___//--\
	jet_green = cm_eq0 + cm_up + cm_eq2 * 2 + cm_down + cm_eq0 # _//--\\_
	jet_blue = cm_up2 + cm_eq2 * 2 + cm_down + cm_eq0 * 3 # /--\\___
	# aka Jet Propulsion Laboratory pseudo-colour palette
	# this LUT is in 8 bpp resolution, each picture wil need its own (down-)resampling!
	
	print "Initialized."
	
	# load data
	simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data) # load stuff
	simutools.pruneObjs(Data, ["building"])
	# remember that industries and other types are still in, too - must filter by "type" further!
	
	print "Files loaded."
	
	# add harmless zero item so that there is at least one element - later some calls crash if passed empty lists
	position = (0,0)
	for type in output.keys() :
		output[type][position] = 0
	
	# load data from objects into sparse matrices
	counter = 0
	for obj in Data :
		type = obj.ask("type", "?").lower()
		level = int(obj.ask("level", -1))
		if (level != -1) and (type in output.keys()) :
			intro = max(int(obj.ask("intro_year", 1800)), min_year)
			retro = min(int(obj.ask("retire_year", 5000)), max_year)
			for year in xrange(intro, retro + 1) :
				position = (level, year) # sparse matrix indexing
				try :
					output[type][position] += 1
				except :
					output[type][position] = 1
				try :
					output["*"][position] += 1
				except :
					output["*"][position] = 1
			level_cap = max(level_cap, level) # update max. level - for chart axis
			counter += 1
	
	print "Data parsed, %d objects." % (counter)
	print "Highest level encountered", level_cap
	
	value_cap = dict(zip(output.keys(), [max(output[i].values()) for i in output.keys()]))
	# extract highest count seen, per type (for scaling the charts)
	
	# browse types
	for type, val_cap in value_cap.items() :
		print "Processing:", type
		
		if val_cap == 0 :
			print "  Empty!"
			continue # if no houses skip this one
		else :
			print "  Highest count:", val_cap
		
		surf = pygame.Surface((year_diff * m + hspace * 2, level_cap * m + vspace * 2 + 60))
		surf.fill(bkcolor) # clear
		print "  Cleaned."
		
		width = year_diff * m + hspace * 2 - 50 * 2
		
		for i in xrange (50, width + 50 +1, 1) :
			q = int(255.0 * (i - 50) / (width + 1)) # lut index
			q = q if q < 255 else 255 # last point is always bad
			start = (i, level_cap * m + vspace * 2 + 10)
			stop = (i, start[1] + 20)
			cl =  pygame.Color(jet_red[q], jet_green[q], jet_blue[q], 255)
			pygame.draw.line(surf, cl, start, stop, 1)
		# draw the scale bar line by line, iterating its place and grabbing proper colours
		
		for i in xrange(0, val_cap + 1, 1) :
			x = 50 + width * i / val_cap
			y = level_cap * m + vspace * 2 + 10
			start = (x, y)
			stop = (x, y + 20 + 2)
			pygame.draw.line(surf, linecolor, start, stop, 1)
			text = fnt.render(str(i), False, textcolor, bkcolor)
			surf.blit(text, (x - 5, y + 20 + 5 + 2))
		# draw lines corresponding with count values
		
		start = (50, y)
		stop = (50 + width, y)
		pygame.draw.line(surf, linecolor, start, stop, 1)
		# line at top of scale bar
		
		print "  Legend painted."
			
		
		# build local colormap - map house amounts (discrete values) to 0-255 scale
		colormap = [0] * (val_cap + 1)
		for i in xrange(0, val_cap + 1, 1) :
			q = int(255.0 * i / val_cap) # lut indexs
			colormap[i] = pygame.Color(jet_red[q], jet_green[q], jet_blue[q], 255) # extract colour from LUT
		print "  Colormap built."
		
		for year in xrange(min_year, max_year + 1) :
			for level in xrange(1, level_cap + 1) :
				position = (level, year)
				try :
					raw = output[type][position]
					r = pygame.Rect((year - min_year) * m + hspace, level * m + vspace, m, m)
					# left top width height
					surf.fill(colormap[raw], r)
				except KeyError:
					pass # skip empty positions
		print "  Plotted data."
		
		# ^ data image
		for year in xrange(min_year, max_year + 1, year_step) :
			start = ((year - min_year) * m + hspace, 0) # top
			stop = (start[0], (level_cap + 1) * m + vspace * 2 - 1) # bottom
			pygame.draw.line(surf, linecolor, start, stop, 1)
			text = fnt.render(str(year), False, textcolor, bkcolor)
			surf.blit(text, ((year - min_year) * m + hspace + 5, 5))
			surf.blit(text, ((year - min_year) * m + hspace + 5, vspace + (level_cap + 1) * m + 3))
		
		# ^ vertical grid + horizontal labels
		for level in xrange(0, level_cap + 1, level_step) :
			start = (0, level * m + vspace) # left 
			stop = (year_diff * m + hspace * 2 - 1, start[1]) # right
			pygame.draw.line(surf, linecolor, start, stop, 1)
			text = fnt.render(str(level), False, textcolor, bkcolor)
			surf.blit(text, (5, level * m + vspace + 5))
			surf.blit(text, (hspace + year_diff * m + 5, level * m + vspace + 5))
		# ^ horizontal grid + vertical labels
		
		print "  Grid and labels done."
		
		pygame.image.save(surf, "%s.png" % (type).replace("*", "all"))
		print "  Saved."

print "Termination: OK."

# EOF






