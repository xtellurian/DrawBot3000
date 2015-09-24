*  Polargraph Software
*
*  Written by Sandy Noble
*  Released under GNU License version 3.
*  http://www.polargraph.co.uk
*  https://github.com/euphy/polargraph

13th September 2015

This is the source code for the Polargraph software. 
It contains:

Controller v2.0
---------------

Binary (compiled) versions of the controller for

- 32 bit linux
- 64 bit linux
- Mac OSX (v1.2)
- 32 bit Windows
- 64 bit Windows

Along with source code for the controller in the processing-source 
folder.

It also includes the required Processing libraries (geomerative, Controlp5, 
Diewald CV kit) that the controller uses.  These are not necessarily
the most recent versions, but they are the versions that work.

Processing Libraries should be copied into the libraries subfolder in 
your Processing sketchbook folder.

This is written and compiled under Processing v2.2.1.  It has not been 
tested with the v3 beta.


Server v1.2 for regular Polargraph (UNO, MEGA) machines.
Server v1.2 for PolargraphSD machines.

The arduino-source folder has the code for the firmware that should 
be uploaded to your arduino.  There are currently two supported versions:

- polargraph_server_a1 for Arduino UNO- or MEGA-based machines, based on 
  Adafruit motorshields, or with serial stepper drivers (eg Easydriver, 
  stepstick etc) or signal amplifiers.

- polargraph_server_polarshield for Arduino MEGA 2560 running with 
  an attached Polarshield, serial stepper drivers and LCD touchscreen.

Each version is in it's own folder along with a precompiled .hex that
can be loaded directly using something like XLoader (some info about this
https://github.com/euphy/polargraph/wiki/Uploading-precompiled-binary-hex-files)

In the arduino-source folder there is also a libraries folder that
has all the arduino libraries that you will need to compile the 
firmware.

- AccelStepper
- AFMotor (for those using the Adafruit motor shield)
- UTFT (for the polarshield)
- UTouch (for the polarshield)

UTouch sometimes benefits from calibration, so if you find your 
touchscreen is not responding properly to your touch, you might 
need to do that.  The calibration figures that are in there already 
are ok for my ITDB02-2.4 screens.

The arduino libraries should be copied into your arduino sketch folder.