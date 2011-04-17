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

# read all dat files in all subfolders and rehash them together with images
# into translator-acceptable amount of data

from __future__ import print_function

import re, os, glob, copy

import simutools

#-----

Data = []

paksize = 128

outdir = "dump"

#-----

def procObj(obj) :
	objtype = ""
	objname = ""
	ratedimages = []
	for line in obj.lines :
		l = line.lower()
		score = 0
		if l.startswith("obj") :
			objtype = line.split("=")[1].strip()
		elif l.startswith("name") :
			objname = line.split("=")[1].strip()
		elif l.startswith("backimage") :
			score = 100
		elif l.startswith("icon") :
			score = 200
		elif l.startswith("cursor") :
			score = 150
		elif l.startswith("emptyimage") :
			score = 100
		elif l.startswith("freightimage") and not l.startswith("freightimagetype") :
			score = 150
		elif l.startswith("frontimage") :
			score = 50
		elif l.startswith("frontdiagonal") :
			score = 50
		elif l.startswith("frontimageup") :
			score = 50
		elif l.startswith("backdiagonal") :
			score = 50
		elif l.startswith("backimageup") :
			score = 50
		elif l.startswith("backpillar") :
			score = 50
		elif l.startswith("backstart") :
			score = 100
		elif l.startswith("frontstart") :
			score = 150
		elif l.startswith("backramp") :
			score = 50
		elif l.startswith("frontramp") :
			score = 50
		elif l.startswith("image") :
			score = 50
		elif l.startswith("diagonal") :
			score = 50
		elif l.startswith("imageup") :
			score = 50
		elif l.startswith("openimage") :
			score = 50
		elif l.startswith("front_openimage") :
			score = 100
		elif l.startswith("closedimage") :
			score = 50
		elif l.startswith("front_closedimage") :
			score = 100
		if l.find("=-") != -1 :
			score = -1000
		# if it is a valid image, it is rated higher than 0
		if score > 0 :
			if l.find("[s]") != -1 :
				score = score + 100
			elif l.find("[ns]") != -1 :
				score = score + 200
			elif l.find("[0][0][0][0][0][0]") != -1 :
				score = score + 200
			elif l.find("[0][0][0][0][0][1]") != -1 :
				score = score + 200
			elif l.find("[0][0][0][0][0]") != -1 :
				score = score + 200
			ratedimages.append((line, score)) # -> list of tuples
	if objtype != "" :
		obj.save = True
	else :
		return
	print(objtype, ":", objname)
	if len(ratedimages) > 0 :
		ratedimages.sort(key = lambda a : -a[1]) # order by score
		for di in ratedimages[4:] : # delete redundant - 5th image and on towards end
			i = obj.lines.index(di[0]) # find the same as line saved in score table
			del obj.lines[i]
	keptimages = []
	keptimages = ratedimages[:4] # remember what are the images that stay; at most 4
	imageparts = []
	obj.newfile = objtype + "_" + objname.replace(" ", "_")
	obj.image = pygame.Surface((paksize, paksize*4)) # 4 tiles vertically
	i = 0
	for item in keptimages :
		s = item[0].strip() # remove trailing \n !!!
		target = s.split("=")
		caller = target[0] + "="
		target = target[1]
		prefix = ""
		if target.startswith("> ") :
			prefix = "> "
			target = target[2:] # split
		if target.endswith(".png") :
			# already full path -> reparse it inot normalized
			target = target.replace(".png", "") + ".0.0"
		if target.endswith(".PNG") :
			# same with uppercase
			target = target.replace(".PNG", "") + ".0.0"
		offsets = ""
		pdot = target.rfind(".")
		pcomma = target.rfind(",")
		if pcomma > pdot : # never gives false positive for correct entry since position is always set here
			# offsets are present
			pcomma = target.rfind(",", 1, pcomma) # find the previous comma - assumes both offsets are set
			offsets = target[pcomma:]
			target = target[:pcomma]
		pdot = target.rfind(".", 1, pdot) # find second last dot
		pos = target[pdot:]
		target = target[:pdot] # now finally file name without png is in target
		pos = pos.split(".") # offsets are [1] and [2], [0] is empty
		# ORIGINAL = caller + prefix + target + ".".join(pos) + offsets
		imagename = os.path.join(os.path.dirname(obj.srcfile), target + ".png")
		srcimage = pygame.image.load(imagename)
		coords = pygame.Rect(int(pos[2]) * paksize, int(pos[1]) * paksize, paksize, paksize) # grrr, swapped X and Y will haunt me until the end of days!
		obj.image.blit(srcimage, (0, paksize * i), coords) # copy image tile
		origindex = obj.lines.index(item[0]) # find where was original
		obj.lines[origindex] = caller + prefix + obj.newfile + "." + str(i) + ".0" + offsets + "\n"
		i = i + 1

#-----

def saveItem(obj) :
	if obj.save :
		f = open(os.path.join(outdir, obj.newfile + ".dat"), 'w')
		for l in obj.lines :
			f.write(l)
		f.close()
		if obj.image != None :
			pygame.image.save(obj.image, os.path.join(outdir, obj.newfile + ".png"))

#-----

# main() is this piece of code

try :
	import pygame
except ImportError :
	print("This script needs PyGame to work!")
	print("Visit  http://www.pygame.org  to get it.")
else :
	simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data)
	for item in Data :
		procObj(item)
	if not os.path.exists(outdir) :
            os.mkdir(outdir)
	for item in Data :
		saveItem(item)

#-----
# EOF