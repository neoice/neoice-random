#!/usr/bin/python

from socket import *


# client!
c_host = "10.0.1.12"
c_port = 20000
c_addr = (c_host, c_port)

# shared buffer size
buf = 1024

# server!
s_host = "localhost"
s_port = 20001
s_addr = (s_host, s_port)

#Create socket
c_UDPSock = socket(AF_INET,SOCK_DGRAM)

# Send messages
while (1):
	data = raw_input('>> ')
	if not data:
		break
	else:
		if(c_UDPSock.sendto(data, c_addr)):
			print "Sending message '",data,"'....."

	data = c_UDPSock.recv(buf)
	print data

# Close socket
UDPSock.close()
