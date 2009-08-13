class Tracking
{
  int numberOfPlayers = 1;
  int colorTarget;

  //stuff for finding boundary of colors
  int colorArea = 20;
  int[] boundaries = new int[4];
  int trackingThreshold = 20;
  int leftCheckLimit;
  int rightCheckLimit;
  int topCheckLimit;
  int bottomCheckLimit;

  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  float[] worldRecords = new float[numberOfPlayers];

  // A variable for the color we are searching for.
  color[] trackColor = new color[numberOfPlayers]; 

  // XY coordinate of closest color
  int[] closestX = new int[numberOfPlayers];
  int[] closestY = new int[numberOfPlayers];
  int[] correctedX = new int[numberOfPlayers];
  int[] correctedY = new int[numberOfPlayers];

  //this is so we don't track things until we want to
  boolean active = false;



  Tracking(PApplet app)
  {
    for(int i=0;i<numberOfPlayers;i++)
    {
      worldRecords[i]=500;
      trackColor[i] = color(255);
      closestX[i] = width/2;
      closestY[i] = height/2;
    } 
  }

  void update()
  {
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
      tracking.active = true;
      int loc = mouseX + mouseY*width;
      trackColor[colorTarget] = testImg.pixels[loc];

    }

  }

  void keyPressed()
  {
    println("hello!");
    active = true;
    colorTarget = int(key)-49;
  }
}









