class Tracking
{
  //do we really need to keep track of how many players? or can we just do that automatically by changing the size of the player array?
  int numberOfPlayers = 1;

  //this is which players color to set
  int setPlayerNumber;

  PVector testColor;

  //this holds a list of player objects
  ArrayList players;

  //the sketch
  PApplet parent;


  Tracking(PApplet app)
  {
    parent = app;
    players = new ArrayList();  // Create an empty ArrayList
    testColor = new PVector(0,0,0); //Create PVector for testing color distance
  }

  void update(PImage testImg)
  {
    if(players.length>0)
    {

      ////////////////////////////////////////
      // Loop through each active players neighborhood
      // find the edges from the last known x,y of the player 
      // find the middle point of the edges
      // draw the new location
      ////////////////////////////////////////
      for(int i=0;i<players.length;i++)
      {
        if(player.active)
        {
          Player player = (Player) players.get(i);
          
          //draw the last known location
          fill(255,0,0);
          ellipse(player.lastLoc.x, player.lastLoc.y, 10, 10);

          //reset the benchmarks player bounding box
          player.topEdgeBenchmark=500;
          player.leftEdgeBenchmark=500;
          player.rightEdgeBenchmark=500;
          player.bottomEdgeBenchmark=500;

          //reset the bounding box for the player
          player.boundaries.clear();

          //take the last known location and find the left and top edge of player bounding box
          for(int j = (player.neighborhood/2); j > 0; j--)
          {
            //testing for top edge
            color topEdgeColor = testImg.get(player.lastLoc.x, player.lastLoc.y-j);

            //get the distance between the current color and the players target color
            float d = colorDistance(topEdgeColor,player.trackColor);
            if(d < player.topEdgeBenchmark)
            {
              player.topEdgeBenchmark = d;
              player.boundaries.put("top", player.lastLoc.y-j);
            }

            //testing for left edge
            color leftEdgeColor = testImg.get(player.lastLoc.x-j, player.lastLoc.y);

            //get the distance between the current color and the players target color
            d = colorDistance(leftEdgeColor,player.trackColor);
            if(d < player.topEdgeBenchmark)
            {
              player.topEdgeBenchmark = d;
              player.boundaries.put("left", player.lastLoc.x-j);
            }
          }

          //now that we have the top and left edge
          //lets get the right and bottom edge
          for(int j = 0; j < player.neighborhood; j++)
          {
            //testing for right edge
            color rightEdgeColor = testImg.get(player.boundaries.get("left")+j, player.boundaries.get("top"));       
            //get the distance between the current color and the players target color
            float d = colorDistance(rightEdgeColor,player.trackColor);
            if(d < player.rightEdgeBenchmark)
            {
              player.rightEdgeBenchmark = d;
              player.boundaries.put("right", player.boundaries.get("left")+j);
            }

            //testing for bottom edge
            color bottomEdgeColor = testImg.get(player.boundaries.get("left"), player.boundaries.get("top")+j);
            //get the distance between the current color and the players target color
            d = colorDistance(bottomEdgeColor,player.trackColor);
            if(d < player.bottomEdgeBenchmark)
            {
              player.bottomEdgeBenchmark = d;
              player.boundaries.put("bottom", player.boundaries.get("top")+j);
            }
          }

          //now that we have the bounding box
          //assign the new players x,y to the center of the bounding box
          player.currentLoc.x = (player.boundaries.get("right") - player.boundaries.get("left"))/2;
          player.currentLoc.y = (player.boundaries.get("bottom") - player.boundaries.get("top"))/2;

          //this is not really nesicary at the moment but may need it later
          player.lastLoc.x = player.currentLoc.x;
          player.lastLoc.y = player.currentLoc.y;

          //draw the new location
          fill(0,255,0);
          ellipse(player.currentLoc.x, player.currentLoc.y, 10, 10);

        }
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
    setPlayerNumber = int(key)-49;
  }
}


float colorDistance(color tC, PVector pC)
{
  //load the current color into the testColor vector
  tC.x = red(topEdgeColor);
  tC.y = green(topEdgeColor);
  tC.z = blue(topEdgeColor);
  return = PVector.dist(tC, pC);
}
















