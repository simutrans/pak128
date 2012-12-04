#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2008-2011
#  Python 2.6, 3.1
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is in public domain
#

#-----------------------------------------------------------------------------
# Globals

from __future__ import print_function, unicode_literals, division, with_statement
# as much forward as possible to get py3 compliant with one script

import os, shutil, re, glob, time, copy, stat, sys

varsymbolfinder = re.compile(r"\$\{[^}].+?\}")

use_subprocess = False

CONFIG_FILE_NAME = "_pakmak.tab"

BOOL_TRUE_STRINGS = ("True", "true", "1", "on", "On", "ON", "yes", "Yes")

#-----------------------------------------------------------------------------

def toUnicode(what) :
	"""Turns a string to unicode, no matter what version."""
	# ugliness, but what else could I do?
	if sys.version_info[0] < 3 :
		return unicode(what)
	else :
		return what

def flushStd() :
	"""Flushes stdout and stderr so that messages in console remain in correct sequence."""
	sys.stdout.flush()
	sys.stderr.flush()

def ensurePath(path) :
	"""Grants that the target directory exists."""
	parts = os.path.split(path)
	for i in range(len(parts)) :
		# iterate progressively deeper into suggested tree
		thispath = os.path.join(*parts[:i+1])
		if os.path.isdir(thispath) :
			pass # already exists
		elif os.path.exists(thispath) :
			raise Exception("Path contains a file and can not be created!")
		else :
			# can be only a missing dir at this point
			os.mkdir(thispath)
	# if not os.path.isdir(path) :
		# os.makedirs(path) # fails if there is already something with the name but not a dir

def fix(caller, path, info) :
	"""Attempts to forcefully remove a filesystem object."""
	if caller == os.remove:
		os.chmod(path, stat.S_IWRITE + stat.S_IREAD)
		os.remove(path)

def deletePath(pth) :
	"""Deletes filesystem objects defined by wildcard in a shell-like manner: whatever it is, away with it."""
	objlist = glob.glob(pth)
	for obj in objlist :
		if os.path.isfile(obj) :
			os.remove(obj)
		if os.path.isdir(obj) :
			shutil.rmtree(obj, onerror=fix)

def deletePaks() :
	deletePath("*.pak")

def copyPath(src, target) :
	"""Copies filesystem objects defined by wildcard in a shell-like manner."""
	objlist = glob.glob(src)
	for obj in objlist :
		if os.path.isfile(obj) :
			shutil.copy(obj, target)
		if os.path.isdir(obj) :
			shutil.copytree(obj, target)

def movePath(src, target) :
	"""Moves filesystem objects defined by wildcard in a shell-like manner."""
	objlist = glob.glob(src)
	for obj in objlist :
		shutil.move(obj, target)

def parsePaths(rawstring) :
	output = []
	state = "none"
	tmp = ""
	for letter in rawstring.strip():
		if state == "none" and letter.isspace() :
			# skip whitespace between items
			continue
		if state == "none" and letter == "\"" :
			# start quoted
			state = "quoted"
			tmp = ""
		elif state == "quoted" and letter == "\"" :
			# end quoted
			state = "none"
			output.append(tmp)
		elif state == "quoted" :
			# append quoted
			tmp += letter
		elif state == "none" and letter != "\"" :
			# start unquoted
			tmp = letter
			state = "unquoted"
		elif state == "unquoted" and letter.isspace() :
			# end unquoted
			output.append(tmp)
			state = "none"
		elif state == "unquoted" :
			# append unquoted
			tmp += letter
	if state != "none" :
		output.append(tmp)
	return output

def getAbsPath(path) :
	if os.path.isabs(path) :
		return path
	else :
		tmp = ""
		for item in path.split("/") :
			tmp = os.path.join(tmp, item)
		del item
		return os.path.abspath(tmp)

def run(command) :
	flushStd()
	if use_subprocess :
		return subprocess.call(parsePaths(command), close_fds=True)
	else :
		return os.system(command)

#-----------------------------------------------------------------------------
# Class that is one dir entry

