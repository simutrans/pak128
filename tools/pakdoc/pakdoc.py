#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2013
#  Python 3.2
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#
#
# generate pakset overview, save as a webpage structure

#-----

from __future__ import print_function, division

import os
from os.path import join
from itertools import product
from collections import defaultdict
from sys import argv
from json import loads as json_load

import simutools

#-----

# changeable configuration

paksize = 128
indir = os.getcwd()
outdir = "pakdocs"
imgformat = "jpg"
translation_paths = []
png_cache_size = 8

#-----

SIMUBK = (231,255,255)
MONTHS = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

#-----

def parse_params() :
	# modifying scope directly, some safeguards used...
	valid_keys = set(["paksize", "indir", "outdir", "imgformat", "translation_paths", "png_cache_size"])
	if len(argv) < 2 :
		return
	f = open(argv[1], 'r')
	for line in f.readlines() :
		if line.strip() :
			key, value = line.split("=")
			ks = key.strip()
			if ks in valid_keys :
				globals()[ks] = json_load(value.strip())
	if type(translation_paths) != list :
		print("malformed config!")
		exit(1)
	f.close()

#-----

def _(text) :
	try :
		return translations[text]
	except :
		return text

#-----

def local_filename(name, subfolder=None) :
	if (type(subfolder) == str) and bool(subfolder) :
		return join(outdir, subfolder, name)
	else :
		return join(outdir, name)
	

#-----

def html_start(title, subfolder=0, htmlclass="") :
	leading = "".join(["../" for i in range(subfolder)])
	headers = """<!DOCTYPE html>
<html>
<head>
<title>{1}</title>
<script type="text/javascript" src="{0}pakdoc-sorttable.js"></script>
<link rel="stylesheet" type="text/css" href="{0}pakdoc-style.css" />
</head>
<body lang="en" class="{2}">
<p class="nav"> Categories:
<a href="{0}ways_all.html">ways</a> |
<a href="{0}stations_all.html">stations</a> |
<a href="{0}vehicles_wt_all_gt_all.html">vehicles</a>.</p>"""
	return headers.format(leading, title, htmlclass)

#-----

def html_end() :
	return \
"""<footer>Powered by
<a href="http://www.python.org/">Python</a> script,
<a href="http://www.pygame.org/">PyGame</a>
and <a href="http://www.kryogenix.org/code/browser/sorttable/">sorttable</a>.</footer>
</body>
</html>
"""

#-----

def html_deflist(somedict) :
	a = [("""<dt>%s</dt>\n<dd>%s</dd>\n""" % (key, value)) for key, value in somedict.items()]
	return "<dl>\n" + "".join(a) + "</dl>\n"

def html_h1(name) :
	return "<h1>%s</h1>\n" % name

def html_h2(name) :
	return "<h2>%s</h2>\n" % name

def html_img(path, htmlclass="") :
	if htmlclass :
		return """<img src="%s" class="%s" />""" % (path, htmlclass)
	else :
		return """<img src="%s" />""" % path

#-----

def split_data() :
	k = list(Items.keys())
	for obj in Data :
		objtype = str(obj.ask("obj")).lower()
		if objtype in k :
			Items[objtype].append(obj)
		elif objtype == "building" and obj.ask("type", "") in ["stop", "extension", "habour"] :
			Items["station"].append(obj)

#-----

imgcache = {}
# caches last "png_cache_size" images, rotated by access frequency
def get_png_tile(refstr, base, tilesize=paksize) :
	# always returns a surface
	imgref = simutools.SimutransImgParam(refstr)
	image = pygame.Surface((tilesize, tilesize))
	image.fill((231,255,255))
	if imgref.file != "-" : # guaranteed to get here "-", correct name or other bug
		filepath = join(os.path.dirname(base), imgref.file + ".png")
		count = 0
		source = None
		if png_cache_size > 0 :
			try :
				source,count = imgcache[filepath]
			except : # not cached
				source = pygame.image.load(filepath)
				# will add to cache, prune first
				if len(imgcache) > png_cache_size-1 :
					min_cnt = 65536 # infinity
					min_pth = ""
					for filepath,data in imgcache.items() :
						if data[1] < min_cnt :
							min_cnt = data[1]
							min_pth = filepath
					del imgcache[min_pth]
			imgcache[filepath] = (source,count+1);
		else :
			# caching off
			source = pygame.image.load(filepath)
		srccoords = pygame.Rect(imgref.coords[1] * tilesize, imgref.coords[0] * tilesize, tilesize, tilesize)
		image.blit(source, [0,0], srccoords)
	return image

