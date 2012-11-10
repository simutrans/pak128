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

# read dat files
# filter by parameters
# list objects

# syntax:
#    lsobj.py [option] [test??value] [+display]
# where
#    test??value is a condition, eg. speed<=50
#    +display makes the parameter show, eg. +speed
#    option can be
#        -R  for recursive search
#        -g  to keep objects without parameters present
#        -m  to keep objects on which compariosn fails
#        -x, -xml  output in XML
#        -h, -html output in HTML
#        -t, -text output in plain text (suitable for console)
#        -c, -csv  output in CSV

import os, math, re

from sys import argv

import simutools

#-----

Data = []
rules = []

recursive = False
out_format = "text"
get_fail = True
cmp_fail = True
entries = ["name"]

matcher = re.compile(r"([\w]+)([<>=!*]{1,2})(.*)")

#-----

for arg in argv :
	if arg[0] == "-" :
		# options start with -
		if arg == "-R" :
			# recursive search
			recursive = True
		elif (arg == "-x") or (arg == "-xml") :
			# output in xml
			out_format = "xml"
		elif (arg == "-h") or (arg == "-html") :
			# output in html
			out_format = "html"
		if (arg == "-c") or (arg == "-csv") :
			# output csv
			out_format = "csv"
		elif (arg == "-t") or (arg == "-text") :
			# output in plain text with tabs
			out_format = "text"
		elif arg == "-g" :
			# drop object when parameter is not present?
			get_fail = False
		elif arg == "-m" :
			# drop object if comparison fails?
			cmp_fail = False
	elif arg[0] == "+" :
		# +param adds param to output
		entries += [arg[1:]]
	else :
		# default to condition (3 parts)
		pieces = matcher.findall(arg)
		if len(pieces) == 1 :
			rules += [pieces[0]]


simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data, recurse=recursive) # load stuff
simutools.pruneList(Data)

for rule in rules :
	# rule is (param, operator, value) of strings
	simutools.pruneByParamCmp(Data, rule[0], rule[1], rule[2], "magic")

# header
if out_format=="html" :
	print("<!doctype html>\n<html>\n<head>\n<title>lsobj</title>\n</head>\n<body>\n<table>")
	print("<thead><tr><th>", "</th><th>".join(entries), "</th></tr></thead>\n<tbody>", sep="")
elif out_format=="xml" :
	print("<?xml version=\"1.0\"?>\n<list>")
elif out_format=="csv" :
	print(";".join(entries))

# data
for obj in Data :
	values = [str(obj.ask(item)) for item in entries]
	if out_format=="text" :
		print("\t".join(values))
	elif out_format=="csv" :
		print(";".join(values))
	elif out_format=="html" :
		print("<tr><td>", "</td><td>".join(values), "</td></tr>", sep="")
	elif out_format=="xml" :
		print("<obj ", end="")
		for i in range(len(entries)) :
			print(entries[i], "=\"", values[i], "\" ", sep="", end="")
		print("/>")

# footer
if out_format=="html" :
	print("</table>\n</body>\n</html>")
elif out_format=="xml" :
	print("</list>")

# EOF
