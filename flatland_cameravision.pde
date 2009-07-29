// camera vision from:
// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com


import processing.video.*;

int numberOfPlayers = 2;
//keyboard stuff
int colorTarget;

// Variable for capture device
Capture video;

// A variable for the color we are searching for.
color[] trackColor = new color[numberOfPlayers]; 

// XY coordinate of closest color
int[] closestX = new int[numberOfPlayers];
int[] closestY = new int[numberOfPlayers];

// Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
float[] worldRecords = new float[numberOfPlayers];

void setup() {
  for(int i=0;i<numberOfPlayers;i++) worldRecords[i]=500;
  for(int i=0;i<numberOfPlayers;i++) trackColor[i] = color(255,0,0);
  size(320,240);
  video = new Capture(this,width,height,15);
  // Start off tracking for red
  smooth();
}

void draw() {
  
  // Capture and display the video
  if (video.available()) {
    video.read();
  }
  video.loadPixels();
  image(video,0,0);
  for(int i=0;i<numberOfPlayers;i++) worldRecords[i]=500;
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
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
          println(closestX[i]);
        }
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.

  for(int i=0;i<numberOfPlayers;i++)
  {
    if (worldRecords[i] < 10) 
    { 
      // Draw a circle at the tracked pixel
      fill(trackColor[i]);
      strokeWeight(1);
      stroke(0);
      ellipse(closestX[i],closestY[i],8,8);
    }
  }
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor[colorTarget] = video.pixels[loc];
}

void keyPressed()
{
  colorTarget = int(key)-49;
}