#-----

def autocrop_image(input, colorkey=None) :
	if colorkey :
		input.set_colorkey(colorkey)
	area = input.get_bounding_rect()
	newimage = pygame.Surface(area.size)
	newimage.fill(SIMUBK)
	newimage.blit(input, [0,0], area)
	return newimage

#-----

paksize_cache = {}
def get_paksize(obj) :
	basepath = os.path.dirname(obj.srcfile)
	value = paksize # failsafe or a dumb idea?
	try :
		value = paksize_cache[basepath]
	except :
		f = open(join(basepath, "_pakmak.tab"), 'r')
		for line in f :
			if line.startswith("size ") :
				value = int(line[5:]) # prone to breaking - very simple
				paksize_cache[basepath] = value
				break
		f.close()
	return value
	
#-----

translations = {}
def load_translations() :
	for filename in translation_paths :
		simutools.loadTranslation(filename, translations, True)
	translations.update({
		"waytype":"way type",
		"topspeed":" max. speed",
		"runningcost":"running cost",
		"intro":"introduction",
		"retire":"retirement",
	})

#-----

def compose_way_icon(obj) :
	tile = get_png_tile(obj.ask("icon", "-"), obj.srcfile)
	tile.set_colorkey(SIMUBK)
	small = pygame.Surface((32,32)) # !!!! Magic numbers - icon size
	small.blit(tile, [0,0], pygame.Rect(0,0,32,32)) # "crop"
	return small

def compose_way_image(obj) :
	# TODO: consider offsets!
	newimage = pygame.Surface((paksize,paksize))
	newimage.fill(SIMUBK)
	ref = obj.ask("image[NS]","-") # way
	if ref == "-":
		ref = obj.ask("image[NS][0]","-") # way seasons
	if ref == "-":
		ref = obj.ask("backimage[N]","-") # tunnel
	if ref == "-":
		ref = obj.ask("backimage[N][0]","-") # tunnel seasons
	if ref == "-":
		ref = obj.ask("backimage[NS]","-") # bridge 
	if ref == "-":
		ref = obj.ask("backimage[NS][0]","-") # bridge seasons
	backimage = get_png_tile(ref, obj.srcfile)
	backimage.set_colorkey(SIMUBK)
	newimage.blit(backimage, [0,0])
	ref = obj.ask("frontimage[NS]","-")
	if ref == "-":
		ref = obj.ask("frontimage[NS][0]","-")
	if ref == "-":
		ref = obj.ask("frontimage[N]","-")
	if ref == "-":
		ref = obj.ask("frontimage[N][0]","-")
	if ref == "-":
		ref = obj.ask("frontimage[NS]","-")
	if ref == "-":
		ref = obj.ask("frontimage[NS][0]","-")
	frontimage = get_png_tile(ref, obj.srcfile)
	frontimage.set_colorkey(SIMUBK)
	newimage.blit(frontimage, [0,0])
	icon = get_png_tile(obj.ask("icon", "-"), obj.srcfile)
	icon.set_colorkey(SIMUBK)
	newimage.blit(icon, [0,0])
	return newimage

#-----

