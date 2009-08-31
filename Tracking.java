import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;


@SuppressWarnings("serial")
public class Tracking extends PApplet
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
  ArrayList<Player> players;

  //this holds the four markers that will also be made from player objects
  ArrayList<Player> markers;

  //this is to wait for all the markers to be set
  //before we start using them to correct locations
  boolean markersSet = false; 

  //this is to disable corner tracking
  boolean trackingCorners = true;

  //the sketch
  PApplet parent;

  //current frame of video
  PImage testImg;

  //make sure that the boundries are somewhere near the value of the actual color
  int threshold = 20;

  //correct the locations based on the boundary markers
  CorrectLocation correctLocation = new CorrectLocation();

  //Stuff for networking
  Messenger messenger;

  Tracking(PApplet app, Messenger msg, boolean _trackingCorners)
  {
    parent = app;
    messenger = msg;
    trackingCorners = _trackingCorners;

    //init the players list
    players = new ArrayList<Player>();  
    for (int i = 0; i < numberOfPlayers ; i++)
    {
      players.add(new Player());
    }

    markers = new ArrayList<Player>();  
    for (int i = 0; i < numberOfMarkers ; i++)
    {
      Player player = new Player();
      player.isMarker = true;
      players.add(player);
      markers.add(player);
    }


    testColor = new PVector(0,0,0); //Create PVector for testing color distance
  }

  void update(PImage t)
  {
    //take the passed in image and store it
    testImg = t;

    ////////////////////////////////////////
    // This section is to set tracking for player markers
    // Loop through each active player's neighborhood
    // and find the closest pixel to the players color
    // average the new location with the last location to smooth out the 
    // motion
    ////////////////////////////////////////
    for(int i=0;i<players.size();i++)
    {
      Player player = (Player) players.get(i);

      if(player.active)
      {

        //reset the benchmarks player bounding box
        player.mainPixelBenchmark = 500;


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
            int mainPixelColor = testImg.get(x,y);
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

        for(int j = 0; j < player.playerSize; j++)
        {
          ///find the left edge
          int leftEdgeColor = testImg.get((int)player.tmpLoc.x-j, (int)player.tmpLoc.y);
          float d = colorDistance(leftEdgeColor, player.currentColor);
          if (d < threshold)
          {
            player.leftEdge = (int)player.tmpLoc.x-j;
          }


          ///find the top edge
          int topEdgeColor = testImg.get((int)player.tmpLoc.x, (int)player.tmpLoc.y-j);
          d = colorDistance(topEdgeColor, player.currentColor);
          if (d < threshold)
          {
            player.topEdge = (int)player.tmpLoc.y-j;
          }

          ///find the right edge
          int rightEdgeColor = testImg.get((int)player.tmpLoc.x+j, (int)player.tmpLoc.y);
          d = colorDistance(rightEdgeColor, player.currentColor);
          if (d < threshold)
          {
            player.rightEdge = (int)player.tmpLoc.x+j;
          }


          ///find the bottom edge
          int bottomEdgeColor = testImg.get((int)player.tmpLoc.x, (int)player.tmpLoc.y+j);
          d = colorDistance(bottomEdgeColor, player.currentColor);
          if (d < threshold)
          {
            player.bottomEdge = (int)player.tmpLoc.y+j;
          }
        }

        if(player.isMarker && !trackingCorners)
        {
          player.currentLoc = player.lastLoc;
        }
        else
        {
          player.currentLoc.x = player.leftEdge + ((player.rightEdge-player.leftEdge)/2);
          player.currentLoc.y = player.topEdge + ((player.bottomEdge-player.topEdge)/2);
          stroke(0,0,255);
          strokeWeight(1);
          noFill();
          rect(player.leftEdge,player.topEdge,player.rightEdge-player.leftEdge,player.bottomEdge-player.topEdge);
        }

        //player.currentLoc = player.tmpLoc;
        //player.currentLoc = PVector.div(PVector.add(player.tmpLoc, player.lastLoc), 2);

        //draw a line from the new location to last location
        stroke(255,0,0);
        strokeCap(ROUND);
        strokeWeight(5);
        line(player.currentLoc.x, player.currentLoc.y, player.lastLoc.x, player.lastLoc.y);

        //draw the new location
        noStroke();
        if(player.isMarker) fill(0,0,255);
        else fill(0,255,0); 
        ellipse(player.currentLoc.x, player.currentLoc.y, 5, 5);
        //keep store the location for the next loop
        player.lastLoc = player.currentLoc;
      }
    }

    /////////////////////////////////
    // This section takes the position of all the markers
    // uses them to correct the position of all the players
    // then sends the corrected positions out to the network
    //////////////////////////////////

    // first test all the markers to make sure that we have them all set
    // before we send them to the rectify function
    for(int i = 0; i < numberOfMarkers; i++)
    {
      Player marker = (Player) markers.get(i);
      if(!marker.active) markersSet = false;
      else markersSet = true;
    }
    //println(markersSet);

    // if all the markers are set then 
    // loop through each players location 
    // and send that players location + markers location
    // to the rectify function
    if(markersSet)
    {
      Player uL = (Player) markers.get(0);
      Player uR = (Player) markers.get(1);
      Player lR = (Player) markers.get(2);
      Player lL = (Player) markers.get(3);
      for(int i=0;i<players.size();i++)
      {
        Player player = (Player) players.get(i);
        if(player.active && !player.isMarker)
        {
          //this would be a good place to correct players location based on the movement of the filed markers

          //use the field markers to rectify the position of eadch player
          player.rectifiedLoc = correctLocation.rectify(player.currentLoc,uL.currentLoc,uR.currentLoc,lR.currentLoc,lL.currentLoc);

          //draw the corrected location
          fill(255,0,0);
          ellipse(player.rectifiedLoc.x, player.rectifiedLoc.y, 5, 5);
          //add their rectified position to the messengers message
          String msg = messenger.PEGMessage("player"+i, (int)player.rectifiedLoc.x, (int)player.rectifiedLoc.y);
          messenger.addMessage(msg);
        }
        messenger.ready = true;
        //println(messenger.ready);
      }
    }
  }



public void mousePressed() 
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

  public void keyPressed()
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
    else if( key - 48 >= 0 && key-48 <= numberOfPlayers)
    {
      settingMarkers = false;
      whatPlayer = key-48;
      println(whatPlayer);
    }
  }


  float colorDistance(int tC, PVector pC)
  {
    //load the current color into the testColor vector
    testColor.x = red(tC);
    testColor.y = green(tC);
    testColor.z = blue(tC);
    return PVector.dist(testColor, pC);
  }

  float colorDistance(int tC, int mC)
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

