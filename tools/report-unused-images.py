#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2010
#  Python 2.6
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#

# read all dat files in all subfolders
# find all references to images
# compare with actual images present
# output what is used and what not

#-----

import os
import re

from collections import defaultdict

import simutools

#-----
# configuration

default_paksize = 128

#-----

Objects = []
Images = defaultdict(list) # indexed by path, payload is list of SimutransImgParam references
PakSizes = defaultdict(int) # indexed by path, payload is paksize (tile size)
FoundImages = []

paksizeFinder = re.compile(r"size[ \t]+([0-9]+)")

#-----

def get_paksize(where) :
	# get it the dirty way from pakmak.tab
	# should die only on malformed files
	cfgname = os.path.join(where, "pakmak.tab")
	if os.path.exists(cfgname) :
		f = open(cfgname, "r")
		matches = paksizeFinder.findall("".join(f.readlines()))
		f.close()
		if matches :
			return int(matches[0])
		else :
			return default_paksize
	else :
		return default_paksize

#-----

def procObj(obj) :
	parentdir = os.path.dirname(obj.srcfile)
	
	# lazy loading tile sizes for cache
	paksize = PakSizes[parentdir]
	if not paksize : # uninitialized = 0
		paksize = get_paksize(parentdir)
		PakSizes[parentdir] = paksize
	
	references = [[None, obj.ask("Icon")], [None, obj.ask("Cursor")]]
	# content is otherwise list of [indices,reference] -> normalize the two odd entries
	for param in simutools.ImageParameterNames :
		references += obj.ask_indexed(param)
	for ref in references :
		imgref = simutools.SimutransImgParam(ref[1])
		if not imgref.isEmpty() :
			imgref.paksize = paksize # attaching new field not present in original class, remember!
			imagefile = os.path.normpath(os.path.join(parentdir, imgref.file))
			Images[imagefile].append(imgref)

#-----

def procImg(img) :
	tiles = Images[img]
	bitmap = pygame.image.load(img + ".png")
	for tile in tiles:
		area = pygame.Rect(tile.coords[1] * tile.paksize, tile.coords[0] * tile.paksize, tile.paksize, tile.paksize)
		bitmap.fill(pygame.Color(255,0,0,255), area)
		# used parts will get red, unused stay as is
	pygame.image.save(bitmap, img + ".usage.png")

#-----

# main() is this piece of code

try :
	import pygame
except ImportError :
	print "This script needs PyGame to work!"
	print "Visit  http://www.pygame.org  to get it."
else :
	simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Objects)
	simutools.pruneList(Objects)
	
	for item in Objects :
		procObj(item)
	
	simutools.walkFiles(os.getcwd(), (lambda file: FoundImages.append(file[:-4])), extension="png")
	
	for item in FoundImages :
		procImg(item)
	
	print "Finished!"

#-----
# EOF