def generate_ways() :
	waytypes = {"road":[], "track":[], "water":[], "tram_track":[], "air":[], "maglev_track":[], "monorail_track":[], "narrowgauge_track":[], "power":[]} #!!!!
	all_ways = Items["way"]+Items["bridge"]+Items["tunnel"]
	
	# preprocessing - sort into types, graphics etc.
	for obj in all_ways :
		waytypes[obj.ask("waytype")].append(obj)
		obj.cname = simutools.canonicalObjName(obj.ask("name"))
		obj.fname = "%s.html" % obj.cname
		obj.iconname = "%s_icon.%s" % (obj.cname, imgformat)
	
	# navigation links, need counts
	links = ["""<a href="ways_%s.html">%s (%d)</a>""" % (type,_(type),len(objs)) for type,objs in waytypes.items()]
	links.insert(0, """<a href="ways_all.html">all (%d)</a>""" % len(all_ways))
	way_nav = """<p class="nav">Waytypes: [ %s ]</p>\n""" % (" | ".join(links))
	
	# generate total overview
	main_params = ["icon", "name", "waytype", "topspeed", "cost", "maintenance", "intro", "retire"] #!!!!
	mainf = open(local_filename("ways_all.html"), 'w')
	mainf.write(html_start("Way overview, all types", 0, "way"))
	mainf.write(way_nav)
	mainf.write(html_h1("Way overview, all types"))
	heads = ["<th>%s</th>" % _(p) for p in main_params]
	heads[0] = """<th class="sorttable_nosort">icon</th>"""
	mainf.write("""<table class="sortable">\n<thead>%s</thead>\n""" % "".join(heads))
	
	# init specific overviews
	loc_f = {}
	for wt in waytypes.keys() :
		f = open(local_filename("ways_%s.html" % wt), 'w')
		f.write(html_start("Way overview - %s" % wt))
		f.write(way_nav)
		f.write(html_h1("Way overview - %s" % wt))
		f.write("""<table class="sortable">\n<thead>""")
		f.write("".join(heads) + "\n")
		f.write("</thead>\n")
		loc_f[wt] = f
	
	# navigation again - retarget links (now in subfolder)
	links = ["""<a href="../ways_%s.html">%s (%d)</a>""" % (type,_(type),len(objs)) for type,objs in waytypes.items()]
	links.insert(0, """<a href="../ways_all.html">all (%d)</a>""" % len(all_ways))
	way_nav = """<p class="nav">Waytypes: [ %s ]</p>\n""" % (" | ".join(links))

	# generate individual objects
	for obj in all_ways :
		name = obj.ask("name")
		# icon
		icon = compose_way_icon(obj)
		pygame.image.save(icon, local_filename(obj.iconname, "ways"))
		# image composed from overlaid backimage and frontimage and icon
		mainimage = compose_way_image(obj)
		imagename = "%s_image.%s" % (obj.cname, imgformat)
		pygame.image.save(mainimage, local_filename(imagename, "ways"))
		# prepare values
		params = {}
		params["icon"] = html_img(obj.iconname)
		params["name"] = name
		params["waytype"] = obj.ask("waytype", "-")
		params["topspeed"] = obj.ask("topspeed", "-")
		params["cost"] = obj.ask("cost", "-")
		params["maintenance"] = obj.ask("maintenance", "-")
		intro_month = int(obj.ask("intro_month", "1"))
		intro_year = int(obj.ask("intro_year", "-1"))
		params["intro"] = "%s %d" % (MONTHS[intro_month], intro_year) if intro_year>-1 else "-"
		intro_sort = "%d+%s" % (intro_year, intro_month)
		retire_month = int(obj.ask("retire_month", "1"))
		retire_year = int(obj.ask("retire_year", "-1"))
		params["retire"] = "%s %d" % (MONTHS[retire_month], retire_year) if retire_year>-1 else "-"
		retire_sort = "%d+%s" % (retire_year, retire_month)
		# output to overviews
		params["icon"] = """<a href="ways/%s"><img src="ways/%s" /></a>""" % (obj.fname, obj.iconname)
		params["name"] = """<a href="ways/%s">%s</a>""" % (obj.fname, _(name))
		table_cells = ["<td>%s</td>" % _(params[p]) for p in main_params]
		table_line = """<tr>%s</tr>\n""" % "".join(table_cells)
		mainf.write(table_line)
		loc_f[params["waytype"]].write(table_line)
		# prepare values for writing own file
		type = obj.ask("obj")
		if type=="way" and obj.ask("system_type")=="1" :
			type = "elevated"
		if intro_year > -1 :
			if retire_year > -1 :
				# both dates set
				timeline = params["intro"] + " - " + params["retire"]
			else :
				# only intro
				timeline = "since " + params["intro"]
		else :
			if retire_year > -1 :
				# only retire
				timeline = "until " + params["retire"]
			else :
				# no timeline
				timeline = "always available"
		# output to own file
		f = open(local_filename(obj.fname, "ways"), 'w')
		f.write(html_start(_(name), 1))
		f.write(way_nav)
		f.write(html_h1(_(name)))
		f.write(html_img(imagename))
		f.write("""<table class="parameters"><tbody>\n""")
		f.write("<tr><td>internal name</td><td>%s</td></tr>" % name)
		f.write("<tr><td>%s</td><td>%s</td></tr>" % (_("waytype"), _(params["waytype"])))
		f.write("<tr><td>type</td><td>%s</td></tr>" % _(type))
		f.write("<tr><td>%s</td><td>%s</td></tr>" % (_("topspeed"), _(params["topspeed"])))
		f.write("<tr><td>%s</td><td>%s</td></tr>" % (_("cost"), params["cost"]))
		f.write("<tr><td>%s</td><td>%s</td></tr>" % (_("maintenance"), params["maintenance"]))
		f.write("<tr><td>timeline</td><td>%s</td></tr>" % timeline)
		f.write("</tbody></table>\n")
		f.write(html_end())
		f.close()
		
	mainf.write("</table>\n")
	mainf.write(html_end())
	mainf.close()
	
	for wt in waytypes.keys() :
		f = loc_f[wt]
		f.write("</table>\n")
		f.write(html_end())
		f.close()

