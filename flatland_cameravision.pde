import processing.opengl.*;
import codeanticode.gsvideo.*;
import codeanticode.glgraphics.*;
import processing.net.*; 
import controlP5.*;

//stuff for GUI
ControlP5 controlP5;
int colorTarget;


//stuff for vertex transform
int topMargin = 40;
int bottomMargin = 520;
int sheerVertex = 0;
PImage testImg;


//stuff for TCP
Client myClient;
String serverMessage = "";


Graphics graphics;
Gui gui;
Tracking tracking;

// Variable for GSVideo
GSCapture video;

//stuff for GLGraphics
GLCamera cam;
GLModel model;
GLTexture tex;
float[] coords;
float[] colors;
float[] texcoords;
int numPoints = 4;
float distance = 32800;
float camRoll = 0;


void setup() {
  size(640, 600,GLConstants.GLGRAPHICS);
  frameRate(5);

  //stuff drawing video image to screen
  video = new GSCapture(this, 640, 480, 30);
  graphics = new Graphics(this);
  
  //stuff for GUI
  gui = new Gui(this);
  
  //stuff for tracking
  tracking = new Tracking(this);

  //stuff for networking
  //myClient = new Client(this, "192.168.1.100", 51007);
}

void draw() {

  //println(frameRate);
  
  //draw the video to the screen
  hint(ENABLE_DEPTH_TEST);
  GLGraphics renderer = (GLGraphics)g;
  graphics.update();
  renderer.endGL();
  hint(DISABLE_DEPTH_TEST);

  //mask the bootom edge
  fill(0);
  rect(0,480, 640,180);

  //make an image of whats on the screen
  testImg = get();
  testImg.loadPixels();
  //send it to the tracking object
  tracking.update(testImg);
  
  //draw the GUI
  controlP5.draw();



}



void keyPressed()
{
  tracking.keyPressed();
}

void mousePressed()
{
  tracking.mousePressed();
}




void SX(float x)
{
  graphics.SX(x);
}

void SY(float y)
{
  graphics.SY(y);
}

void DIST(float d)
{
  graphics.DIST(d);
}

void ROLL(float r)
{
  graphics.ROLL(r);
}
















