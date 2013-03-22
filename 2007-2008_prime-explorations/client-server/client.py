#!/usr/bin/python

# this is the client app!

import subprocess
from socket import *

# client!
c_host = "localhost"
c_port = 20000
c_addr = (c_host, c_port)

# shared buffer size
buf = 1024

# server!
s_host = "10.0.1.106"
s_port = 20001
s_addr = (s_host, s_port)

# Create socket and bind to addres
c_UDPSock = socket(AF_INET, SOCK_DGRAM)
c_UDPSock.bind(c_addr)

s_UDPSock = socket(AF_INET, SOCK_DGRAM)
s_UDPSock.bind(s_addr)

# Receive messages
while 1:
	data, s_addr = c_UDPSock.recvfrom(buf)
	data = str(data)
	
	x = subprocess.Popen(['./a.out', data], stdout=subprocess.PIPE)
	output = x.communicate()[0]

	s_UDPSock.sendto(data, s_addr)

# Close sockets
c_UDPSock.close()
s_UDPSock.close()