#-----

def compose_building_icon(obj) :
	tile = get_png_tile(obj.ask("icon", "-"), obj.srcfile)
	tile.set_colorkey(SIMUBK)
	small = pygame.Surface((32,32)) # !!!! Magic numbers - icon size
	small.blit(tile, [0,0], pygame.Rect(0,0,32,32)) # "crop"
	return small

def compose_building_image(obj) :
	# handle "any" size, height and shape of building - but assume max. 4x4x3 (x,y,z) dictated by buffer size
	# TODO: offsets!
	buffer.fill(SIMUBK)
	for z in range(3) : # outermost iteration must be over height!
		for x in range(4) :
			for y in range(4) :
				# x,y,z logical - object coordinates
				pos = [ (y+3-x)*paksize/2 , (y+x)*paksize/4 + paksize*(2-z) ] # order x,y canvas coordinates
				ref = obj.ask("backimage[0][%d][%d][%d][0]" % (x,y,z), "-") # building
				if ref == "-":
					ref = obj.ask("backimage[0][%d][%d][%d][0][0]" % (x,y,z), "-") # building seasons
				if ref != "-" :
					backimage = get_png_tile(ref, obj.srcfile)
					backimage.set_colorkey(SIMUBK)
					buffer.blit(backimage, pos)
				ref = obj.ask("frontimage[0][%d][%d][%d][0]" % (x,y,z), "-") # building
				if ref == "-":
					ref = obj.ask("frontimage[0][%d][%d][%d][0][0]" % (x,y,z), "-") # building seasons
				if ref != "-" :
					frontimage = get_png_tile(ref, obj.srcfile)
					frontimage.set_colorkey(SIMUBK)
					buffer.blit(frontimage, pos)
	# crop to usable part, resize so that width is 128 px max
	buffer.set_colorkey(SIMUBK)
	img = autocrop_image(buffer)
	# img is now the whole item without borders
	if img.get_width() <= 256 :
		img2 = img # this is good enough
	else :
		# need downsampling
		ratio = 256 / img.get_width()
		img2 = pygame.transform.scale(img, (256, int(img.get_height()*ratio)))
	# now put icon 1:1 and the maybe-squashed image right under it
	buffer.fill(SIMUBK)
	buffer.blit(compose_building_icon(obj), [0,0])
	buffer.blit(img2, [0,32])
	return autocrop_image(buffer)

#-----

