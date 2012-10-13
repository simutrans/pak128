#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2010 - 2011
#  Python 2.6
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#
#
# creates a timeline chart for given objects

#-----

from __future__ import print_function

#-----

paksize = 128 # default only
stop_year = 2050 # don't plot after this date

font_name = "Verdana"
font_size = 10 # unknown units!
font_aa = False # antialiasing

month_width = 1 # px
bin_width = 10 # years
bin_height = 5 # items
item_height = 20 # px

left_margin = 250 # px
right_margin = 80 # px
vertical_margin = 10 # px
bin_text_space = 12 # px

parameter_bar_max = 50 # px

background_color = (231,255,255)
grid_color = (0,0,0)
name_color = (128,128,128)
power_color = (0,0,255)
speed_color = (0,128,0)
data_color_normal = (192,192,192)
data_color_nointro = (255,192,192)
data_color_noretire = (168,228,168)
data_color_always = (255,255,255)
data_color_unfree = (255,192,192)
data_color_replaced = (150,200,255)

filter_goods = [] # if not empty [], only vehicles for these goods will be plotted
filter_goods_invert = False # inverts the goods logic fom "only these" to "all except these"

filter_ways = [] # same as goods

filter_powered = False # only with power>0
filter_front = False # only with Constraint[Prev]=none present

filter_authors = [] # same as goods

#-----

import os
import simutools

Data = []

canvas = None
font = None

start_year = 0
end_year = 10000

max_speed = 0
max_power = 0

year_width = month_width * 12
bin_height_px = bin_height * item_height + bin_text_space

check_authors = False
check_compat = False

compat = {}

#-----

def objCompare(A, B) :
	# first should come object with earlier dates!
	a_intro = int(A.ask("intro_year", 0)) * 12 + int(A.ask("intro_month", 0))
	b_intro = int(B.ask("intro_year", 0)) * 12 + int(B.ask("intro_month", 1)) - 1
	if a_intro != b_intro :
		return cmp(a_intro, b_intro)
	else :
		a_retro = int(A.ask("retire_year", 2999)) * 12 + int(A.ask("retire_month", 0))
		b_retro = int(B.ask("retire_year", 2999)) * 12 + int(B.ask("retire_month", 1)) - 1
		return cmp(a_retro, b_retro)

#-----

def prepareCanvas() :
	global start_year, end_year, canvas, max_speed, max_power
	
	start_year = 0
	i = 0
	while start_year == 0 :
		start_year = int(Data[i].ask("intro_year", "0"))
		i += 1
	# intro is primary sorting, so just skip the first items without intro date
	
	end_year_retire = 0
	end_year_intro = 0
	for item in Data :
		intro_year = int(item.ask("intro_year", 0))
		retire_year = int(item.ask("retire_year", 0))
		intro_month = int(item.ask("intro_month", 1)) - 1
		retire_month = int(item.ask("retire_month", 1)) - 1
		if (intro_year * 12 + intro_month) < (retire_year * 12 + retire_month) or (retire_year == 0):
			# check for valid timeline (disabling)
			end_year_retire = max(end_year_retire, retire_year)
			end_year_intro = max(end_year_intro, intro_year)
		max_power = max(max_power, (int(item.ask("power", 0)) * int(item.ask("gear", 100))) / 100)
		max_speed = max(max_speed, int(item.ask("speed", 0)))
	
	# all else is not sorted or has special cases and must be found in the whole dataset
	
	end_year = min(max(end_year_retire, end_year_intro) + 20, stop_year)
	
	width = left_margin + right_margin
	width += (end_year - start_year) * year_width # for data
	
	bin_count_vertical = len(Data) / bin_height
	if len(Data) % bin_height > 0 :
		bin_count_vertical += 1
	
	height = bin_count_vertical * bin_height_px # every "bin" includes year marks
	height += vertical_margin * 2
	
	canvas = pygame.Surface((width, height))
	canvas.fill(background_color)
	
	for i in xrange(bin_count_vertical) :
		y = vertical_margin + i * bin_height_px
		start = (left_margin, y)
		stop = (width - right_margin, y)
		pygame.draw.line(canvas, grid_color, start, stop, 1)
		for year in xrange(start_year, end_year, 1) :
			x = left_margin + (year - start_year) * year_width
			if year % 10 == 0 :
				start = (x, y)
				stop = (x, y + bin_height_px)
				pygame.draw.line(canvas, grid_color, start, stop, 1)
				surf = font.render(str(year), font_aa, grid_color, background_color)
				canvas.blit(surf, (x + 3, y + 1))
	
	return

#-----

