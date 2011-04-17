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

"""
This script reads file compat.tab and "lifts" translations for replaced
objects from the old ones (*.tab in folder old) to new ones (in folder new).
"""

#----------------------

import os.path, glob

#----------------------

def tab2dict(tabfile) :
    f = open(tabfile, 'r')
    raw = f.readlines()
    f.close()
    del f
    d = {}
    for i in range(len(raw) / 2) :
        d[raw[i*2]] = raw[i*2+1]
    return d

#----------------------

os.mkdir("new")

mapping = tab2dict("compat.tab")
os.chdir("old")
langs = glob.glob("*.tab")

for lang in langs :
    translation = tab2dict(lang)
	curlang = os.path.join("..", "new", lang)
    f = open(curlang, 'w')
    for item in mapping :
        newitem = mapping[item]
        if translation.has_key(item) :
            text = translation[item]
            f.write(newitem)
            f.write(text)
    f.close()
