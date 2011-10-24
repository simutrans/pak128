# VS 2011 Python 2.6
#
# turns TAB files into HTML with correct heads; allows easier viewing with a browser
# (needs browser support for all Asian fonts, though... ;-) )
#
# assumes export from SimuTranslator with standardized header
# (changing the regexps would allow other inputs)
#

import glob
import re


r_coding = re.compile("Encoding: ([^ ]+) ")
r_name = re.compile("Language: ([a-z]{2} [^ ]+)")


for file in glob.glob("*.tab") :
	f = open(file)
	lines = f.readlines()
	f.close()
	text = "".join(lines)
	
	encoding = r_coding.findall(text)[0]
	name = r_name.findall(text)[0]
	
	recoded = text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
	
	head = "<DOCTYPE html>\n<head>\n<title>%s</title>\n<meta http-equiv='Content-Type' content='text/html; charset=%s' />\n</head>\n<body style='white-space: pre; font-family: monospace'>\n" % (name, encoding)
	
	newfile = open(file + ".html", 'w')
	newfile.write(head)
	newfile.write(recoded)
	newfile.write("\n</body></html>\n")
	newfile.close()
