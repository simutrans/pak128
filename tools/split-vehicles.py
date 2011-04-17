#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2009 - 2011
#  Python 2.6, 3.1
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#

# read all dat files in all subfolders
# weed out all except vehicles
# reformat them and save aside

# WARNING: malformed files break the script!

from __future__ import print_function

import os

import simutools

#-----

Data = []

paksize = 128
outsize = 128

outdir = "dump"

dirs = ["w", "nw", "n", "ne", "e", "se", "s", "sw"]

font = None
fntsize = 24

loadedimages = {}

#-----

def transferImageTile(objref, indexstr, targetimage, targetcoords, outfilename) :
	value = objref.ask(indexstr)
	if value != None :
		imgref = simutools.SimutransImgParam(value)
		imgname = os.path.join(os.path.dirname(objref.srcfile), imgref.file + ".png")
		if not imgname in loadedimages :
			loadedimages[imgname] = pygame.image.load(imgname)
		
		srccoords = pygame.Rect(imgref.coords[1] * paksize, imgref.coords[0] * paksize, paksize, paksize)
		
		imgref.coords[0] = targetcoords[1]
		imgref.coords[1] = targetcoords[0]
		
		off_move_x = (outsize - paksize) / 2
		off_move_y = 3 * (outsize - paksize) / 4
		
		imgref.offset[0] -= off_move_x
		imgref.offset[1] -= off_move_y
		
		targetcoords[0] = targetcoords[0] * outsize + off_move_x
		targetcoords[1] = targetcoords[1] * outsize + off_move_y
		
		targetimage.blit(loadedimages[imgname], targetcoords, srccoords) # copy image tile
		imgref.file = outfilename
		objref.put(indexstr, str(imgref))

#-----

def procObj(obj) :
	objname = obj.ask("name")
	print("processing", objname)
	
	num_freights = len(obj.ask_indexed("freightimagetype")) # we don't need them, just numbers
	
	emptyimages = obj.ask_indexed("emptyimage")
	freightimages = obj.ask_indexed("freightimage")
	
	if len(emptyimages) < 1 :
		raise Exception("no images!")
	
	rows = 1 + 1 + max([num_freights, int(len(freightimages) > 0), 0])
	# description + empty + max(variable freights, 1|0 for freightimages present, 0)
	
	text_step = fntsize
	
	newimage = pygame.Surface((outsize * 8, outsize * rows)) #(w,h)
	newimage.fill((231,255,255)) # background
	newimage.fill((255,255,255), (0, 0, 8 * outsize, outsize)) # description stripe is white
	
	text = "name: " + obj.ask("name", "?")
	surf = font.render(text, False, (0,0,0), (255,255,255)) # black text on white
	newimage.blit(surf, (10, 10 + 0 * text_step))
	
	text = "copyright: " + obj.ask("copyright", "?", False)
	surf = font.render(text, False, (0,0,0), (255,255,255)) # black text on white
	newimage.blit(surf, (10, 10 + 1 * text_step))
	
	text = "timeline: %s - %s" % (obj.ask("intro_year", "*"), obj.ask("retire_year", "*"))
	surf = font.render(text, False, (0,0,0), (255,255,255)) # black text on white
	newimage.blit(surf, (10, 10 + 2 * text_step))

	text = "stats: %s km/h, %s kW, %s/16 tile" % (obj.ask("speed", "???", False), obj.ask("power", "0", False), obj.ask("length", "8 (default)", False))
	surf = font.render(text, False, (0,0,0), (255,255,255)) # black text on white
	newimage.blit(surf, (10, 10 + 3 * text_step))
	
	text = "cargo: %s  %s" % (obj.ask("payload", "0", False), obj.ask("freight", "None", False))
	surf = font.render(text, False, (0,0,0), (255,255,255)) # black text on white
	newimage.blit(surf, (10, 10 + 4 * text_step))
	
	img_name =  simutools.canonicalObjName(objname)
	
	for i in range(len(dirs)) :
		indexstr = "emptyimage[%s]" % (dirs[i])
		targetcoords = [i, 1] # always second row
		transferImageTile(obj, indexstr, newimage, targetcoords, img_name)
	
	if (num_freights > 0) :
		# more image sets
		for cargo in range(num_freights) :
			for i in range(len(dirs)) :
				indexstr = "freightimage[%i][%s]" % (cargo, dirs[i])
				targetcoords = [i, 2 + cargo] # starting at third row
				transferImageTile(obj, indexstr, newimage, targetcoords, img_name)
		
	elif (len(freightimages) > 0) :
		# single cargo image set
		for i in range(len(dirs)) :
			indexstr = "freightimage[%s]" % (dirs[i])
			targetcoords = [i, 2] # always third row
			transferImageTile(obj, indexstr, newimage, targetcoords, img_name)
	
	pygame.image.save(newimage, os.path.join(outdir, img_name + ".png"))
	
	f = open(os.path.join(outdir, objname.lower() + ".dat"), 'w')
	for l in obj.lines :
		f.write(l)
	f.close()

#-----

# main() is this piece of code

if outsize < paksize :
	print("WARNING: Configuration error: Output tile size is smaller than input!")

try :
	import pygame
except ImportError :
	print("This script needs PyGame to work!")
	print("Visit  http://www.pygame.org  to get it.")
else :
	pygame.font.init()
	font = pygame.font.Font(None, fntsize)
	
	simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data)
	simutools.pruneObjs(Data, ["vehicle"])
	
	if not os.path.exists(outdir) :
            os.mkdir(outdir)
	
	for item in Data :
		procObj(item)

#-----
# EOF