def procObj(i) :
	obj = Data[i]
	objname = obj.ask("name")
	
	intro_year = int(obj.ask("intro_year", 0))
	intro_month = int(obj.ask("intro_month", 1)) - 1
	retire_year = int(obj.ask("retire_year", stop_year))
	retire_month = int(obj.ask("retire_month", 1)) - 1
	
	bin_number = i / bin_height # which bin is this in
	bin_position = i % bin_height # which item is this in that bin

	# bar color codes information about the vehicle:
	data_color = data_color_normal
	# start with default state (from-to)
	
	# check timeline state
	if (intro_year == 0) and (retire_year == 0) :
		data_color = data_color_always
		intro_year = start_year
		intro_month = 0
		retire_year = end_year
		retire_month = 12
	elif intro_year == 0 :
		data_color = data_color_nointro
		intro_year = start_year
		intro_month = 0
	elif retire_year == stop_year :
		data_color = data_color_noretire
		retire_year = end_year
		retire_month = 12
	else:
		pass
		# nothing to do oterwise
	
	# knowing if the vehicle is not free is still more important
	if check_authors :
		if not CheckAuthors(obj.ask("copyright", "", False)) :
			data_color = data_color_unfree
	
	# compat.tab checking overrides all since it is the most interesting info overall
	if check_compat :
		if compat.has_key(objname + "\n") :
			data_color = data_color_replaced
			
	
	is_disabled = (intro_year * 12 + intro_month) >= (retire_year * 12 + retire_month)
	# important to think about these cases - they can stretch timeline really loooong into future and increase image size -> memory...
	
	start_x = left_margin + ((intro_year - start_year) * 12 + intro_month) * month_width
	end_x = left_margin + ((retire_year - start_year) * 12 + retire_month) * month_width
	start_y = vertical_margin + bin_number * bin_height_px + bin_text_space + bin_position * item_height + 1
	end_y = start_y + item_height - 2
	if not is_disabled :
		canvas.fill(data_color, (start_x, start_y, end_x - start_x, end_y - start_y))
		speed_length = int(obj.ask("speed", 0)) * parameter_bar_max / max_speed if max_speed > 0 else 0
		power_length = (int(obj.ask("power", 0)) * int(obj.ask("gear", 100))) * parameter_bar_max / 100 / max_power if max_power > 0 else 0
		# integer arithmetic - multiplication always first!
		start = (start_x, start_y)
		end = (start_x + speed_length, start_y)
		pygame.draw.line(canvas, speed_color, start, end, 2)
		start = (start_x, end_y - 2)
		end = (start_x + power_length, end_y - 2)
		pygame.draw.line(canvas, power_color, start, end, 2)
	else:
		pass
	
	# charting done, now picture and labels
	
	picture_txt_ref = None
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("freightimage[0][sw]")
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("freightimage[0][ne]")
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("freightimage[sw]")
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("freightimage[ne]")
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("emptyimage[sw]")
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("image[sw]")
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("image[ne]")
	if not picture_txt_ref :
		raise Exception, "no images for object %s!" % objname
	# attempt at extracting the "best" image
	
	picture_ref = simutools.SimutransImgParam(picture_txt_ref)
	picfilename = os.path.join(os.path.dirname(obj.srcfile), picture_ref.file + ".png")
	big_pic = pygame.image.load(picfilename)
	
	srccoords = pygame.Rect(picture_ref.coords[1] * paksize, picture_ref.coords[0] * paksize, paksize, paksize)
	targetcoords = (0, 0, paksize, paksize)
	small_pic = pygame.Surface((paksize, paksize))
	small_pic.blit(big_pic, targetcoords, srccoords)
	
	small_pic.set_colorkey((231,255,255))
	srccoords = small_pic.get_bounding_rect()
	final_pic = pygame.Surface((srccoords.width, srccoords.height))
	final_pic.fill((231,255,255))
	final_pic.blit(small_pic, (0,0), srccoords)
	final_pic.set_colorkey((231,255,255))
	
	del big_pic, small_pic
	# final_pic is now only wanted picture
	
	targetcoords = final_pic.get_rect()
	targetcoords.bottom = start_y + item_height
	targetcoords.right = left_margin - 2 if is_disabled else start_x - 2
	graphic_left = targetcoords.left
	canvas.blit(final_pic, targetcoords)
	del final_pic
	# picture is on the main canvas
	
	surf = font.render(objname, font_aa, name_color)
	targetcoords = surf.get_rect()
	targetcoords.top = start_y + 2
	targetcoords.right = graphic_left - 4
	canvas.blit(surf, targetcoords)
	# name written
	
	text = "%i km/h" % int(obj.ask("speed", 0))
	pwr = int(obj.ask("power", 0))
	if pwr > 0 : text += ", %i kW" % pwr
	surf = font.render(text, font_aa, name_color)
	if not is_disabled :
		canvas.blit(surf, (start_x + 4, start_y + 2))
	else :
		canvas.blit(surf, (left_margin + 4, start_y + 2))
	
	return

