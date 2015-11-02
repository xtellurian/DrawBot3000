import serial
import sys
#import polargraph

#consts
OK = "READY"
	
lineend = '\n'	

#get serial port
ser = serial.Serial('/dev/ttyACM0', 57600)
#commands = polargraph.commands()

#get file data 
[filename] = sys.argv[1:]
with open(filename,'r') as datafile:
	data = datafile.read()
 #convert to useful data
data = str.splitlines(data)
print str(len(data)) + " commands in file"

# funcs
def Next(commandcount):
	return data[commandcount]

count = 0
while count < len(data):
	response = ser.readline()
	print "From Bot: " + response
	if OK in response:
		send = Next(count)
		count = count + 1
		print send
		ser.write(send+lineend)
	

print "Completed"

	
