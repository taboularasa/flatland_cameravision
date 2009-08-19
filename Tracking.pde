class Tracking
{
  int numberOfPlayers = 10;

  int numberOfMarkers = 4;

  //this is which players color to set
  int whatPlayer;
  //thisi s which markers color to set
  int whatMarker;
  //this is to capture mouse pressed when setting markers instead of players
  boolean settingMarkers = false;

  PVector testColor;

  //this holds a list of player objects
  ArrayList players;

  //this holds the four markers that will also be made from player objects
  ArrayList markers;

  //the sketch
  PApplet parent;

  //current frame of video
  PImage testImg;

  //make sure that the boundries are somewhere near the value of the actual color
  int threshold = 20;



  Tracking(PApplet app)
  {
    parent = app;

    //init the players list
    players = new ArrayList();  
    for (int i = 0; i < numberOfPlayers ; i++) players.add(new Player());

    markers = new ArrayList();  
    for (int i = 0; i < numberOfMarkers ; i++) markers.add(new Player());


    testColor = new PVector(0,0,0); //Create PVector for testing color distance
  }

  void update(PImage t)
  {
    testImg = t;
    ////////////////////////////////////////
    // Loop through each active player's neighborhood
    // find the edges from the last known x,y of the player 
    // find the middle point of the edges
    // draw the new location
    ////////////////////////////////////////
    for(int i=0;i<players.size();i++)
    {
      Player player = (Player) players.get(i);

      if(player.active)
      {

        //reset the benchmarks player bounding box
        player.mainPixelBenchmark = 500;
        player.topEdgeBenchmark=500;
        player.leftEdgeBenchmark=500;
        player.rightEdgeBenchmark=500;
        player.bottomEdgeBenchmark=500;

        //reset the bounding box for the player
        player.leftEdge = 0;
        player.rightEdge = 0;
        player.topEdge = 0;
        player.bottomEdge = 0;


        int startX = (int)player.lastLoc.x - (player.neighborhood/2);
        int startY = (int)player.lastLoc.y - (player.neighborhood/2);

        for(int x = startX; x < startX + player.neighborhood; x++)
        {
          for(int y = startY; y < startY + player.neighborhood; y++)
          {
            color mainPixelColor = testImg.get(x,y);
            float d = colorDistance(mainPixelColor,player.targetColor);
            if(d < threshold && d < player.mainPixelBenchmark)
            {
              player.mainPixelBenchmark = d;
              player.tmpLoc.x = x;
              player.tmpLoc.y = y;
              player.currentColor = mainPixelColor;
            }
          }
        }

        //player.currentLoc = player.tmpLoc;
        player.currentLoc = PVector.div(PVector.add(player.tmpLoc, player.lastLoc), 2);

        //draw a line from the new location to last location
        stroke(255,0,0);
        strokeCap(ROUND);
        strokeWeight(5);
        line(player.currentLoc.x, player.currentLoc.y, player.lastLoc.x, player.lastLoc.y);

        //draw the last known location
        noStroke();
        fill(0,255,0);
        ellipse(player.currentLoc.x, player.currentLoc.y, 5, 5);

        //keep store the location for the next loop
        player.lastLoc = player.currentLoc;

      }
    }
  }

  void mousePressed() 
  {
    // Save color where the mouse is clicked in trackColor variable
    if(mouseX > 0 && mouseX < 640 && mouseY > 0 && mouseY < 480)
    {
      if(settingMarkers)
      {
        Player marker = (Player)markers.get(whatMarker);
        marker.init(mouseX,mouseY,testImg.get(mouseX,mouseY));
      }
      else
      {
        Player player = (Player)players.get(whatPlayer);
        player.init(mouseX,mouseY,testImg.get(mouseX,mouseY));
      }
    }

  }

  void keyPressed()
  {
    if(key == 'k')
    {
      for (int i = 0; i < numberOfPlayers ; i++)
      {
        Player player = (Player) players.get(i);
        player.disable();
      } 
    }
    else if(key == 'v' || key == 'c' || key == 'x')
    {
      return;
    }
    else if(key == 'a' || key == 's' || key == 'd' || key == 'f')
    {
      settingMarkers = true;
      if (key == 'a') whatMarker = 0;
      else if (key == 's') whatMarker = 1;
      else if (key == 'd') whatMarker = 2;
      else if (key == 'f') whatMarker = 3;
      println(whatMarker);
    }
    else if( int(key) - 48 >= 0 && int(key)-48 <= numberOfPlayers)
    {
      settingMarkers = false;
      whatPlayer = int(key)-48;
      println(whatPlayer);
    }
  }


  float colorDistance(color tC, PVector pC)
  {
    //load the current color into the testColor vector
    testColor.x = red(tC);
    testColor.y = green(tC);
    testColor.z = blue(tC);
    return PVector.dist(testColor, pC);
  }

  float colorDistance(color tC, color mC)
  {
    float r1 = red(mC);
    float g1 = green(mC);
    float b1 = blue(mC);

    float r2 = red(tC);
    float g2 = green(tC);
    float b2 = blue(tC);

    return dist(r1,g1,b1,r2,g2,b2);
  }
}







































