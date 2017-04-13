 ///////////////////////////////////////////////////////////////////////////////////////////////////////
// My Drawbot, "Death to Sharpie"
// Jpeg to gcode simplified (kinda sorta works version, v3.2 (beta))
//
// Scott Cooper, Dullbits.com, <scottslongemailaddress@gmail.com>
//
// Open creative GPL source commons with some BSD public GNU foundation stuff sprinkled in...
// If anything here is remotely useable, please give me a shout.
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Constants set by user, or maybe your sister.
final float   paper_size_x = 32 * 25.4;
final float   paper_size_y = 40 * 25.4;
final float   image_size_x = 30 * 25.4;
final float   image_size_y = 35 * 25.4;
final float   paper_top_to_origin = 500;  //mm

// Super fun things to tweak.  Not candy unicorn type fun, but still... 
int     squiggle_total_init = 50;     // Total times to pick up the pen
int     squiggle_total = squiggle_total_init;

int     squiggle_length_init = 400;    // Too small will fry your servo
int     squiggle_length = squiggle_length_init;

int     half_radius_init = 5;          // How grundgy
int     half_radius = half_radius_init;          // How grundgy


int     adjustbrightness_init = 12;     // How fast it moves from dark to light, over draw
int     adjustbrightness = adjustbrightness_init;     // How fast it moves from dark to light, over draw


final float   sharpie_dry_out = 0.0;   // Simulate the death of sharpie, zero for super sharpie
final String pic_name = "skull2.jpg";
final String  pic_path = "pics/" + pic_name; 

//Every good program should have a shit pile of badly named globals.
int    screen_offset = 4;
float  screen_scale = 1.0;
int    steps_per_inch = 25;
int    x_old = 0;
int    y_old = 0;
PImage img;
int    darkest_x = 100;
int    darkest_y = 100;
float  darkest_value;
int    squiggle_count;
int    x_offset = 0;
int    y_offset = 0;
float  drawing_scale;
float  drawing_scale_x;
float  drawing_scale_y;
int    drawing_min_x =  9999999;
int    drawing_max_x = -9999999;
int    drawing_min_y =  9999999;
int    drawing_max_y = -9999999;
int    center_x;
int    center_y;
boolean is_pen_down;
PrintWriter OUTPUT;       // instantiation of the JAVA PrintWriter object.

///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  size(900, 975, P2D);
  noSmooth();
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, 100);  
  frameRate(120);
  
  OUTPUT = createWriter("gcode.txt");
  pen_up();
  setup_squiggles();
  img.loadPixels();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  
  for(int i=0; i<5; i++) {
  for(int j=0; j<5; j++) {
  for(int k=0; k<5; k++) {
    
    while(squiggle_count < squiggle_total) {
      scale(screen_scale);
      random_darkness_walk();
    
      if (squiggle_count >= squiggle_total) {
//          grid();
//          dump_some_useless_stuff_and_close();
          String filename = "frames/out-" + pic_name + "-" + squiggle_total + "tot_" + squiggle_length + "len_" + half_radius + "rad_" + adjustbrightness + "bri.png";
          println("saving " + filename);
          saveFrame(filename);
          break;
      }
    }
    reset();
    half_radius = half_radius_init + j*5;
    squiggle_total = squiggle_total_init + i*50;
    adjustbrightness = adjustbrightness_init + k*2;
    }
  }
  }
   noLoop();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void setup_squiggles() {
  img = loadImage(sketchPath("") + pic_path);  // Load the image into the program  
  img.loadPixels();
  
  drawing_scale_x = image_size_x / img.width;
  drawing_scale_y = image_size_y / img.height;
  drawing_scale = min(drawing_scale_x, drawing_scale_y);

  println("Picture: " + pic_path);
  println("Image dimensions: " + img.width + " by " + img.height);
  println("adjustbrightness: " + adjustbrightness);
  println("squiggle_total: " + squiggle_total);
  println("squiggle_length: " + squiggle_length);
  println("Paper size: " + nf(paper_size_x,0,2) + " by " + nf(paper_size_y,0,2) + "      " + nf(paper_size_x/25.4,0,2) + " by " + nf(paper_size_y/25.4,0,2));
  println("Max image size: " + nf(image_size_x,0,2) + " by " + nf(image_size_y,0,2) + "      " + nf(image_size_x/25.4,0,2) + " by " + nf(image_size_y/25.4,0,2));
  println("Calc image size " + nf(img.width * drawing_scale,0,2) + " by " + nf(img.height * drawing_scale,0,2) + "      " + nf(img.width * drawing_scale/25.4,0,2) + " by " + nf(img.height * drawing_scale/25.4,0,2));
  println("Drawing scale: " + drawing_scale);

  // Used only for gcode, not screen.
  x_offset = int(-img.width * drawing_scale / 2.0);  
  y_offset = - int(paper_top_to_origin - (paper_size_y - (img.height * drawing_scale)) / 2.0);
  println("X offset: " + x_offset);  
  println("Y offset: " + y_offset);  

  // Used only for screen, not gcode.
  center_x = int(width  / 2 * (1 / screen_scale));
  center_y = int(height / 2 * (1 / screen_scale) - (steps_per_inch * screen_offset));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void grid() {
  // This will give you a rough idea of the size of the printed image, in inches.
  // Some screen scales smaller than 1.0 will sometimes display every other line
  // It looks like a big logic bug, but it just can't display a one pixel line scaled down well.
  stroke(0, 50, 100, 30);
  for (int xy = -30*steps_per_inch; xy <= 30*steps_per_inch; xy+=steps_per_inch) {
    line(xy + center_x, 0, xy + center_x, 200000);
    line(0, xy + center_y, 200000, xy + center_y);
  }

  stroke(0, 100, 100, 50);
  line(center_x, 0, center_x, 200000);
  line(0, center_y, 200000, center_y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
void dump_some_useless_stuff_and_close() {
  println ("Extreams of X: " + drawing_min_x + " thru " + drawing_max_x);
  println ("Extreams of Y: " + drawing_min_y + " thru " + drawing_max_y);
  OUTPUT.flush();
  OUTPUT.close();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

void reset() {
  darkest_x = 100;
  darkest_y = 100;
  squiggle_count = 0;
  background(0,0,100);
  clear();
  img = loadImage(sketchPath("") + pic_path);  // Load the image into the program
  img.loadPixels();
}
