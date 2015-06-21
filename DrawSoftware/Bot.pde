
class Bot extends PApplet{

Serial myPort; //declare serial port
private boolean serialOn = true;
int prevZ = 0; 
  
 Bot(PApplet p){ //constructor
  
  if (serialOn){
    println("printing serial");
        println(Serial.list());
   String portName = Serial.list()[5];        // Change this Value to fit which Serial Port it is on.
  //String portName = "/dev/null";
  println("chose: " + portName);
  myPort = new Serial(p, portName, 38400);
  } //serial on
  
 } // end Constructor



 void update(){  //check for new atPoint
   if (serialOn){
   while (myPort.available() > 0) {
    char inByte = myPort.readChar();
    if (inByte == '#'){
   atPoint = true; // when drawbot stops at point, it sends # and triggers atPoint
    println("*****At Point*****");
  }//if byte was #
  } // if something came back from the bot 
        } //serial on
 
  if(!serialOn){ // if not attached to drawbot, loop on instead
   
   atPoint = true;
  
     } //serial is off 
   }//update




 void sendVal(float inx, float iny, float upDown){ 
     int xsend;
int ysend;
String xy;

  
  xsend = int(nf(int(inx) * multiplier,5));  
 
 ysend = int(nf(int(iny) * multiplier,5));  



  
xsend += xofset;
ysend += yofset;
xsend = xsend * 100000;
 
xy = nf(xsend + ysend, 10);
   

if(prevZ != int(upDown)){

if(upDown == 1){
  if(servoOn){
    DirectCommand("+"); //moves servo, push pen onto page
  } 
 println("pen is On");
  } // if pen down 

else if(upDown == 0){ //lift pen up
 if(servoOn){
    DirectCommand("-"); //moves servo, push pen off page

 }// servo is on
println("pen is Off"); 
 }// pen is off
 prevZ = int(upDown);
// delay(500);  
  }//if previous Z had changed
 
 println("point was sent");
DirectCommand("*");
DirectCommand(xy);

println(inx + "," +iny);
println("xsend = " + xsend);
println("ysend = " + ysend);
println("xy = " + '*' + xy);
println("_________________________");

 
  }//void sendVal  


void DirectCommand(String j){
 if(serialOn){
  myPort.write(j);
 }

} //direct command

  
  }//end Bot class
