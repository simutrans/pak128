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

# module simuauthors.py - PASSIVE, not a script!

# when adding new author, please follow the pattern

# ----------------------------------------------------------------------------

whitelist = [

# single authors!
# ---------------

 "Raven",

 "Vladimir Slavik",

 "Napik",

 "Patrick",

 "O. Zarevucky",

 "Shunter",

 "Hajo",

 "Isaac",

 "S. Kroytor",

 "DirrrtyDirk",

 "yoshi",

 "Joker",

 "A. Brose",

 "James Starr",

 "Martin",

 "Fabio Gonella",

 "BlackBox",

 "MHz",

 "Kierongreen",

 "Vitus",

 "Gelion",

 "prissi",

 "Nabe",

 "Pawel",

 "Flor Wauters",

 "powersack",

 "Sindor",

 "Mark Norman",

 "Shorty",

 "AvG",

 "Timothy Baldock",

 "MiP",

 "Trikky",

 "Stormoog",

 "Frans van Nispen",

 "TommPa9",

 "Jakob Schaefer",

 "Peter J. Dobrovka",
 
 "Jan Polacek",
 
 "Haru",
 
 "DanteDarkstar",
 
 "Zeno",
 
 "Asterix909",
 
 "vilvoh",
 
 "Rmax500",
 
 "Propermike",
 
 "Gouv",
 
 "Sique",
 
 "Karl",
 
 "Zkou2",

 ];

# ----------------------------------------------------------------------------

# helper functions
# ----------------

# queries can be in form "autor1 & author2 & author3 & ..."

def SplitAuthors(astr) :
	tmp = astr.split("&")
	for i in range(len(tmp)) :
		# range -> xrange makes py3 die, and the amount will be low in real situations
		tmp[i] = tmp[i].strip()
	return tmp


def CheckAuthors(astr) :
	# TRUE if all authors
	tmp = SplitAuthors(astr)
	for author in tmp :
		if author not in whitelist :
			return False
	return True

# EOF