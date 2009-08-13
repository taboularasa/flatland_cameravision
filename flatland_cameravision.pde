import processing.opengl.*;
import codeanticode.gsvideo.*;
import codeanticode.glgraphics.*;
import processing.net.*; 
import controlP5.*;

//stuff for GUI
ControlP5 controlP5;
int colorTarget;
GUI gui;

//stuff for vertex transform
int topMargin = 40;
int bottomMargin = 520;
int sheerVertex = 0;
PImage img, testImg;
PVector uL, uR, lL, lR;
PVector nUL, nUR, nLL, nLR;

//stuff for TCP
Client myClient;
String serverMessage = "";

//stuff for finding boundary of colors
int colorArea = 20;
int[] boundaries = new int[4];
int trackingThreshold = 20;
int leftCheckLimit;
int rightCheckLimit;
int topCheckLimit;
int bottomCheckLimit;


//this is so we don't track things until we want to
boolean active = false;

int numberOfPlayers = 1;



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

// A variable for the color we are searching for.
color[] trackColor = new color[numberOfPlayers]; 

// XY coordinate of closest color
int[] closestX = new int[numberOfPlayers];
int[] closestY = new int[numberOfPlayers];
int[] correctedX = new int[numberOfPlayers];
int[] correctedY = new int[numberOfPlayers];

// Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
float[] worldRecords = new float[numberOfPlayers];

void setup() {
  size(640, 600,GLConstants.GLGRAPHICS);
  frameRate(60);
  //init vectors
  uL = new PVector(0,0,0);
  uR = new PVector(640,0,0);
  lR = new PVector(640,480,0);
  lL = new PVector(0,480,0);

  //update vectors
  nUL  = new PVector(0,0,0);
  nUR  = new PVector(0,0,0);
  nLR  = new PVector(0,0,0);
  nLL  = new PVector(0,0,0);

  //stuff for video
  video = new GSCapture(this, 640, 480, 30);
  img = createImage(video.width, video.height, RGB);

  //stuff for GLGraphics
  model = new GLModel(this, numPoints, QUADS, GLModel.DYNAMIC);
  model.initColors();
  tex = new GLTexture(this, "milan.jpg");
  cam = new GLCamera(this, video.width/2, video.height/2, distance, video.width/2, video.height/2-59, 0);
  coords = new float[16];
  colors = new float[4 * numPoints];
  texcoords = new float[8];

  //corner 1
  coords[0] = uL.x;
  coords[1] = uL.y;
  coords[2] = uL.z;

  texcoords[0] = 0;
  texcoords[1] = 1;

  //corner 2
  coords[4] = uR.x;
  coords[5] = uR.y;
  coords[6] = uR.z;

  texcoords[2] = 1;
  texcoords[3] = 1;

  //corner 3
  coords[8] = lR.x;
  coords[9] = lR.y;
  coords[10] = lR.z;

  texcoords[4] = 1;
  texcoords[5] = 0;

  //corner 4
  coords[12] = lL.x;
  coords[13] = lL.y;
  coords[14] = lL.z;

  texcoords[6] = 0;
  texcoords[7] = 0;

  for (int i = 0; i < colors.length; i++) colors[i] = 1;

  model.updateVertices(coords);
  model.updateColors(colors);
  model.initTexures(1);
  model.setTexture(0, tex);



  //stuff for networking
  //myClient = new Client(this, "192.168.1.100", 51007);

  //stuff for GUI
  gui = new GUI(this);


  //stuff for color tracking
  for(int i=0;i<numberOfPlayers;i++)
  {
    worldRecords[i]=500;
    trackColor[i] = color(255);
    closestX[i] = width/2;
    closestY[i] = height/2;
  } 


}

