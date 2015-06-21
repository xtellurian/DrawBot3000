#include <AFMotor.h> //Adafruit Motor Shield
#include <stdlib.h> // atoi converter
#include <Servo.h>  //Servo Controller
                                                                  
AF_Stepper motor1(400, 1);
AF_Stepper motor2(400, 2);

Servo myservo;  // create servo object to control a servo (used to push the pen on and off of page) 


int val;

//This is the calculation of how many steps are needed to move the belt one inch.
int StepUnit = 127; // use with small cogs


//stuff for serial parsing



int incomingByte;
int digit;
int xval;
int yval;
int dig = 0;
byte PenOn = '-';


// Approximate dimensions of the total drawing area - measure it and put in inches below.
//for melbourne should be a square..
// try to be as exsact as you can, (the height is only important to know your maximum drawing pixel size)
int w = 50*StepUnit;
int h= 70*StepUnit;

// Coordinates of current (starting) point
//Use this to offset the starting point, this will make sure that the machine doesn't start at the absolute corner, causing mechanical problems.
// 1 inch = 150px - extrapolate/

//9"across 14" down = 1350px x 2100px
int x1 = 1350; 
int y1 = 2100;


// Approximate length of strings from marker to staple, think patagorean theorem
int a1= sqrt(pow(x1,2)+pow(y1,2));
int b1= sqrt(pow((w-x1),2)+pow(y1,2));



// Coordinate of upper left corner of page
int page0X = x1;
int page0Y = y1;


void setup() { 
  
  
    myservo.attach(9);  // attaches the servo to SERVO2 on the Adafruit MS
  myservo.write(160);
  
  
  	Serial.begin(38400);	// opens serial port, sets data rate to 38400 bps
  // Set up stepper motors and random # seed, if needed
  delay(2000); 
 motor1.setSpeed(60);     
 motor2.setSpeed(60);                                                                                                                                                           
  delay(2000);                                                                            
  randomSeed(analogRead(0));

Serial.print("WH ");
Serial.print(w, DEC);
Serial.print(',');
Serial.println(h, DEC);
Serial.println("#");

}                                                                                       


float rads(int n) {
  // Return an angle in radians
  return (n/180.0 * PI);
}                                                                        

void moveTo(int x2, int y2) {
  
//this controlls the actual movement of the stepper motors, adding or removing steps as necessary.
  
  // a2 and b2 are the final lengths of the left and right strings
  int a2 = sqrt(pow(x2,2)+pow(y2,2));
  int b2 = sqrt(pow((w-x2),2)+pow(y2,2));
  int stepA;
  int stepB;
  if (a2>a1) { 
    stepA=1; 
  }
  if (a1>a2) { 
    stepA=-1;
  }
  if (a2==a1) {
    stepA=0; 
  }
  if (b2>b1) { 
    stepB=1; 
  }
  if (b1>b2) { 
    stepB=-1;
  }
  if (b2==b1) {
    stepB=0; 
  }

  // Change the length of a1 and b1 until they are equal to the desired length
  while ((a1!=a2) || (b1!=b2)) {
    if (a1!=a2) { 
      a1 += stepA;
     
     if (stepA == -1){
    motor1.step(1, BACKWARD, INTERLEAVE);
  }
    if (stepA == 1){
       motor1.step(1, FORWARD, INTERLEAVE);
    }
      if(stepA == 0){
  //    motor1.release();
      
      }
      //delay(1);
    
    }
    if (b1!=b2) { 
      b1 += stepB;

    if (stepB == -1){
    motor2.step(1, BACKWARD, INTERLEAVE);
  }
     if (stepB == 1){
       motor2.step(1, FORWARD, INTERLEAVE);
     }

      if(stepB == 0){
    //  motor2.release();
      
      }  
      
     
    }
  }
  x1 = x2;
  y1=y2;
  
}

