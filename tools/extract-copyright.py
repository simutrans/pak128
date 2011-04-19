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

# read all dat files in all subfolders and produce list of objects and their authors

from __future__ import print_function

import re, os, glob, copy

import simuauthors
import simutools

#-----

Data = []

rx_finder = re.compile(r"([Cc]opyright|[Nn]ame|[Oo]bj)[ ]?=(.+)")
# result is [(first, second)] -> list of tuples -> but only one tuple for correct DAT
# ask for strings inside as [0][0] and [0][1]

#-----

def writeCsv(fname, dataset = Data) :
	f = open(fname, 'w')
	for item in dataset :
		f.write(item.ask("obj") + ";" + item.ask("name") + ";" + item.ask("copyright", "", False) + "\n")
	f.close()

#-----

def queryData(func, param = None, dataset = Data) :
	i = len(dataset) - 1
	while i >= 0 :
		if func(dataset[i], param) :
			del(dataset[i])
		i = i - 1

#-----

def removeEmpty(item, foo) :
	return not bool(item.ask("copyright")) and not bool(item.ask("name"))

def removeEmptyAuthors(item, foo) :
	return not bool(item.ask("copyright"))

def removeAuthor(item, author) :
	return item.ask("copyright") == author # case sensitive!

def keepOnlyAuthor(item, author) :
	return item.ask("copyright") != author

def keepOnlyAuthors(item, authors) :
	return item.ask("copyright") not in authors

def keepOnlyEmptyAuthors(item, foo) :
	return bool(item.ask("copyright"))

def keepOnlyUnknown(item, foo) :
	c = item.ask("copyright")
	return bool(c) and (c != "?")

def checkAuthors(item, foo) :
	return simuauthors.CheckAuthors(item.ask("copyright", "", False))

def removeObj(item, foo) :
	return item.ask("obj") in foo

#-----

def SaveAuthors(filename, authornames, dataset = Data) :
	Tmp = copy.deepcopy(dataset)
	queryData(keepOnlyAuthors, authornames, dataset)
	writeCsv(filename, dataset)

#-----


simutools.walkFiles(os.getcwd(), simutools.loadFile, "statsignore.conf", True, Data)
simutools.pruneList(Data)

# now Data[] is full representation

writeCsv("raw.csv")
# save all data without changes

queryData(removeEmpty)
queryData(removeObj, ["program_text", "menu_text", "record_text"])

EmptyItems = copy.deepcopy(Data)
queryData(keepOnlyUnknown, dataset = EmptyItems)
writeCsv("empty-copyright.csv", dataset = EmptyItems)
del EmptyItems

##SaveAuthors("martin.csv", ["Martin", "martin"])

queryData(removeEmptyAuthors)
queryData(removeAuthor, "none")
queryData(removeAuthor, "None")

queryData(checkAuthors)

#-----

# write result to file
writeCsv("final-analysis.csv")

# EOF