def generate_stations() :
	waytypes = {"extension":[], "road":[], "track":[], "water":[], "tram_track":[], "air":[], "maglev_track":[], "monorail_track":[], "narrowgauge_track":[]} #!!!!
	
	for obj in Items["station"] :
		name = obj.ask("name")
		type = obj.ask("type", "")
		if type == "extension" :
			obj.put("waytype", "extension")
		elif type == "habour" :
			obj.put("waytype", "water")
		wt = obj.ask("waytype", "extension").lower()
		waytypes[wt].append(obj)
		obj.cname = simutools.canonicalObjName(name)
		obj.fname = "%s.html" % obj.cname
		obj.iconname = "%s_icon.%s" % (obj.cname, imgformat)
		enables = ""
		pax = bool(int(obj.ask("enables_pax", "0")))
		mail = bool(int(obj.ask("enables_post", "0")))
		cargo = bool(int(obj.ask("enables_ware", "0")))
		if pax :
			enables += ", pax"
		if mail :
			enables += ", mail"
		if cargo :
			enables += ", cargo"
		if enables :
			enables = enables[2:]
		else :
			enables = "-"
		obj.put("enables", enables)
	
	# navigation links, need counts
	links = ["""<a href="stations_%s.html">%s (%d)</a>""" % (type,_(type),len(objs)) for type,objs in waytypes.items()]
	links.insert(0, """<a href="stations_all.html">all (%d)</a>""" % len(Items["station"]))
	stat_nav = """<p class="nav">waytypes: [ %s ]</p>\n""" % (" | ".join(links))
	
	# generate total overview
	main_params = ["icon", "name", "waytype", "enables", "level", "intro", "retire"] #!!!!
	mainf = open(local_filename("stations_all.html"), 'w')
	mainf.write(html_start("Station overview - all types"))
	mainf.write(stat_nav)
	mainf.write(html_h1("Station overview - all types"))
	heads = ["""<th>%s</th>""" % _(p) for p in main_params]
	heads[0] = """<th class="sorttable_nosort">icon</th>"""
	mainf.write("""<table class="sortable">\n<thead>%s</thead>\n""" % "".join(heads))
	
	# init local overviews
	loc_f = {}
	for wt in waytypes.keys() :
		f = open(local_filename("stations_%s.html" % wt), 'w')
		name = "Station overview - %s" % _(wt)
		f.write(html_start(name))
		f.write(stat_nav)
		f.write(html_h1(name))
		f.write("""<table class="sortable">\n<thead>%s</thead>\n""" % "".join(heads))
		loc_f[wt] = f
	
	# navigation links again
	links = ["""<a href="../stations_%s.html">%s (%d)</a>""" % (type,_(type),len(objs)) for type,objs in waytypes.items()]
	links.insert(0, """<a href="../stations_all.html">all (%d)</a>""" % len(Items["station"]))
	stat_nav = """<p class="nav">waytypes: [ %s ]</p>\n""" % (" | ".join(links))
	
	# generate individual objects
	for obj in Items["station"] :
		name = obj.ask("name")
		# icon
		icon = compose_building_icon(obj)
		pygame.image.save(icon, local_filename(obj.iconname, "stations"))
		# image composed from overlaid backimages and frontimages and icon
		mainimage = compose_building_image(obj)
		imagename = "%s_image.%s" % (obj.cname, imgformat)
		pygame.image.save(mainimage, local_filename(imagename, "stations"))
		# prepare values
		params = {}
		params["icon"] = """<a href="stations/%s"><img src="stations/%s" /></a>""" % (obj.fname, obj.iconname)
		params["name"] = """<a href="stations/%s">%s</a>""" % (obj.fname, _(name))
		params["waytype"] = obj.ask("waytype", "none")
		params["enables"] = obj.ask("enables", "-")
		params["level"] = obj.ask("level", "-")
		intro_month = int(obj.ask("intro_month", "1"))
		intro_year = int(obj.ask("intro_year", "-1"))
		params["intro"] = "%s %d" % (MONTHS[intro_month], intro_year) if intro_year>-1 else "-"
		intro_sort = "%d+%s" % (intro_year, intro_month)
		retire_month = int(obj.ask("retire_month", "1"))
		retire_year = int(obj.ask("retire_year", "-1"))
		params["retire"] = "%s %d" % (MONTHS[retire_month], retire_year) if retire_year>-1 else "-"
		retire_sort = "%d+%s" % (retire_year, retire_month)
		# output to overviews
		table_cells = ["<td>%s</td>" % _(params[p]) for p in main_params]
		table_line = """<tr>%s</tr>\n""" % "".join(table_cells)
		mainf.write(table_line)
		loc_f[params["waytype"]].write(table_line)
		# prepare values for writing own file
		if intro_year > -1 :
			if retire_year > -1 :
				# both dates set
				timeline = params["intro"] + " - " + params["retire"]
			else :
				# only intro
				timeline = "since " + params["intro"]
		else :
			if retire_year > -1 :
				# only retire
				timeline = "until " + params["retire"]
			else :
				# no timeline
				timeline = "always available"
		# output to own file
		f = open(local_filename(obj.fname, "stations"), 'w')
		f.write(html_start(_(name), 1))
		f.write(stat_nav)
		f.write(html_h1(_(name)))
		f.write(html_img(imagename))
		f.write("""<table class="parameters"><tbody>\n""")
		f.write("<tr><td>internal name</td><td>%s</td></tr>" % name)
		f.write("<tr><td>%s</td><td>%s</td></tr>" % (_("waytype"), _(params["waytype"])))
		f.write("<tr><td>type</td><td>%s</td></tr>" % _(type))
		f.write("<tr><td>%s</td><td>%s</td></tr>" % (_("enables"), _(params["enables"])))
		f.write("<tr><td>%s</td><td>%s</td></tr>" % (_("level"), params["level"]))
		f.write("<tr><td>timeline</td><td>%s</td></tr>" % timeline)
		f.write("</tbody></table>\n")
		f.write(html_end())
		f.close()
		
	mainf.write("</table>\n")
	mainf.write(html_end())
	mainf.close()
	
	for wt in waytypes.keys() :
		f = loc_f[wt]
		f.write("</table>\n")
		f.write(html_end())
		f.close()

