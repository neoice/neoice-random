### dns.py
### check if hostnames use *.example.net as a Nameserver
### WARNING: this script appears to hang throughout (whois response times?). ctrl+c when it does and be careful using the data!
### WARNING: due to the way this is misusing os.system, this script DOES NOT DIE EASILY.
### runtime: 59m57.848s59m57.848s59m57.848s59m57.848s59m57.848s59m57.848s59m57.848s 

#!/usr/bin/python
import os
import re

infile = open('domains', 'r')
outfile = open('dns.output', 'a')

for line in infile:
	line = line.strip('\n') # yank the newline off to make printing pretty and play nice with shell one-liners
	x = os.system('whois ' + line + ' | grep -i \'Name Server: [a-zA-Z0-9]*.example.net\'')

	if not x: # that system call returns 0 if found, 256 if not
		outfile.write(line + '\t *.example.net' + '\n')
	else:
		outfile.write(line + '\n')

infile.close()
outfile.close()
