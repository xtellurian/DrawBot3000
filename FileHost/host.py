import serial
import sys
	
#user = serial.Serial('/dev/tty.robot something', 57600)

[filename] = sys.argv[1:]

with open(filename,'r') as datafile:
	data = datafile.read()
	
data = str.splitlines(data)
print str(len(data)) + " commands in file"







	