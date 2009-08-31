import processing.core.*;
import codeanticode.gsvideo.*;
import codeanticode.glgraphics.*;



@SuppressWarnings("serial")
public class Flatland_cameravision extends PApplet
{

//stuff for networking
Messenger messenger;
//name your server here or use localhost if no server is available
//String SERVER = "127.0.0.1";
String SERVER = "localhost";
boolean USE_SERVER = true;




//stuff for vertex transform
int topMargin = 40;
int bottomMargin = 520;
int sheerVertex = 0;
PImage testImg;

Graphics graphics;
Gui gui;
Tracking tracking;

// Variable for GSVideo
GSCapture video;
GSMovieMaker mm;
boolean captureMode = true;


int fps =30;

//stuff for font
PFont font;


//stuff for tracking
boolean TRACKING_CORNERS = false;



public void setup() {
  size(640, 600,GLConstants.GLGRAPHICS);
  frameRate(fps);

  //stuff for font
  font = loadFont("font-12.vlw");
  textFont(font, 12);

  //stuff drawing video image to screen
  video = new GSCapture(this, 640, 480, 30);
  graphics = new Graphics(this, video);


  //stuff for networking
  messenger = new Messenger(this, SERVER, USE_SERVER);


  //stuff for video capture
  mm = new GSMovieMaker(this, width, height, "data/sesson.ogg", GSMovieMaker.THEORA, GSMovieMaker.HIGH, fps);


  //stuff for GUI
  gui = new Gui(this);

  //stuff for tracking
  tracking = new Tracking(this, messenger, TRACKING_CORNERS);
  
}

public void draw() {

  println(frameRate);

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
  gui.controlP5.draw();

  //make movie frames if in movie mode
  if(captureMode == true)
  {
    loadPixels();
    // Add window's pixels to movie
    mm.addFrame(pixels);
  }
  
  //send a message to the network
  //println(messenger.ready);
  //if(messenger.ready)
  //{
    messenger.sendMessage();
    messenger.resetMessage();
  //}
  
}



public void keyPressed()
{
  gui.keyPressed();
  tracking.keyPressed();
  if (key == ' ') {
    // Finish the movie if space bar is pressed
    mm.finish();
    // Quit running the sketch once the file is written
    exit();
  }
  if (key == 'v')
  {
    mm.start();
    captureMode = true;
  }
  if (key == 'c')
  {
    captureMode = true;
  }
  if(key == 'x')
  {
    captureMode = false;
  }
}

public void mousePressed()
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

void TRACKING(float r)
{
  tracking.threshold = (int)r;
}

}