import psutil
from datetime import datetime

# loop through network connections looking for connections established to our port
for connection in psutil.net_connections():
	# this must be checked first as non-established connections do not have a raddr port
	if connection.status == 'ESTABLISHED':
		if connection.raddr.port == 4888:
			now = datetime.now()
			dt_string = now.strftime("%m/%d/%Y %H:%M:%S")

			# save the remote address and the local port used to connect
			connInfo = "\n%s Connected to %s on port %s" %(dt_string, connection.raddr.ip, connection.laddr.port)
			
			# get the current port from the receiving address
			port = str(connection.raddr.port)

			with open('netsockmon.log', 'a+') as logfile:
				try:
					# set the file pointer to the beginning of the file
					logfile.seek(0)

					#move to end of the log
					for line in logfile:
						pass
					lastCheck = line

					#grab the last socket
					prePort = line[-5:]

					# if the current socket is different than before update the log
					if prePort != port:
						logfile.write(connInfo)

				# except occurs if the file is empty
				except:
					logfile.write(connInfo)






