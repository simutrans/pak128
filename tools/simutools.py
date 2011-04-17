#!/usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2008 - 2010
#  Python 2.5
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#

"""
Easy handling of Simutrans DAT files.
"""

from __future__ import print_function

import glob, os, struct

#-----

ImageParameterNames = [
	"Image",
	"BackImage",
	"FrontImage",
	"EmptyImage",
	"FreightImage",
	"BackStart",
	"FrontStart",
	"BackPillar",
	"FrontPillar",
	"BackRamp",
	"FrontRamp",
	"ImageUp",
	"BackImageUp",
	"FrontImageUp",
	"Diagonal",
	"BackDiagonal",
	"FrontDiagonal",
	"OpenImage",
	"Front_OpenImage",
	"ClosedImage",
	"Front_ClosedImage",
	]

SingleImageParameterNames = [
	"Icon",
	"Cursor",
	]

#-----

class SimutransObject :
	"""
	DAT object container for data agnostic and non-invasive manipulation.
	
	Encapsulates a single game object. Actual data is stored in field
	"lines" (list of strings), manipulation is abstracted mainly to
	methods ask() and put(). All operations change only their respective
	strings; order, case and any formatting are preserved if the change
	does not explicitly require their alteration.
	"""
	
	def __init__(self, srcloc = "") :
		self.lines = []
		self.srcfile = srcloc
		self.newfile = ""
		self.image = None
		self.save = False
		
	def loc (self, param) :
		"""
		Query the object for position of key "param".
		
		Returns the index if present, else -1.
		"""
		if type(param) != str :
			raise KeyError('Not a string') # not a string
		lparam = param.lower() # improve loop speed
		for i in range(len(self.lines)) :
			line = self.lines[i]
			if (len(line) < 1) or line.startswith("#") :
				continue # skip comments
			elif lparam == line.split("=", 1)[0].lower().strip() :
				return i
		return -1 # not found
		
	def ask(self, param, default=None, interpretation=True) :
		"""
		Query the object for a value.
		
		Returns the value of "param" if present, else "default". With
		"interpretation" set on, return value is converted to an int if
		it is a number.
		"""
		if type(param) != str :
			raise KeyError('Not a string') # not a string
		lparam = param.lower() # improve loop speed
		for line in self.lines :
			if line.startswith("#") :
				continue # skip comments
			parts = line.split("=", 1)
			if lparam == parts[0].lower().strip() :
				result = parts[1].strip()
				if interpretation :
					try :
						result = int(result)
					except ValueError :
						pass
				return result
		return default # not found
		
	def ask_indexed(self, param) :
		"""
		Query the object for values of an indexed parameter.
		
		Returns indices and respective values of "param". Result format
		is a list [(indices, value), (...), ... ] where both are strings.
		Indices include the square brackets - eg. "[0][0][1][0][2]". If
		the parameter is not present at all, empty list is returned.
		"""
		if type(param) != str :
			raise KeyError('Not a string') # not a string
		lparam = param.lower() # improve loop speed
		# returns (by design) as default empty list []
		result = []
		for line in self.lines :
			if line.startswith("#") :
				continue # skip comments
			parts = line.split("=", 1)
			brpos = parts[0].find("[")
			if brpos == -1 :
				continue # skip malformed lines with no [numbers] - HACK! do or die? dat da kvestion!
			tag = parts[0][:brpos].lower().strip()
			# cut the tag name
			if lparam == tag :
				value = parts[1].strip()
				indices = parts[0][brpos:].lower().strip()
				# extract indexing, too
				result.append((indices, value)) # return a tuple
		return result # put back what was found 
		
	def put(self, param, value, weak=False) :
		"""
		Set a parameter to specified value.
		
		Sets "param" to "value"; the former must be a string. If "weak" is
		True, absence of the parameter in object will result in exception.
		"""
		if type(param) != str :
			raise KeyError('Not a string') # not a string
		i = 0
		while i < len(self.lines) :
			line = self.lines[i]
			if line.startswith("#") :
				i = i + 1
				continue # skip comments
			parts = line.split("=", 1)
			if parts[0].lower().strip() == param.lower() :
				parts[1] = str(value) + "\n"
				self.lines[i] = "=".join(parts)
				return
			i = i + 1
		if weak :
			raise KeyError('Not present')
		else :
			self.lines.append(param + "=" + str(value))
			
	def allComments(self) :
		"""
		Return a list of all comments in the object.
		
		Returns a list of all/any comments found within the object. When
		none are present, the list is empty.
		
		Please note that comment lines are normally mixed with parameters,
		so the only reliable information gained here is order of comment
		lines and their content.
		"""
		result = []
		for line in self.lines :
			if line.startswith("#") :
				result.append(line)
		return result
		
	def isObj(self) :
		"""
		Check if the object is an object.
		
		Checks whether parameter "obj" is set. Returns boolean.
		"""
		return bool(self.has("obj",))
		
	def has(self, param) :
		"""
		Check for presence of parameter.
		"""
		# note that you can ask for 
		if type(param) != str :
			raise KeyError('Not a string') # not a string
		lparam = param.lower() # improve loop speed
		for line in self.lines :
			if line.startswith("#") :
				continue # skip comments
			if line.strip().lower().startswith(lparam) :
				return True # exists
		return False # if it got here, it's not there
		
	def isValid(self) :
		"""
		NOT IMPLEMENTED!
		
		Checks if the present parameters and their values form a valid
		object.
		"""
		return True
		# todo: add some code to check if it has the right parameters
	
	def dump(self, file) :
		"""
		Dump the object to file.
		"""
		for line in self.lines :
			file.write(line)

#-----

