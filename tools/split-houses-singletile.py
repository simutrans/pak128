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
# weed out all except houses
# reformat them and save aside

# WARNING: frontimage is not considered! ONLY backimage!

import os

import simutools

#-----

Data = []

paksize = 128

outdir = "dump"

font = None
fntsize = 24

minwidth = 3

loadedimages = {}

#-----

def procObj(obj) :
	objname = obj.ask("name")
	print "processing", objname
	
	if obj.ask("type", "none").lower() in ["res", "com", "ind", "cur"] : # needs default string because of lower()
		dims = obj.ask("dims", "1,1,1")
		dims = dims.split(",")
		if len(dims) == 2 :
			dims.append("1")
		# dims converted to canonical form [?, ?, ?] of strings
		
		rots = int(dims[2])
		has_winter = False
		max_height = 0
		max_anim = 0
		
		images = obj.ask_indexed("backimage")
		
		# preparsing pass - find what are the features of object: seasons, animation...
		for item in images : # tuples [params] = value -> (params, value)
			indices = item[0].split("][")
			# first and last item still have the single bracket!
			if len(indices) > 0 :
				indices[0] = indices[0][1:]
				indices[-1] = indices[-1][:-1]
				# so fix them ^
				if len(indices) == 6 :
					has_winter = indices[5] == "1" or has_winter
				max_anim = max(int(indices[4]), max_anim)
				max_height = max(int(indices[3]), max_height)
		
		# now we know the numbers so we can select new image layout etc.
		if max_anim > 0 :
			# animated?
			# primary animation, secondary rotations, then snow and height
			layout = 0
			new_height = 1 + (max_height + 1) * rots * (2 if has_winter else 1) # first +1 for text row
			new_width = max((max_anim + 1), minwidth)
		elif rots > 1 :
			# no anim. -> rotations?
			# primary rotations, secondary snow and height
			layout = 1
			new_height = 1 + (max_height + 1) * (2 if has_winter else 1)
			new_width = max(rots, minwidth)
		else :
			# no anim or rotation?
			# primary climates (if any!), secondary height
			layout = 2
			new_height = 1 + (max_height + 1)
			new_width = max((2 if has_winter else 1), minwidth)
		
		newimage = pygame.Surface((paksize * new_width, paksize * new_height))
		newimage.fill((231,255,255)) # background
		newimage.fill((255,255,255), (0, 0, new_width * paksize, paksize)) # description stripe
		
		text = "name: " + obj.ask("name", "?")
		surf = font.render(text, False, (0,0,0), (255,255,255)) # black text on white
		newimage.blit(surf, (10, 10))
		
		text = "copyright: " + obj.ask("copyright", "?")
		surf = font.render(text, False, (0,0,0), (255,255,255)) # black text on white
		newimage.blit(surf, (10, 10 + fntsize + 4))
		
		cname = simutools.canonicalObjName(objname)
		
		# blitting pass - copy the parts onto new picture
		for rot in xrange(rots) :
			for z in xrange(max_height + 1) : # +1 because we read maximal index, not number of them!
				for t in xrange(max_anim + 1) : # +1 same here
					indexstr = "backimage[%i][0][0][%i][%i]" % (rot, z, t)
					value = obj.ask(indexstr)
					if value == None :
						# failed but asking is precise, so ask again for explicit number with no winter
						indexstr = "backimage[%i][0][0][%i][%i][0]" % (rot, z, t)
						value = obj.ask(indexstr)
					# now it must be a string! or a mising image
					if value != None :
						# the good case
						imgref = simutools.SimutransImgParam(value)
						imgname = os.path.join(os.path.dirname(obj.srcfile), imgref.file + ".png")
						if not loadedimages.has_key(imgname) :
							loadedimages[imgname] = pygame.image.load(imgname)
						srccoords = pygame.Rect(imgref.coords[1] * paksize, \
							imgref.coords[0] * paksize, paksize, paksize) # calculate position on old image
						if layout == 2 :
							targetcoords = [0, 1 + max_height - z]
						elif layout == 1 :
							targetcoords = [rot, 1 + max_height - z]
						else : # 0
							targetcoords = [t, 1 + (max_height - z) * (rot + 1) * (2 if has_winter else 1)]
						imgref.coords[0] = targetcoords[1]; imgref.coords[1] = targetcoords[0]
						targetcoords[0] *= paksize; targetcoords[1] *= paksize
						newimage.blit(loadedimages[imgname], targetcoords, srccoords) # copy image tile
						imgref.file = cname
						obj.put(indexstr, str(imgref))
					else :
						# say if it is mising!
						print "Missing image", indexstr
					if has_winter :
						indexstr = "backimage[%i][0][0][%i][%i][1]" % (rot, z, t)
						value = obj.ask(indexstr)
						if value != None :
							imgref = simutools.SimutransImgParam(value)
							imgname = os.path.join(os.path.dirname(obj.srcfile), imgref.file + ".png")
							if not loadedimages.has_key(imgname) :
								loadedimages[imgname] = pygame.image.load(imgname)
							srccoords = pygame.Rect(imgref.coords[1] * paksize, \
								imgref.coords[0] * paksize, paksize, paksize)
							if layout == 2 :
								targetcoords = [1, 1 + max_height - z]
							elif layout == 1 :
								targetcoords = [rot, 1 + (max_height + 1) * 2 - 1 - z]
							else : # 0
								targetcoords = [t, 1 + (max_height * 2 - z) * (rot + 1) * (2 if has_winter else 1)]
							imgref.coords[0] = targetcoords[1]; imgref.coords[1] = targetcoords[0]
							targetcoords[0] *= paksize; targetcoords[1] *= paksize
							newimage.blit(loadedimages[imgname], targetcoords, srccoords)
							imgref.file = cname
							obj.put(indexstr, str(imgref))
						else :
							# misssing winter image even if winter declared
							print "Missing image", indexstr

		
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
	print "This script needs PyGame to work!"
	print "Visit  http://www.pygame.org  to get it."
else :
	pygame.font.init()
	font = pygame.font.Font(None, fntsize)
	
	simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data)
	simutools.pruneObjs(Data, ["building"])
	
	if not os.path.exists(outdir) :
            os.mkdir(outdir)
	
	for item in Data :
		procObj(item)

#-----
# EOF