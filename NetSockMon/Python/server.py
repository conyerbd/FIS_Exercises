import socket
import time

# create a socket object
s = socket.socket()
print ("socket successfully created")

# specify a port
port = 4888

# bind to the port, 
# empty string is to allow listening from any computer
s.bind(('', port))
print ("socket binded to %s" %(port))

# put the socket into listening mode
s.listen(5)
print ("socket is listening")

# loop while listening for connections 
while True:

	# Establish connection with client.
	c, addr = s.accept()
	print ('Got connection from', addr)

	#send a think you message to the client.
	# need to use 'b' to sent message as bytes
	c.send(b'Thank you for connecting')

	time.sleep(60)

	# Close the connection with the client
	c.close()