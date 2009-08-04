import processing.opengl.*;
import codeanticode.gsvideo.*;
import processing.net.*; 
import controlP5.*;

//stuff for GUI
ControlP5 controlP5;
int colorTarget;

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



// Variable for capture device
GSCapture video;

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
  size(640, 640,OPENGL);

  //init vectors
  uL = new PVector(0,40,0);
  uR = new PVector(640,40,0);
  lR = new PVector(640,520,0);
  lL = new PVector(0,520,0);

  //update vectors
  nUL  = new PVector(0,0,0);
  nUR  = new PVector(0,0,0);
  nLR  = new PVector(0,0,0);
  nLL  = new PVector(0,0,0);

  //stuff for video
  video = new GSCapture(this, 640, 480, 30);
  img = createImage(video.width, video.height, RGB);
  // testImg = createImage(video.width, video.height, RGB);


  //stuff for networking
  //myClient = new Client(this, "192.168.1.100", 51007);

  //stuff for GUI
  controlP5 = new ControlP5(this);
  Slider s = controlP5.addSlider("SX",-50,50,0,100,562,100,10);
  s = controlP5.addSlider("SY",-50,50,0,100,550,100,10);
  s = controlP5.addSlider("SZX",-50,50,0,100,574,100,10);
  s = controlP5.addSlider("SZY",-50,50,0,100,586,100,10);
  Radio sV = controlP5.addRadio("sheerVertex",20,550);
  sV.add("lock-all",0);
  sV.add("up-right",1);
  sV.add("low-left",2);
  sV.add("low-right",3);
  sV.add("up-left",4);
  Radio pC = controlP5.addRadio("colorTarget",20,550);
  pC.add("red",0);
  pC.add("green",1);
  pC.add("blue",2);
  pC.add("yellow",3);
  pC.add("orange",4);
  pC.add("purple",5);
  controlP5.controller("colorTarget").moveTo("tracking");

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

  //reset server message
  serverMessage = "";

  ///////////////////////////////
  // THIS IS WHERE WE CAPTURE AND CORRECT THE IMAGE
  ////////////////////////////////

  hint(ENABLE_DEPTH_TEST);
  if (video.available()) {
    background(0);
    video.read();
    video.loadPixels();
    img = video.get();
    img.updatePixels();

    //update vectors
    uL.add(nUL);
    uR.add(nUR);
    lL.add(nLL);
    lR.add(nLR);

    beginShape();
    texture(img);
    textureMode(NORMALIZED);
    vertex(uL.x, uL.y, uL.z, 0, 0);
    vertex(uR.x, uR.y, uR.z, 1, 0);
    vertex(lR.x, lR.y, lR.z, 1, 1);
    vertex(lL.x, lL.y, lL.z, 0, 1);
    endShape();

    //reset update vectors
    nUL.set(0,0,0);
    nUR.set(0,0,0);
    nLR.set(0,0,0);
    nLL.set(0,0,0);
  }
  hint(DISABLE_DEPTH_TEST);

  fill(0);
  rect(0,0,640,40);
  rect(0,520, 640,140);
  
  testImg = get();
  //testImg.loadPixels();
  background(255);
  image(testImg,0,0);
  
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
  if(mouseX > 0 && mouseX < 640 && mouseY > 40 && mouseY < 520)
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
  println(colorTarget);
}




void SX(float x)
{
  switch(sheerVertex) 
  {
    case(0):
    nUL.x = x;
    nUR.x = x;
    nLL.x = (-1*x);
    nLR.x = (-1*x);
    break;  
    case(1):
    nUR.x = x;
    break;  
    case(2):
    nLL.x = x;
    break;  
    case(3):
    nLR.x = x;
    break;
    case(4):
    nUL.x = x;
    break;    
  }
}

void SY(float y)
{
  switch(sheerVertex) 
  {
    case(0):
    nUL.y = y;
    nLL.y = y;
    nUR.y = (-1*y);
    nLR.y = (-1*y);
    break;  
    case(1):
    nUR.y = y;
    break;  
    case(2):
    nLL.y = y;
    break;  
    case(3):
    nLR.y = y;
    break;
    case(4):
    nUL.y = y;
    break;    
  }
}

void SZX(float z)
{
  switch(sheerVertex) 
  {
    case(0):
    nUL.z = z;
    nLL.z = z;
    nUR.z = (-1*z);
    nLR.z = (-1*z);
    break;  
    case(1):
    nUR.z = z;
    break;  
    case(2):
    nLL.z = z;
    break;  
    case(3):
    nLR.z = z;
    break;
    case(4):
    nUL.z = z; 
    break;    
  }
}

void SZY(float z)
{
  switch(sheerVertex) 
  {
    case(0):
    nUL.z = z;
    nUR.z = z;
    nLL.z = (-1*z);
    nLR.z = (-1*z);
    break;  
    case(1):
    nUR.z = z;
    break;  
    case(2):
    nLL.z = z;
    break;  
    case(3):
    nLR.z = z;
    break;
    case(4):
    nUL.z = z; 
    break;    
  }
}