void draw() {

  gui.sheerVertex = sheerVertex;
  println(frameRate);
  //reset server message
  //serverMessage = "";


  ///////////////////////////////
  // THIS IS WHERE WE CAPTURE AND CORRECT THE IMAGE
  ////////////////////////////////

  hint(ENABLE_DEPTH_TEST);
  GLGraphics renderer = (GLGraphics)g;
  if (video.available()) {
    background(0);

    //update vectors
    uL.add(nUL);
    uR.add(nUR);
    lL.add(nLL);
    lR.add(nLR);

    //corner 1
    coords[0] = uL.x;
    coords[1] = uL.y;
    coords[2] = uL.z;
    //corner 2
    coords[4] = uR.x;
    coords[5] = uR.y;
    coords[6] = uR.z;
    //corner 3
    coords[8] = lR.x;
    coords[9] = lR.y;
    coords[10] = lR.z;
    //corner 4
    coords[12] = lL.x;
    coords[13] = lL.y;
    coords[14] = lL.z;

    video.read();
    tex.putPixelsIntoTexture(video);

    //reset update vectors
    nUL.set(0,0,0);
    nUR.set(0,0,0);
    nLR.set(0,0,0);
    nLL.set(0,0,0);
  }

  model.updateVertices(coords);
  model.updateTexCoords(0, texcoords);

  cam.jump(video.width/2,video.height/2,distance);
  cam.roll(camRoll);
  camRoll=0;
  cam.feed();
  cam.clear(0);
  model.render();
  cam.done();
  renderer.endGL();
  hint(DISABLE_DEPTH_TEST);
  fill(0);
  rect(0,480, 640,180);

  testImg = get();
  //testImg.loadPixels();
  //background(255);
  //image(testImg,0,0);

  controlP5.draw();

  ////////////////////////////
  //THIS IS WHERE WE DO THE TRACKING
  ///////////////////////////


  for(int i=0;i<numberOfPlayers;i++) worldRecords[i]=500;
  if(active)
  {
    // Begin loop to walk through every pixel
    for (int x = 0; x < testImg.width; x ++ ) {
      for (int y = 0; y < testImg.height; y ++ ) {
        int loc = x + y*testImg.width;
        // What is current color
        color currentColor = testImg.pixels[loc];
        float r1 = red(currentColor);
        float g1 = green(currentColor);
        float b1 = blue(currentColor);
        for(int i=0;i<numberOfPlayers;i++)
        {
          float r2 = red(trackColor[i]);
          float g2 = green(trackColor[i]);
          float b2 = blue(trackColor[i]);

          // Using euclidean distance to compare colors
          float d = dist(r1,g1,b1,r2,g2,b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

          // If current color is more similar to tracked color than
          // closest color, save current location and current difference
          if (d < worldRecords[i]) 
          {
            worldRecords[i] = d;
            closestX[i] = x;
            closestY[i] = y;
          }
        }
      }
    }

    //for each player, loop through the areas around the winning pixel to find the center of the area
    for(int i=0;i<numberOfPlayers;i++)
    {
      //int loc = x + y*testImg.width;
      int loc = closestX[i] + closestY[i]*testImg.width;
      color winningColor = testImg.pixels[loc];
      float r1 = red(winningColor);
      float g1 = green(winningColor);
      float b1 = blue(winningColor);

      //make sure you don't go out of  left bounds
      if (closestX[i]-colorArea < 0) leftCheckLimit = 0;
      else leftCheckLimit = closestX[i]-colorArea;

      //scan from center to left edge
      for(int x = closestX[i]; x > leftCheckLimit; x--)
      {
        loc = x + closestY[i]*testImg.width;
        color testColor = testImg.pixels[loc];
        float r2 = red(testColor);
        float g2 = green(testColor);
        float b2 = blue(testColor);
        float d = dist(r1,g1,b1,r2,g2,b2);
        if(d > trackingThreshold)
        {
          boundaries[0] = x+1;
          break;
        }
      }

      //make sure you don't go out of right bounds
      if (closestX[i]+colorArea > width) rightCheckLimit = width;
      else rightCheckLimit = closestX[i]+colorArea;

      //scan from center to right edge
      for(int x = closestX[i]; x < rightCheckLimit; x++)
      {
        color testColor = testImg.pixels[x + closestY[i]*testImg.width];
        float r2 = red(testColor);
        float g2 = green(testColor);
        float b2 = blue(testColor);
        float d = dist(r1,g1,b1,r2,g2,b2);
        if(d > trackingThreshold)
        {
          boundaries[1] = x-1;
          break;
        }
      }

      //make sure you don't go out of top bounds
      if (closestY[i]-colorArea < 0) topCheckLimit = 0;
      else topCheckLimit = closestY[i]-colorArea;

      //scan from center to top edge
      for(int y = closestY[i]; y > topCheckLimit; y--)
      {
        color testColor = testImg.pixels[closestX[i] + y * testImg.width];
        float r2 = red(testColor);
        float g2 = green(testColor);
        float b2 = blue(testColor);
        float d = dist(r1,g1,b1,r2,g2,b2);
        if(d > trackingThreshold)
        {
          boundaries[2] = y+1;
          break;
        }
      }

      //make sure you don't go out of  bottom bounds
      if (closestY[i]+colorArea > height) bottomCheckLimit = height;
      else bottomCheckLimit = closestY[i]+colorArea;

      //scan from center to bottom edge
      for(int y = closestY[i]; y < bottomCheckLimit; y++)
      {
        color testColor = testImg.pixels[closestX[i] + y * testImg.width];
        float r2 = red(testColor);
        float g2 = green(testColor);
        float b2 = blue(testColor);
        float d = dist(r1,g1,b1,r2,g2,b2);
        if(d > trackingThreshold)
        {
          boundaries[3] = y-1;
          break;
        }
      }


      //the new horizontal center is the difference between the right and left edge divided by 2
      correctedX[i] = boundaries[0]+((boundaries[1]-boundaries[0])/2);

      //same for vertical center but with top and bottom edge
      correctedY[i] = boundaries[2]+((boundaries[3]-boundaries[2])/2);
    }




    for(int i=0;i<numberOfPlayers;i++)
    {
      fill(255,0,0);
      strokeWeight(1);
      stroke(0);
      ellipse(closestX[i],closestY[i],8,8);
      fill(0,255,0);
      ellipse(correctedX[i],correctedY[i],8,8);
    }
  }


}

void mousePressed() 
{
  // Save color where the mouse is clicked in trackColor variable
  if(mouseX > 0 && mouseX < 640 && mouseY > 0 && mouseY < 480)
  {
    active = true;
    int loc = mouseX + mouseY*img.width;
    trackColor[colorTarget] = testImg.pixels[loc];

  }

}

void keyPressed()
{
  active = true;
  colorTarget = int(key)-49;
  controlP5.controller("radioColor").setValue(colorTarget);

}




void SX(float x)
{
  gui.SX(x);
}

void SY(float y)
{
  gui.SY(y);
}

void DIST(float d)
{
  distance = d;
}

void ROLL(float r)
{
  camRoll = radians(r);
}












