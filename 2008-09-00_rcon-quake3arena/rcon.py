#!/usr/bin/python
#
# usage: ./rcon.py "command"
# please put the command in quotations!

import sys
from socket import *

# q3server details
host = "localhost"
port = 27960
buf = 2084
addr = (host,port)
rconpass = "password"

# packet header
header = ("\xff" * 4) + "rcon "

# open socket to speak to server
UDPSock = socket(AF_INET,SOCK_DGRAM)

# the meat
command = sys.argv[1]
data_out = header + rconpass + " " + command
if(UDPSock.sendto(data_out,addr)):
	print data_out

data_in = UDPSock.recv(buf)
if not data_in:
	print "no response from server"
else:
	print data_in

# Close socket
UDPSock.close()
