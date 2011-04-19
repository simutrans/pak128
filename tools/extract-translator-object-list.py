#!/usr/bin/python
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

# take a given translation (from Translator) and extract sorted list of objects

from __future__ import print_function

f = open("list.tab", "r")

names = f.readlines()[::2]

names.sort()

print("".join(names))

f.close()