#-----

goods_table = {} # translation table goods->categories
goods_types = set()
def preparse_goods() :
	for obj in Items["good"] :
		name = obj.ask("name")
		catg = int(obj.ask("catg", "0"))
		if catg == 0 :
			goods_table[name] = name
			goods_types.add(name)
		else :
			cat_str = "CATEGORY_%02d" % catg
			goods_table[name] = cat_str
			goods_types.add(cat_str)

#-----

def compose_vehicle_image(obj) :
	tilesize = get_paksize(obj)
	pieces = []
	
	ref = obj.ask("emptyimage[sw]", "-")
	if ref == "-" :
		# this view is always present!
		raise Exception("malformed vehicle file")
	pieces.append(autocrop_image(get_png_tile(ref, obj.srcfile, tilesize), SIMUBK))
	
	css_width = 256 #!!! 256 magic number from css - space allowed for image
	
	# guesstimate item sizes after all the processing - assuming all images are +- same dimension
	single_width = pieces[0].get_width()
	single_height = pieces[0].get_height()
	# everything is wider than higher, expecting that dimension as limiting
	ratio = min(css_width / single_width, 1.0)
	est_hgt = single_height * ratio
	max_hgt = 320 #!!!! arbitrary magic number for maximal image height
	max_items = int(max_hgt / est_hgt) # cast truncates
	# 320/256 is >1, so max_items cannot be negative even for full tile
	remaining = max_items - 1 # one already spent
	
	# find some more images...
	if max_items > 0 :
		loads = obj.ask_indexed("freightimagetype")
		if len(loads) > 0 :
			# got more freights
			for i in range(min(len(loads),max_items)) :
				ref = obj.ask("freightimage[%d][sw]" % i, "-")
				if ref != "-" :
					pieces.append(autocrop_image(get_png_tile(ref, obj.srcfile, tilesize), SIMUBK))
		else :
			# only single freight, maybe?
			ref = obj.ask("freightimage[sw]", "-")
			if ref != "-" :
				pieces.append(autocrop_image(get_png_tile(ref, obj.srcfile, tilesize), SIMUBK))
	
	# compose images into a buffer - it is prepared externally
	buffer.fill(SIMUBK)
	ypos = 0
	for image in pieces :
		image.set_colorkey(SIMUBK)
		buffer.blit(image, [0,ypos]) # images are already cropped
		ypos += image.get_height() + 4 # some spacing does not hurt
	usable = autocrop_image(buffer)
	if usable.get_width() <= css_width :
		return usable # this is good enough
	else :
		# need downsampling
		ratio = css_width / usable.get_width() # now real numbers for composed image
		return pygame.transform.scale(usable, (css_width, int(usable.get_height()*ratio)))
	# assume estimated height was good enough - do not test further

#-----

def compose_vehicle_icon(obj) :
	tilesize = get_paksize(obj)
	ref = obj.ask("freightimage[sw]", "-") # normal loaded
	if ref == "-" :
		ref = obj.ask("freightimage[0][sw]", "-") # first loaded
	if ref == "-" :
		ref = obj.ask("emptyimage[sw]", "-") # normal empty
	if ref == "-" :
		raise Exception("malformed vehicle file")
	view = get_png_tile(ref, obj.srcfile, tilesize)
	view.set_colorkey(SIMUBK)
	newimage = autocrop_image(view)
	return newimage

#-----

