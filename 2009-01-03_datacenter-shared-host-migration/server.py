### server.py
### deterime which host a domain is on
### runtime: 0m37.956s

#!/usr/bin/python
import os
import re

infile = open('domains', 'r')
outfile = open('server.output', 'a')

for line in infile:
	line = line.strip('\n') # yank the newline off to make printing pretty and play nice with shell one-liners
	os.system('host ' + line + ' > .tempfile')

	x = os.system('cat .tempfile | grep PREFIX.14')
	if not x: # that system call returns 0 if found, 256 if not
		outfile.write(line + '\t chinook' + '\n')
	else:
		y = os.system('cat .tempfile | grep PREFIX.11')
		if not y: # that system call returns 0 if found, 256 if not
			outfile.write(line + '\t sockeye' + '\n')
		else:
			z = os.system('cat .tempfile | grep PREFIX.12')
			if not z: # that system call returns 0 if found, 256 if not
				outfile.write(line + '\t kokanee' + '\n')
			else: # ugly checking to prevent multiple writes.
				outfile.write(line + '\n')

infile.close()
outfile.close()
