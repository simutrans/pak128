#!/usr/bin/python
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

# read data produced by "extract-copyright.py" and create various statistics

#-----------------------------
from __future__ import print_function

import re
from operator import itemgetter
from simuauthors import *

free = 0
nonfree = 0
total = 0
# numbers of objects in various categories

justlen = 32
justnum = 6
# display options

f = open("raw.csv", 'r')
obj_all = f.readlines()
f.close()
# read object data

authors = {"* empty": 0}
# add special entry for empty authors

for line in obj_all : # iterate all objects
	if line != ";" : # skip empty entries
		data = line.split(";")
		type = data[0].strip()
		name = data[1].strip()
		author = data[2].strip()
		del data
		# extract from csv format
		
		if bool(author) and not author.isspace() and not type in ["dummy_info", "program_text", "record_text"]: # 1) is author set? 2) is it object, not translator stuffing?
			for subauthor in author.split("&") : # separate multiauthor entries
				sa = subauthor.strip() # remove whitespace!
				if sa in authors :
					authors[sa] = authors[sa] + 1
				else :
					authors[sa] = 1
				# increase counter for author
		else :
			authors["* empty"] = authors["* empty"] + 1
		
		total = total + 1
		if CheckAuthors(author) :
			free = free + 1
		else :
			nonfree = nonfree + 1
		# increase category counters


if "none" in authors :
	if "None" in authors :
		authors["None"] = authors["None"] + authors["none"]
	else :
		authors["None"]  = authors["none"]
	del authors["none"]
# merge none to None
if "?" in authors :
	if "* empty" in authors :
		authors["* empty"] = authors["* empty"] + authors["?"]
	else :
		authors["* empty"]  = authors["?"]
	del authors["?"]
# merge ? to empty (special)

f = open("statistics.txt", 'w')

f.write("General:\n")
f.write("--------\n\n")
f.write("Total number of objects".ljust(justlen, '.'))
f.write(str(total).rjust(justnum, '.'))
f.write("\n")
f.write("Number of licensed objects".ljust(justlen, '.'))
f.write(str(free).rjust(justnum, '.'))
f.write("\n")
f.write("Number of non-licensed objects".ljust(justlen, '.'))
f.write(str(nonfree).rjust(justnum, '.'))
f.write("\n")
f.write("Number of non-attributed objects".ljust(justlen, '.'))
f.write(str(authors["* empty"]).rjust(justnum, '.'))
f.write("\n")
f.write("Number of \"system\" objects".ljust(justlen, '.'))
f.write(str(authors["None"]).rjust(justnum, '.'))
f.write("\n\n")
# do the big numbers

del authors["* empty"]
del authors["None"]
# remove from individual records

f.write("Authors:\n")
f.write("--------\n\n")
authornames = list(authors.keys())
authornames.sort(key=lambda x: authors[x], reverse=True)
for author in authornames :
	if CheckAuthors(author) :
		f.write("+ ")
	else :
		f.write("- ")
	f.write(author.ljust(justlen - 2, '.'))
	f.write(str(authors[author]).rjust(justnum, '.'))
	f.write("\n")
# print authors sorted by amount of work and +/- for agreement

sum = 0
i = 0
mainauthors = {}
while 1.0 * sum / total < 0.70 : # threshold of significance to show author
	value = authors[authornames[i]]
	mainauthors[authornames[i]] = authornames[i] + " " + "%.0f"%(100.0 * value / total) + "%"
	sum = sum + value
	i = i + 1
rest = total - sum
f.write("\n\nChart of contributors")
f.write("\n\nhttp://chart.apis.google.com/chart?")
f.write("&cht=p") # pie chart
f.write("&chs=600x400") # image size
f.write("&chd=t:") # data - text format
for item in mainauthors.keys() :
	f.write("%.2f," % (1.0 * authors[item] / total))
f.write("%.2f" % (1.0 * rest / total))
f.write("&chl=") # labels
for item in mainauthors.keys () :
	f.write(mainauthors[item] + "|")
f.write("Other %.0f%%" % (100.0 * rest / total))
f.write("\n")

f.close()

# EOF