def generate_vehicles() :
	waytypes = ["all", "road", "track", "water", "tram_track", "air", "maglev_track", "monorail_track", "narrowgauge_track"] #!!!!
	goods = ["all"] + list(goods_types)
	wtg_table = list(product(waytypes, goods)) # list of tuples (wt,gt)
	
	main_params = ["icon", "name", "waytype", "speed", "power", "freight", "payload", "cost", "runningcost", "intro_year", "retire_year"] #!!!!
	heads = ["<th>%s</th>" % _(p) for p in main_params]
	heads[0] = """<th class="sorttable_nosort">image</th>"""
	table_header = """<thead>%s</thead>""" % ("".join(heads))
	
	vehicles = {}
	for wtg in wtg_table :
		vehicles[wtg] = [[], 0, "", ""] # objects, file handle, html nav, subfolder nav (reused by individual files!)
	
	name_table = {} # name:obj, for checking constraints
	# categorize and count stuff
	for obj in Items["vehicle"] :
		obj.put("goods", goods_table[obj.ask("freight", "None")]) # exchange goods for their categories where applicable
		name = obj.ask("name")
		obj.cname = simutools.canonicalObjName(name)
		obj.fname = "%s.html" % obj.cname
		obj.iconname = "%s_icon.%s" % (obj.cname, imgformat)
		wt = obj.ask("waytype")
		gt = obj.ask("goods", "None")
		vehicles[(wt,gt)][0].append(obj)
		vehicles[("all",gt)][0].append(obj)
		vehicles[(wt,"all")][0].append(obj)
		vehicles[("all","all")][0].append(obj)
		name_table[name] = obj
	
	# overview html files - generate navigations, open files etc
	for wtg in wtg_table :
		wt,gt = wtg # unpack tuple into vars
		
		links = ["""<a href="vehicles_wt_%s_gt_%s.html">%s (%d)</a>""" % (iwt, gt, _(iwt), len(vehicles[(iwt,gt)][0])) for iwt in waytypes]
		veh_wt_nav = """<p class="nav">waytypes: [ """ + " | ".join(links) + """ ]</p>\n"""
		links = ["""<a href="vehicles_wt_%s_gt_%s.html">%s (%d)</a>""" % (wt, igt, _(igt), len(vehicles[(wt,igt)][0])) for igt in goods]
		veh_g_nav = """<p class="nav">goods: [ """ + " | ".join(links) + """ ]</p>\n"""
		veh_nav_help = """<p class="nav">(Clicking changes way or goods type, keeping the other as curently selected.)</p>\n"""
		veh_nav = veh_wt_nav + veh_g_nav + veh_nav_help

		links = ["""<a href="../vehicles_wt_%s_gt_%s.html">%s (%d)</a>""" % (iwt, gt, _(iwt), len(vehicles[(iwt,gt)][0])) for iwt in waytypes]
		sub_wt_nav = """<p class="nav">waytypes: [ """ + " | ".join(links) + """ ]</p>\n"""
		links = ["""<a href="../vehicles_wt_%s_gt_%s.html">%s (%d)</a>""" % (wt, igt, _(igt), len(vehicles[(wt,igt)][0])) for igt in goods]
		sub_g_nav = """<p class="nav">goods: [ """ + " | ".join(links) + """ ]</p>\n"""
		sub_nav = sub_wt_nav + sub_g_nav
		
		f = open(local_filename("vehicles_wt_%s_gt_%s.html" % (wt,gt)), 'w')
		f.write(html_start("Vehicle overview - %s, %s" % (_(wt),_(gt))))
		f.write(veh_nav)
		f.write(html_h1("Vehicle overview - %s, %s" % (_(wt),_(gt))))
		f.write("""<table class="sortable">\n""")
		f.write(table_header)
		
		vehicles[wtg][1] = f
		vehicles[wtg][2] = veh_nav
		vehicles[wtg][3] = sub_nav
	
	for obj in Items["vehicle"] :
		name = obj.ask("name")
		f = open(local_filename(obj.fname, "vehicles"), 'w')
		f.write(html_start(_(name), 1))
		# navigations - need way and goods type
		wt = obj.ask("waytype")
		gt = obj.ask("goods", "None")
		f.write(vehicles[(wt,gt)][3])
		f.write(html_h1(_(name)))
		# icon
		icon = compose_vehicle_icon(obj)
		pygame.image.save(icon, local_filename(obj.iconname, "vehicles"))
		# image
		mainimage = compose_vehicle_image(obj)
		imagename = "image_vehicle_%s.%s" % (obj.cname, imgformat)
		pygame.image.save(mainimage, local_filename(imagename, "vehicles"))
		f.write(html_img(imagename))

		# output to own file
		params = {}
		detail_params = main_params + ["intro_month", "retire_month", "engine_type", "weight", "gear"] #!!!!
		for param in detail_params :
			params[param] = obj.ask(param, "-")
		params["icon"] = """<img src="%s" />""" % (obj.iconname)
		f.write(html_deflist(params))
		
		# constraints
		f.write(html_h2("Constraints"))
		f.write("""<table class="constraints">\n<thead><th>prev</th><th>this</th><th>next</th></thead>\n""")
		constr = obj.ask_indexed("constraint")
		prev = []
		next = []
		this = [name]
		for c in constr :
			if (c[1].lower() != "none") and (c[1] not in name_table.keys()) :
				print("  invalid constraint: %s, %s=%s" % (name, c[0], c[1]))
				break
			if c[0][:6] == "[prev]" :
				prev.append(c[1])
			elif c[0][:6] == "[next]" :
				next.append(c[1])
		# here, logic gets tricky because the axis of lists is orthogonal to order of writing the html table
		# so make all lists same length into a "fake 2d array" spanning the 3, then "iterate sideways" across them
		# resulting table has always full side columns and the middle has only first cell with rowspan
		total_rows = max(len(prev), len(next), 1)
		prev += [""]*(total_rows - len(prev)) # padding at ends
		this += [""]*(total_rows - len(this))
		next += [""]*(total_rows - len(next))
		for i in range(total_rows) :
			p = prev[i]
			t = this[i]
			n = next[i]
			if p == "" :
				p = "<td></td>"
			elif p == "none" :
				p = "<td>(start of convoy)</td>"
			else :
				pc = simutools.canonicalObjName(p)
				p = """<td><a href="%s.html"><img src="%s_icon.%s" title="%s" /></a></td>""" % (pc, pc, imgformat, _(p))
			if t != "" :
				t = """<td rowspan="%d" class="this"><img src="%s" title="%s" /></td>""" % (total_rows, obj.iconname, _(name))
				# special - has rowspan, centers etc.
			if n == "" :
				n = "<td></td>"
			elif n == "none" :
				n = "<td>(end of convoy)</td>"
			else :
				nc = simutools.canonicalObjName(n)
				n = """<td><a href="%s.html"><img src="%s_icon.%s" title="%s" /></a></td>""" % (nc, nc, imgformat, _(n))
			f.write("""<tr>%s%s%s</tr>\n""" % (p,t,n))
		f.write("</table>\n")
		
		# output to overviews
		params["icon"] = """<a href="vehicles/%s"><img src="vehicles/%s" /></a>""" % (obj.fname, obj.iconname)
		params["name"] = """<a href="vehicles/%s">%s</a>""" % (obj.fname, _(name))
		table_cells = ["<td>%s</td>" % _(params[p]) for p in main_params]
		table_line = "<tr>" + "".join(table_cells) + "</tr>\n"
		for spec in [(wt,gt), (wt, "all"), ("all",gt), ("all","all")] :
			vehicles[spec][1].write(table_line)
		# finalize own file
		f.write(html_end())
		f.close()
	
	for wtg in wtg_table :
		f = vehicles[wtg][1]
		f.write("</table>\n")
		f.write(html_end())
		f.close()

