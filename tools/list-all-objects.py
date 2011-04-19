#! /usr/bin/python
#  -*- coding: utf-8 -*-
#
#  Vladimír Slávik 2010-2011
#  Python 2.6, 3.1
#
#  for Simutrans
#  http://www.simutrans.com
#
#  code is public domain
#

# extract names of all present objects

from __future__ import print_function
import os
import simutools

Data = []
	
simutools.walkFiles(os.getcwd(), simutools.loadFile, cbparam=Data)
simutools.pruneList(Data)

names = [obj.ask("name", "", False) for obj in Data]
names.sort()

print("\n".join(names))

#-----
# EOF