class SimutransImgParam :
	"""
	Container for Simutrans image reference handling.
	"""
	def __init__(self, param=None) :
		self.prefix = ""
		self.file = ""
		self.coords = [-1, -1]
		self.offset = [0, 0]
		
		if (type(param) == str) or (type(param) == unicode) :
			target = param

			if target.startswith("> ") :
				# prefix is a rogue item around here, it can seemingly exist on its own
				# handling it is #1 since it can not really crash
				self.prefix = "> "
				target = target[2:]
				# note: prefix could one day include more flags!
			
			if (target == "-") or (target == "") :
					self.file = "-"
			else :
				offsets = ""
				pos = ""
								
				if target.endswith(".png") :
					# already full path -> reparse into canocical form
					target = target.replace(".png", "") + ".0.0"
				if target.endswith(".PNG") :
					# same with uppercase
					target = target.replace(".PNG", "") + ".0.0"
				
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
				
				pos = pos.split(".") # coords are [1] and [2], [0] is empty
				if offsets == "" :
					offsets = ",0,0" # fill with neutral value
				offsets = offsets.split(",") # treat offsets same as coords
				# ORIGINAL = prefix + target + ".".join(pos) + ",".jin(offsets)
				
				self.file = target
				self.coords[0] = int(pos[1])
				self.coords[1] = int(pos[2])
				self.offset[0] = int(offsets[1])
				self.offset[1] = int(offsets[2])
	
	def __str__(self) :
		"""
		Get a string representation usable in DAT file.
		"""
		result = self.prefix + self.file
		if not self.isEmpty() :
			result += ".%i.%i" % (self.coords[0], self.coords[1])
			if self.hasOffsets() :
				result += ",%i,%i" % (self.offset[0], self.offset[1])
		return result
	
	def hasOffsets(self) :
		"""Check if offsets are used."""
		return (self.offset[0] != 0) or (self.offset[1] != 0)
	
	def isEmpty(self) :
		"""
		Check if this means "no image".
		
		Tests whether the file reference is not set to special value "-".
		"""
		return self.file == "-"
	
	def isNozoom(self) :
		"""
		Check if the reference is set to "no zooming".
		
		This is determined from file reference, which can include the
		no-zoom mark in form of "> " prefix.
		"""
		return self.prefix == "> " # note: prefix could one day include other flags!

#-----

def loadFile(loc, mainlist) :
	"""
	Load objects and append to list.
	
	In "loc" supply a string with path to a dat file.
	
	The only parsing done here is finding separators; this means that
	"false" objects with no parameters can appear if the file contained
	such data. Thus the resulting list is "dirty" and must be further
	cleaned with some of the functions prune***().
	"""
	f = open(loc)
	lines = f.readlines()
	f.close()
	item = SimutransObject(loc)
	for line in lines :
		if line.startswith("---") :
			mainlist.append(item)
			item = SimutransObject(loc)
		else :
			item.lines.append(line)
	mainlist.append(item)

#-----

def walkFiles(topdir, callback, ignorefile="statsignore.conf", showplaces=False, cbparam=None, recurse=True, extension="dat") :
	"""
	Run a callback on specified file type in given tree.
	
	For every file ending in "extension" that is found in directory tree
	beginning at "topdir", run "callback".
	
	Setting "recurse" to False will prevent descending into subdirs.
	If "ignorefile" is found in a directory, its contents and subdirs will
	not be processed.
	
	With "showplaces", the progress is displayed (sort of) in console.
	
	The callback function is called with each file as first parameter and
	"cbparam" as second, if it has been supplied: callback(path, cbparam).
	
	Most common invocation is in the form:
	  simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data)
	where "Data" is a list where objects are collected.
	"""
	if showplaces :
		print(topdir)
	for file in glob.glob(os.path.join(topdir, "*." + extension)) :
		if cbparam != None :
			callback(file, cbparam)
		else :
			callback(file)
	if recurse :
		for fsitem in glob.glob(os.path.join(topdir, "*")) :
			if os.path.isdir(fsitem) :
				if not os.path.exists(os.path.join(topdir, fsitem, ignorefile)) :
					walkFiles(os.path.join(topdir, fsitem), callback, ignorefile, showplaces, cbparam, recurse, extension)

#-----

def pruneList(dataset) :
	"""
	Remove from object list all comment-only objects.
	"""
	i = len(dataset) - 1
	while i >= 0 :
		if not dataset[i].isObj() :
			del(dataset[i])
		i = i - 1

#-----

def pruneObjs(dataset, toKeep) :
	"""
	Reduce object list to objects whose obj= value is one from "toKeep".
	"""
	i = len(dataset) - 1
	while i >= 0 :
		if not dataset[i].ask("obj") in toKeep :
			del(dataset[i])
		i = i - 1

#-----

def pruneByParam(dataset, param, values, invert=False) :
	"""
	Reduce object list according to certain parameter's values.
	
	Go through list "dataset" and keep only objects that have parameter
	"param" and its value is found in list "values". By setting "invert" the
	behaviour is reversed.
	"""
	i = len(dataset) - 1
	while i >= 0 :
		if not ((dataset[i].ask(param) in values) ^ invert) :
			del(dataset[i])
		i = i - 1

#-----

def canonicalObjName(raw) :
	"""
	Turn object name to identifier safe in external environment.
	"""
	# assume raw is a string
	return raw.lower().replace(" ", "_").replace(".", "_")
	# todo: conversion of non-ascii letters, changing non-letters to something...

#-----

def getPNGsize(filename) :
	"""
	Read from PNG file picture width and height. Returns as tuple.
	"""
	f = open(filename, "rb")
	f.seek(16) # skip: 8 file magic, 4 chunk length, 4 chunk name (IHDR)
	data = struct.unpack("!LL", f.read(8)) # contents are now (w,h)
	f.close()
	return data

#-----

# EOF