#-----

print("Starting.")
try :
	import pygame
except ImportError :
	print("This script needs PyGame to work!")
	print("Visit  http://www.pygame.org  to get it.")
	exit(1)
parse_params()

print("Loading files...")
Data = []
simutools.walkFiles(indir, simutools.loadFile, cbparam=Data)
os.makedirs(outdir, exist_ok=True)
Items = {"vehicle":[], "good":[], "factory":[], "bridge":[], "way":[], "tunnel":[], "station":[]}
split_data()
del Data
load_translations()
print("  ...data prepared.")

print("Generating ways...")
os.makedirs(local_filename("ways"), exist_ok=True)
generate_ways()
print("  ...done.")

print("Generating stations...")
buffer = pygame.Surface((4*paksize,9*paksize/2)) # enough for tiles xyz=4*4*3
buffer.set_colorkey(SIMUBK)
os.makedirs(local_filename("stations"), exist_ok=True)
generate_stations()
print("  ...done.")

print("Generating vehicles...")
preparse_goods()
buffer = pygame.Surface((512,512)) # vehicles need new buffer
buffer.set_colorkey(SIMUBK)
os.makedirs(local_filename("vehicles"), exist_ok=True)
generate_vehicles()
print("  ...done.")

# TODO: factories + goods "graph"

print("Work finished.")

#-----
# EOF