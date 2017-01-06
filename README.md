# DrawBot3000


## To Do ##

- Easy Orientation Method (with limit switches)
- Autonomous mode in polargraph
- ~~Draw detailed vector for fine tuning~~
- ~~Improve Gondola~~

##File Host##

- You can setup your paths on the host, and then export then queue. Use 'sudo python host.py <yourqueue>' to run the queue


##Motors##

http://www.anaheimautomation.com/manuals/stepper/L010174%20-%2017Y%20Series%20Spec%20Sheet.pdf
-The motors are 2 phase steppers, each with 2 coils. 

left:
- red/orange = pair 1; brown/green = pair 2





##Organization##
####Control####
Contains all of the different approaches of controlling the robot. At the time of this writing, that includes Harvey Moon, Polargraph, and Makelangelo.

####DesignGeneration###
Contains sketches used to generate paths for the robot to draw. At the time of this writing, this includes Death to Sharpie to generate CNC paths and a constrained random walker sketch.



## Some useful links:##
Protocol - Ascii Commands and Responses
https://github.com/euphy/polargraph/wiki/Polargraph-machine-commands-and-responses

## Time Lapse Video ##
[![Drawbot Time Lapse](http://img.youtube.com/vi/pmY5iP3o-BI/0.jpg)](https://www.youtube.com/watch?v=pmY5iP3o-BI)
