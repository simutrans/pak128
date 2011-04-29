#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2011
#  Python 2.6
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#
#
# creates a climate chart for trees

#-----

from __future__ import print_function

#-----

paksize = 128 # default only

font_name = "Verdana"
font_size = 10 # unknown units!
font_aa = False # antialiasing

item_width = 80 # px
item_height = 150 # px; includes text, climate flags and spacing
tree_baseline = 90 # px from top of row

items_per_row = 10 # items

vertical_margin = 30 # px
side_margin = 30 # px

climate_size = 10 # px

background_color = (231,255,255)
name_color = (0,0,0)

climate_names = [
  "water",
  "desert",
  "tropic",
  "mediterran",
  "temperate",
  "tundra",
  "rocky",
  "arctic",
]

climate_colors = {
  "water":      (79,90,117),
  "desert":     (177,138,100),
  "tropic":     (81,152,61),
  "mediterran": (110,143,60),
  "temperate":  (75,131,54),
  "tundra":     (86,126,91),
  "rocky":      (111,123,117),
  "arctic":     (207,207,220),
}

#-----

import os
import simutools

Data = []

canvas = None

#-----

def objCompare(A, B) :
	return cmp(A.ask("name"), B.ask("name"))

#-----

def prepareCanvas() :
	global canvas
	
	width = side_margin * 2
	width += items_per_row * item_width # for data
	
	row_count = len(Data) / items_per_row
	if len(Data) % items_per_row > 0 :
		row_count += 1
	
	height = row_count * item_height
	height += vertical_margin * 2
	
	canvas = pygame.Surface((width, height))
	canvas.fill(background_color)
	
	return

#-----

def procObj(i) :
	global canvas
	
	obj = Data[i]
	objname = obj.ask("name")
	
	row_number = i / items_per_row # which row is this in
	row_position = i % items_per_row # which item is this in that row
	
	picture_txt_ref = None
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("image[3][0]")
	if not picture_txt_ref :
		picture_txt_ref = obj.ask("image[0][0]")
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
	targetcoords.bottom = vertical_margin + item_height * row_number + tree_baseline
	targetcoords.left = side_margin + item_width * row_position
	canvas.blit(final_pic, targetcoords)
	del final_pic
	# picture is on the main canvas
	
	surf = font.render(objname, font_aa, name_color)
	targetcoords = surf.get_rect()
	targetcoords.top = vertical_margin + item_height * row_number + tree_baseline + 2
	targetcoords.left = side_margin + item_width * row_position + 4
	canvas.blit(surf, targetcoords)
	# name written
	
	climates = obj.ask("climates", "").split(",")
	for j, name in enumerate(climate_names) :
		place = (targetcoords.left + j * (climate_size - 1) - 1, targetcoords.top + 12, climate_size, climate_size)
		if name in climates :
			canvas.fill(climate_colors[name], place)
		pygame.draw.rect(canvas, name_color, place, 1)
	
	return

#-----

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
	simutools.pruneObjs(Data, ["tree"])
	
	Data.sort(objCompare)
	
	if len(Data) > 0 :
		print("plotting...")
		prepareCanvas()
		for i in xrange(len(Data)) :
			procObj(i)
		pygame.image.save(canvas, "climates.png")
	else :
		print("nothing found!")

print("finished.")

#-----
# EOF