#-----

help_string = """
Script for generating Simutrans vehicle timeline reports as images. Runs in
directory where started, searches folders recursively for dat files and reads
vehicle definitions for plotting. These can be filtered by waytype and carried
goods.

Requires PyGame and module 'simutools'.

Usage: timeline-chart [options] 

These are available options, in any order:
size=<number>            Sets tile size for reading images.
a=<string>               Adds a filter by author name.
g=<string>               Adds a filter by goods type (freight).
w=<string>               Adds a filter by waytype.
invert                   Flips goods filtering logic.
engine                   Include only vehicles with engine.
power                    Alias for engine.
front                    Include only vehicles that can be head of a convoy.
<unrecognized-string>    Shortcut for g=<string>.

For filters, the following rules apply:
* Default is empty filter.
* If no entries are specified, filter is empty and not active.

Further (optional) capabilities are:
* Marking vehicles that have compatibility entries - needs compat.tab in
  directory where started. Automatically enabled if the file is present.
* Marking vehicles according to allowed author list - needs simuauthors.py
  loadable, refer to the module for further information. Automatically enabled
  if the module can be loaded.
"""

def process_args() :
	from sys import argv, exit
	for i in argv :
		if i == "--help" or i == "/?":
			print(help_string);
			exit(0)
		elif i == "invert" :
			global filter_goods_invert
			filter_goods_invert = True
		elif i == "power" or i == "engine":
			global filter_powered
			filter_powered = True
		elif i == "front" :
			global filter_front
			filter_front = True
		elif i[:5] == "size=" :
			global paksize
			paksize = int(i[5:])
		elif i[:2] == "w=" :
			filter_ways.append(i[2:])
		elif i[:2] == "g=" :
			filter_goods.append(i[2:])
		elif i[:2] == "a=" :
			filter_authors.append(i[2:])
		else :
			filter_goods.append(i)

	del filter_goods[0] # this will be name of script!

#-----

def test_authorChecks() :
	try :
		from simuauthors import CheckAuthors
		check_authors = True
		print("author checking enabled.")
	except ImportError :
		check_authors = False

#-----

def test_compat() :
	try :
		f = open("compat.tab", "r")
		lines = f.readlines()
		f.close()
		if (len(lines) % 2) :
			del lines[-1]
			# delete last odd, if present
		compat = dict(zip(lines[::2], lines[1::2]))
		# warning - entries still do include trailing \n chars!
		check_compat = True
		print("compat.tab checking enabled.")
	except :
		check_compat = False

#-----

process_args()
test_authorChecks()
test_compat()

try :
	import pygame
except ImportError :
	print("This script needs PyGame to work!")
	print("Visit  http://www.pygame.org  to get it.")
else :
	pygame.font.init()
	if font_name :
		font = pygame.font.SysFont(font_name, font_size)
	else :
		font = pygame.font.Font(font_name, font_size)
	
	print("loading files...")
	simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data)
	
	simutools.pruneList(Data)
	simutools.pruneObjs(Data, ["vehicle", "citycar"]) # remove citycars that share obj=type !
	
	if filter_goods :
		print("filtering by cargo types:", " ".join(filter_goods))
		simutools.pruneByParam(Data, "freight", filter_goods, filter_goods_invert)
	
	if filter_ways :
		print("filtering by way types:", " ".join(filter_ways))
		simutools.pruneByParam(Data, "waytype", filter_ways)
	
	if filter_authors :
		auth_str = " ".join(filter_authors).lower()
		print("filtering by author names:", auth_str)
		i = len(Data) - 1;
		while i >= 0 :
			author = Data[i].ask("copyright", "").lower()
			if not (author in auth_str) :
				del(Data[i]);
			i = i - 1;
	
	if filter_powered :
		print("filtering for powered vehicles...")
		simutools.pruneByParam(Data, "power", [0, None], True)
	
	if filter_front :
		print("filtering for front vehicles...")
		i = len(Data) - 1;
		while i >= 0 :
			constraints = Data[i].ask_indexed("constraint")
			keep = False
			for c in constraints :
				if c[0].lower().startswith("[prev") and c[1].lower() == "none" :
					keep = True
					break
			if not keep :
				del(Data[i]);
			i = i - 1;
		
	
	print("filtered to", len(Data), "items.")
	
	Data.sort(objCompare)
	
	if len(Data) > 0 :
		print("plotting...")
		prepareCanvas()
		for i in xrange(len(Data)) :
			procObj(i)
		pygame.image.save(canvas, "timeline.png")
	else :
		print("no matches left!")

print("finished.")

#-----
# EOF