class LineToGo{
   PVector[] theLine;

 LineToGo(){ //like a setup for the class  Constructor
 
   theLine =new PVector[]{  new PVector(0,0,0)  };
 } // Constructor
  


 void addToArray(float x, float y, float z){
    theLine =(PVector[]) append(theLine, new PVector(x,y,z)); // add new digit onto array
    drawArray();
 } //void addToArray

void update(){ // checks if atpoint is true, if so, it will send the next point
  if(atPoint == true){
    SendPoint();
  }
}

void SendPoint(){  //sends a point, and removes it from array
   if(theLine.length > 1){  // wait until array is atleast 6 points long, 6 coord buffer
     if(theLine[1].z == 1){ //if pen down/ z = 1
    stroke(0); // black line for trailing/ points already been to
       line(theLine[0].x,theLine[0].y,theLine[1].x,theLine[1].y); 
   } // if pend down / z = 2

     Machine.sendVal(theLine[0].x,theLine[0].y,theLine[0].z);  //send the value before it gets destroyed

   atPoint = false; // reset flag if point sent 
   theLine =(PVector[]) subset(theLine, 1); // take out a point when it has reached it
   drawArray();
 } // 6 point buffer 
 
  } //void sendPoint()


void drawArray(){
  
  if(autoStop){
  if(theLine.length> 200){
  On = false;
   }
   else if(theLine.length<50){
    On = true;
   }
  
  }//autostop
     if(!printArray){
      println("the line is : " + theLine.length + " long"); 
     }
   
     for( int i=1; i<=theLine.length-1; i++) { //cycle through all points in the array if it changes
     
  
     
      if(printArray){
   if(i == 1){
    println("+++++++++++++++++++ array ++++++++++++"); 
   }
        
        println("Point number " + i + " = " + theLine[i]);
 }//print array or not
   if(theLine[i].z == 1){ // if pen down
    stroke(255,100,100); //red line for array
   line(theLine[i-1].x,theLine[i-1].y,theLine[i].x,theLine[i].y); // re draw the array when it changes
 } // pen down / z = 1
  else{ //pen up / z =0
  if(printArray){
  println("lifted");
  }//print array or not
 } // pen up / z = 0

if(i == theLine.length-1){//at the last point in the array  
 if(printArray){
  println("+++++++++++++++++++ array ++++++++++++");   
 }//print array or not
  }// last point in array
  }// cycle through all points 
  } // void drawArray()

}