void straightLine (int x2, int y2) //this uses the Bresenheim algorithm to create a straight line between two incoming points.
{
	  int deltax = abs(x2 - x1);	  // The difference between the x's
 	 int deltay = abs(y2 - y1);	  // The difference between the y's
 	 int xnow = x1;			     // Start x off at the first pixel
 	 int ynow = y1;			     // Start y off at the first pixel
 	 int xinc1, xinc2, yinc1, yinc2, den, num, numadd, numpixels, curpixel;


 
  if (x2 >= x1) {		    // The x-values are increasing
	    xinc1 = 1;
	    xinc2 = 1;
  }
  else {				  // The x-values are decreasing
	    xinc1 = -1;
	    xinc2 = -1;
  }

  if (y2 >= y1)		     // The y-values are increasing
  {
   	 yinc1 = 1;
   	 yinc2 = 1;
  }
  else				  // The y-values are decreasing
  {
  	  yinc1 = -1;
  	  yinc2 = -1;
  }

  if (deltax >= deltay)	   // There is at least one x-value for every y-value
  {
    	xinc1 = 0;			// Don't change the x when numerator >= denominator
    	yinc2 = 0;			// Don't change the y for every iteration
    	den = deltax;
   	 num = deltax / 2;
   	 numadd = deltay;
   	 numpixels = deltax;	   // There are more x-values than y-values
  }
  else				  // There is at least one y-value for every x-value
  {
   	 xinc2 = 0;			// Don't change the x for every iteration
    	yinc1 = 0;			// Don't change the y when numerator >= denominator
    	den = deltay;
    	num = deltay / 2;
	    numadd = deltax;
	    numpixels = deltay;	   // There are more y-values than x-values
  }

  for (curpixel = 0; curpixel <= numpixels; curpixel++)
  {
    
    
    
	    moveTo(xnow, ynow);		 // Draw the current pixel
 
   	 num += numadd;		  // Increase the numerator by the top of the fraction
    if (num >= den)		 // Check if numerator >= denominator
    {
	num -= den;		   // Calculate the new numerator value
	xnow += xinc1;		   // Change the x as appropriate
	ynow += yinc1;		   // Change the y as appropriate
    }
    xnow += xinc2;		     // Change the x as appropriate
    ynow += yinc2;		     // Change the y as appropriate
  }
  
  
  x1 = x2;
  y1 = y2;
  Serial.println("#");
}





                                                                                                
void loop() {




 
	// send data only when you receive data:
	if (Serial.available() > 0) { 
  
  
  
  
  
  dig = dig +1;
// read the incoming byte:
incomingByte = Serial.read();

//This is how the single bytes are recieved seperately and recombined.


if (incomingByte == 'S'){ //prints the total size of the drawing area in Pixels.
    dig = 0;
Serial.print("WH ");
Serial.print(w, DEC);
Serial.print(',');
Serial.println(h, DEC);
Serial.println("#");
}


if (incomingByte == '.'){  // use the '.' and ',' keys to move the left motor to calibrate it to the first point.
    dig = 0;
motor1.step(127, FORWARD, INTERLEAVE);
}

if (incomingByte == ','){
    dig = 0;
  motor1.step(127, BACKWARD, INTERLEAVE);

}


if (incomingByte == '>'){ // use the '<' and '>' keys to move the right motor to calibrate it to the first point.
    dig = 0;
motor2.step(127, BACKWARD, INTERLEAVE);
}

if (incomingByte == '<'){
    dig = 0;
  motor2.step(127, FORWARD, INTERLEAVE);

}


  
if(PenOn != incomingByte){
 



      if (incomingByte == '+'){
        int angleIncrement = 1;
        int incrementDelay = 20;
        for (int angle = 180; angle > 120; angle -= angleIncrement) { // single "degree" increments
          myservo.write (angle);
          delay (incrementDelay); // so we'll take 10 * 180 milliseconds = 1.8 seconds for the traverse.
        } 
        //delay(1000); 
        //  myservo.write(50);              // tell servo to go to position in variable 'pos' 
        delay(100);
        dig = 0; 

        motor1.setSpeed(12); //moove slowly for active points
        motor2.setSpeed(12); 
        PenOn = incomingByte;       
      }

      if (incomingByte == '-'){

        delay(500);
        myservo.write(180);              // tell servo to go to position in variable 'pos' 

        dig = 0;
        delay(200);

        motor1.setSpeed(80);  // move quickly for non points 
        motor2.setSpeed(80);
        PenOn = incomingByte;
      }




} // if penStatus changed

// asterisk inbetween coords resets point buffer


if (incomingByte == '*'){
   xval = 0;
  yval = 0;
  
  dig = 0;
 
 
  
}

  digit = int(incomingByte) - '0';  // - 0, or ascii value -30 from the incoming digit.  // this is confusing,
  
  
  //if you take the ascii value of digits 0-9 it equels 30 - 39, if you take the value of the ascii value and - "0" 
  //you get the orignal digits. an easy way of converting ascii serial messages, maybe not the best way, but it works well.



  if(dig == 1){
  
 xval += digit * 10000;
}

if(dig == 2){
 xval += digit * 1000;
 }


if(dig == 3){
  xval +=  digit * 100;}
 
  

if(dig == 4){
  xval += digit *10;


}



  if(dig == 5){
  
 xval += digit;
}

if(dig == 6){
 yval += digit * 10000;
 }

if(dig == 7){
  yval +=  digit * 1000;}
 
  if(dig == 8){
  yval += digit * 100;
  }
  if(dig == 9){
  yval += digit * 10;
  }

  if(dig == 10){
  yval += digit;
  





Serial.print(xval, DEC);
Serial.print(',');
Serial.println(yval, DEC); 
straightLine (xval, yval);

  }


 }
}

