import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int xPos = 4900;
int yPos = 4900;
int stepSize = 400;
String lnEnd = ",END\n";
void setup() 
{
  size(200, 200);
  println(Serial.list());
  String portName = Serial.list()[3];
//  String portName = "/dev/tty.robot-2B1A-RNI-SPP";
  myPort = new Serial(this, portName, 57600);
  myPort.write("C09," + str(xPos) + "," + str(yPos) + lnEnd); //Sets initial position
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    print(myPort.readString());         // read it and store it in val
  } 
}

void keyPressed() {
  println(key);
  int keyIndex = -1;
  String cmd = "";
  if (key == '-' ) { //pen up
    cmd = "C13,END\n";
  } else if (key == '=') { //pen down
    cmd="C14,END\n";
  } else if(key == 'a') { //up
    yPos += stepSize;
    cmd="C01," + str(xPos) + "," + yPos + lnEnd;
  } else if(key == 'w') { //left
    xPos -= stepSize;
    cmd="C01," + str(xPos) + "," + yPos + lnEnd;
  } else if(key == 'd') { //right
    xPos += stepSize;
    cmd="C01," + str(xPos) + "," + yPos + lnEnd;
  } else if(key == 's') { //down
    yPos -= stepSize;
    cmd="C01," + str(xPos) + "," + yPos + lnEnd;
  } else if (key == 'p') { //draw pixel -- currently goes crazy
    cmd="C06,100,100,30,50,END,\n";
  }
  println(cmd);
  myPort.write(cmd);
}