class Entry :
	
	def __init__(self, parent=None, dir=None) :
		self.data = {
			"FOLDERS" : [],
			"OPTIONS" : {}, # this one is dictionary!!!
			"COMPILE" : [],
			"COMMANDS-BEFORE" : [],
			"COMMANDS-MIDDLE" : [],
			"COMMANDS-AFTER" : [],
			"REM" : [],
		}
		self.workdir = ""
		self.data["OPTIONS"]["cmd"] = "makeobj"
		if parent != None :
			self.inherit(parent)
		if type(dir) == type("") :
			self.load(dir)
	
	def __option(self, which, default="") :
		try :
			return self.data["OPTIONS"][which]
		except KeyError :
			return default
	
	def inherit(self, parent) :
		self.data["OPTIONS"] = copy.deepcopy(parent.data["OPTIONS"])
		self.workdir = parent.workdir
	
	def interpolate(self, input) :
		symbols = set(varsymbolfinder.findall(input)) # SET to make them unique
		tmp = input
		for symbol in symbols :
			tmp = tmp.replace(symbol, self.data["OPTIONS"][symbol[2:-1]]) # ${var} -> data from "var"
		return tmp
	
	
	def load(self, dir) :
		if dir != None :
			self.workdir = toUnicode(os.path.join(self.workdir, dir))
		filename = os.path.join(self.workdir, CONFIG_FILE_NAME)
		if os.path.exists(filename) :
			with open(filename, "r") as f:
				section = None
				for line in f.readlines() :
					line = toUnicode(line.replace("\n", " ").strip())
					if len(line) == 0 or line.isspace() :
						# empty line
						continue
					if line[0] == "#" :
						# comment, skip
						continue
					elif line.isupper() :
						# section header
						section = line
					elif section == "OPTIONS" :
						# options
						key, value = line.split(" ", 1)
						self.data["OPTIONS"][key] = value
					elif section != None :
						# unsorted content
						self.data[section].append(line)
		else :
			print("%s not found in %s" %(CONFIG_FILE_NAME, (dir if dir != None else self.workdir)))
	
	def do(self) :
		# make sure target folder exists
		os.chdir(self.workdir)
		self.data["OPTIONS"]["target"] = getAbsPath(self.__option("target"))
		ensurePath(self.data["OPTIONS"]["target"])
		# pre-processing
		for command in self.data["COMMANDS-BEFORE"] :
			self.__exec(command)
		# do the jobs declared here
		if self.__option("compile") in BOOL_TRUE_STRINGS :
			deletePaks()
			print("Compiling...")
			command = "%s pak%s ./ ./" % (self.__option("cmd"), self.__option("size"))
			retval = run(command)
			print("Compiled.")
			if retval != 0 :
				sys.exit("Makeobj call returned %i" % (retval))
			# mid-processing
			for command in self.data["COMMANDS-MIDDLE"] :
				self.__exec(command)
			merge = self.__option("merge", "")
			if len(merge) > 0 :
				# is merge set up?
				command = "%s merge %s *.pak" % (self.__option("cmd"), merge)
				print("Merging:", command)
				retval = run(command)
				if retval != 0 :
					sys.exit("Makeobj call returned %i" % (retval))
				shutil.copy(self.__option("merge"), os.path.join(self.__option("target"), self.__option("merge")))
			else :
				for pak in glob.glob("*.pak") :
					shutil.copy(pak, self.__option("target"))
			if self.__option("clean") in BOOL_TRUE_STRINGS :
				deletePaks()
		# now iterate deeper
		print("My folders: ", (" | ".join(self.data["FOLDERS"]) if len(self.data["FOLDERS"]) > 0 else "**none**"))
		for dir in self.data["FOLDERS"] :
			print("Entering folder %s" % (dir))
			e = Entry(self, dir)
			e.do()
		# post-processing
		os.chdir(self.workdir)
		print("Running post-processing...")
		for command in self.data["COMMANDS-AFTER"] :
			self.__exec(command)
		print("Returning back up from %s" % self.workdir)
	
	def __exec(self, command) :
		newcmd = self.interpolate(command.strip()) # expand ${variable} into "literal" values
		if (len(newcmd) > 0) and (newcmd[0] != "#") :
			print("Executing command: %s" % newcmd)
			if newcmd[0] != "@" :
				cmd, param = newcmd.split(" ", 1)
				if cmd == "lift" :
					shutil.move(os.path.join(os.getcwd(), param), self.__option("target"))
				elif cmd == "wait" :
					time.sleep(float(param))
				elif cmd == "delete" :
					tmp = parsePaths(param)
					deletePath(tmp[0])
				elif cmd == "mkdir" :
					ensurePath(param)
				elif cmd == "echo" :
					print(param)
				elif cmd == "move" :
					tmp = parsePaths(param)
					if len(tmp) == 2 :
						movePath(tmp[0], tmp[1])
				elif cmd == "copy" :
					tmp = parsePaths(param)
					if len(tmp) == 2 :
						copyPath(tmp[0], tmp[1])
				elif cmd == "set" :
					name, value = param.split(" ", 1)
					self.data["OPTIONS"][name] = value
				else :
					# eat unknowns silently
					pass
			else :
				flushStd()
				os.system(newcmd[1:]) # remove the @ at start and execute


#-----------------------------------------------------------------------------
# MAIN CODE

here = toUnicode(os.getcwd())

try :
	import subprocess
	use_subprocess = True
except :
	print("Could not load module 'subprocess' - detection of makeobj errors does not work!")
	use_subprocess = False

if os.path.exists(os.path.join(here, CONFIG_FILE_NAME)):
	print("%s found in \"%s\", processing..." % (CONFIG_FILE_NAME, here))
	e = Entry(dir=here)
	if os.path.exists(os.path.join(here, "post-build.tab")) :
		with open("post-build.tab", "r") as f :
			e.data["COMMANDS-AFTER"] += map(toUnicode, f.readlines())
	e.do()
	print("Finished.")
else :
	print("%s wasn't found in \"%s\" !" % (CONFIG_FILE_NAME, here))
