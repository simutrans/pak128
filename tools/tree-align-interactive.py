#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2010 - 2011
#  Python 2.6, 3.1
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#

# pygame learning script - tool for reformatting trees using offsets
# very rudimentary but sufficient :-)

from __future__ import print_function

import os, math, sys

import simutools

#-----

Data = []

paksize = 128

outdir = "dump"

loadedimages = {}

#-----

def procObj(obj) :
	objname = obj.ask("name")
	cname = simutools.canonicalObjName(objname)

	images = []
	
	for param in simutools.ImageParameterNames :
		images += map(lambda i: (param, i[0], i[1]), obj.ask_indexed(param))
	
	for param in simutools.SingleImageParameterNames :
		value = obj.ask(param)
		if value :
			images.append((param, "", value))
	
	newimage = pygame.Surface((paksize, paksize))
	newimage.fill((231,255,255)) # background
	
	for i in range(len(images)) :
		key, indices, raw_ref = images[i]
		imgref = simutools.SimutransImgParam(raw_ref)
		
		if not imgref.isEmpty() :
		
			imgname = os.path.normpath(os.path.join(os.path.dirname(obj.srcfile), imgref.file + ".png"))
			
			if not imgname in loadedimages :
				loadedimages[imgname] = pygame.image.load(imgname)
			
			srccoords_px = pygame.Rect(imgref.coords[1] * paksize, \
				imgref.coords[0] * paksize, paksize, paksize) # calculate position on old image
			
			newimage.blit(loadedimages[imgname], (0,0), srccoords_px) # copy image tile
			
			off_x, off_y = imgref.offset
			off_x, off_y = -off_x, -off_y
			changed = True
			save = False
			while True :
				pygame.time.wait(50)
				
				pygame.event.pump()
				keys = pygame.key.get_pressed()
				if keys[pygame.K_SPACE] or keys[pygame.K_ESCAPE] :
					pygame.time.wait(500)
					break
				elif keys[pygame.K_RETURN] :
					pygame.time.wait(500)
					save = True
					break
				elif keys[pygame.K_LEFT] :
					off_x = off_x - 1
					changed = True
				elif keys[pygame.K_RIGHT] :
					off_x = off_x + 1
					changed = True
				elif keys[pygame.K_UP] :
					off_y = off_y - 1
					changed = True
				elif keys[pygame.K_DOWN] :
					off_y = off_y + 1
					changed = True
				elif pygame.mouse.get_pressed()[0] :
					mx, my = pygame.mouse.get_pos()
					off_x = mx - 100 - paksize / 2
					off_y = my - 100 - (paksize * 3) / 4
					changed = True
				
				if changed :
					screen.fill((0,0,0))
					screen.blit(newimage, (100,100))
					screen.blit(cursor, (100 + off_x, 100 + off_y), newimage.get_bounding_rect())
					pygame.display.flip()
					changed = False

			if save :
				imgref.offset = -off_x, -off_y
				obj.put(key + indices, str(imgref))
			
	
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
	pygame.display.init()
	
	simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data)
	simutools.pruneList(Data)
	simutools.pruneObjs(Data, ["tree"])
	
	if not os.path.exists(outdir) :
            os.mkdir(outdir)
	
	screen = pygame.display.set_mode((200 + paksize, 200 + paksize))
	
	cursor = pygame.image.load("targeting.png")
	cursor.set_colorkey((255,255,255))
	
	for item in Data :
		procObj(item)
	

#-----
# EOF