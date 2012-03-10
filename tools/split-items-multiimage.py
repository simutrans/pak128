#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2012
#  Python 3.2
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#

# read all dat files in all subfolders
# reformat pictures and save aside

import os, math, sys

import simutools

#-----

Data = []

paksize = 128

outdir = "dump"

font = None
fntsize = 24

minwidth = 3 # tiles

loadedimages = {}

#-----

def procObj(obj) :
	objname = obj.ask("name")
	objkind = obj.ask("obj")
	cname = simutools.canonicalObjName(objname)
	if use_obj_kind_prefix :
		cname = "%s,%s" % (cname, objkind)
	print("processing", objname)
	
	images = []
	
	for param in simutools.ImageParameterNames :
		images += map(lambda i: (param, i[0], i[1]), obj.ask_indexed(param))
	
	for param in simutools.SingleImageParameterNames :
		value = obj.ask(param)
		if value :
			images.append((param, "", value))
	
	total_length_px = len(images) * paksize
	max_width_px = 1024.0
	min_width_px = 384.0 # both fixed, based on common screen and text
	
	new_width_px = max(min(total_length_px, max_width_px), min_width_px) # restrict to range
	new_width = int(float(new_width_px) / paksize)
	new_height = math.ceil(len(images) / float(new_width)) + 1
	
	newimage = pygame.Surface((paksize * new_width, paksize * new_height))
	newimage.fill((231,255,255)) # background
	newimage.fill((255,255,255), (0, 0, new_width * paksize, paksize)) # description stripe
	
	text = "name: " + objname
	surf = font.render(text, False, (0,0,0), (255,255,255)) # black text on white
	newimage.blit(surf, (10, 10))
	
	text = "copyright: " + obj.ask("copyright", "?", False)
	surf = font.render(text, False, (0,0,0), (255,255,255))
	newimage.blit(surf, (10, 10 + fntsize + 4))
	
	type = obj.ask("type", "?")
	if type != "?" :
		text = "obj: %s ; type: %s" % (objkind, type)
	else :
		text = "obj: %s" % objkind
	surf = font.render(text, False, (0,0,0), (255,255,255))
	newimage.blit(surf, (10, 10 + 2 * (fntsize + 4)))
	
	text = "timeline: %s - %s" % (obj.ask("intro_year", "*"), obj.ask("retire_year", "*"))
	surf = font.render(text, False, (0,0,0), (255,255,255))
	newimage.blit(surf, (10, 10 + 3 * (fntsize + 4)))
	
	targetcoords = [0, 1]
	
	for i in range(len(images)) :
		kind, indices, imgref = images[i]
		imgref = simutools.SimutransImgParam(imgref)
		
		if not imgref.isEmpty() :
		
			imgname = os.path.normpath(os.path.join(os.path.dirname(obj.srcfile), imgref.file + ".png"))
			
			if not imgname in loadedimages :
				loadedimages[imgname] = pygame.image.load(imgname)
			
			srccoords_px = pygame.Rect(imgref.coords[1] * paksize, \
				imgref.coords[0] * paksize, paksize, paksize) # calculate position on old image
			
			imgref.coords[0] = targetcoords[1]; imgref.coords[1] = targetcoords[0]
			targetcoords_px = [x * paksize for x in targetcoords]
			
			newimage.blit(loadedimages[imgname], targetcoords_px, srccoords_px) # copy image tile
			imgref.file = cname
			obj.put(kind + indices, str(imgref))
			
			targetcoords[0] += 1
			if targetcoords[0] >= new_width :
				targetcoords[0] = 0
				targetcoords[1] += 1
	
	pygame.image.save(newimage, os.path.join(outdir, cname + ".png"))
	
	f = open(os.path.join(outdir, cname + ".dat"), 'w')
	for l in obj.lines :
		f.write(l)
	f.close()
#-----

# main() is this piece of code

try :
	import pygame
except ImportError :
	print("This script needs PyGame to work!")
	print("Visit  http://www.pygame.org  to get it.")
else :
	pygame.font.init()
	font = pygame.font.Font(None, fntsize)
	
	use_obj_kind_prefix = "-prefix" in sys.argv
	
	simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data)
	simutools.pruneList(Data)
	
	if not os.path.exists(outdir) :
            os.mkdir(outdir)
	
	for item in Data :
		procObj(item)

#-----
# EOF