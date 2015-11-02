import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int xPos = 4900;
int yPos = 4900;
int stepSize = 400;
String lnEnd = ",END\n";
boolean drawPath = true;
PVector curPos;
PVector max = new PVector(5981,6662);
PVector min = new PVector(2915,2926);
PVector pageOffset = new PVector(2915,4145);
boolean isReady = false;
String readyStr = "READY";
float screenToBotScale = 2;

void setup() 
{
  size(1024, 800);
  println(Serial.list());
  String portName = Serial.list()[3];
//  String portName = "/dev/tty.robot-2B1A-RNI-SPP";
  myPort = new Serial(this, portName, 57600);
  curPos = new PVector((int)random(max.x), (int)random(max.y));
//  curPos.x = clamp(curPos.x,
  //myPort.write("C17," + str(curPos.x) + "," + str(curPos.y) + lnEnd); //Sets initial position
  println("Starting at " + curPos.x + "." + curPos.y);
  
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
    String rawMsg = myPort.readString();
    String trimMsg = trim(rawMsg);
    if(trimMsg.equals(readyStr)) {
       isReady = true;
    }
    print(rawMsg);         // read it and store it in val
  } 
  
  if(isReady) {
    PVector oldPos = botToScreen(curPos); 
    curPos = getNewPos(curPos, (int)max.x, (int)max.y);
    movePenToPoint(curPos);
    PVector newPos = botToScreen(curPos);  
    line(oldPos.x,oldPos.y, newPos.x, newPos.y);
  }
  
  if(!isReady) {
    println("not ready");
  }
}

PVector screenToBot(PVector screen) {
  return new PVector(screen.x*screenToBotScale, screen.y*screenToBotScale);
}

PVector botToScreen(PVector bot) {
  return new PVector(bot.x*(1/screenToBotScale), bot.y*(1/screenToBotScale));
}

void movePenToPoint(PVector newPos) {
  String cmd="C17," + str(newPos.x) + "," + newPos.y + lnEnd;
  sendCommand(cmd);
}
  


PVector getNewPos(PVector oldPos, int xBounds, int yBounds) {
  PVector newPos = new PVector(oldPos.x,oldPos.y);
  int maxChange = 10;
  newPos.x += (int)random(-maxChange,maxChange);
  newPos.y += (int)random(-maxChange,maxChange);
 
  newPos.x = clamp((int)newPos.x, 0, xBounds);
  newPos.y = clamp((int)newPos.y, 0, yBounds);
 
  if(drawPath) {
    stroke(0);
    line(oldPos.x,oldPos.y,newPos.x,newPos.y);
  }
  
  return newPos;
}


int clamp(int in, int min, int max) {
  if(in > max) { 
    return max;
  }
  
  if(in < min) { 
    return min;
  }
  
   return in;
   
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

void sendCommand(String cmd) {
  println(cmd);
  myPort.write(cmd);
}

