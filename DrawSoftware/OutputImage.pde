class OutputImage {

  PImage img; //declare the image variable
  String filename;
  int savecounter = 0;
  int totalGoodSpots = 0;

  OutputImage() {
  }

  void addCount() {

    totalGoodSpots++;
    savecounter++;
    saveImage();   // check to see if it should save image yet or not
  }


  void saveImage() {
    if(savecounter >= 30) {
      if(timelapse == true) {
        filename = "backup"+ str(totalGoodSpots/30) + ".jpg";
        println(filename);
      } //yes timelapse
      
      if(timelapse == false) {
        filename = "backup.jpg";
        println(filename);
      } //no timelapse   

        if(doSave) {         
        save(filename);
      } // save
        savecounter = 0; // reset save counter after save image
    }// save counter limit
  } //void saveImage()



  
  }//class OutputImage

