#!/usr/bin/python
import os
import re

infile = open('domains', 'r')
outfile = open('output', 'a')

for line in infile:
	line = line.strip('\n') # yank the newline off to make printing pretty and play nice with shell one-liners
	x = os.system('host ' + line + ' | grep PREFIX.*')

	if not x: # that system call returns 0 if found, 256 if not
		print line + ' is hosted by us'
		outfile.write(line + '\t Y' + '\n')
	else:
		outfile.write(line + '\t N' + '\n')

infile.close()
outfile.close()
