class Player
{

  //this is the size of the bounding box for the player
  int playerSize = 10;

  //this is the size of the player bounding box for tracking
  int neighborhood = 480;


  //these are values of player bounding box
  int topEdge = 0;
  int leftEdge = 0;
  int rightEdge = 0;
  int bottomEdge = 0;

  //these are benchmarks for finding player bounding box
  //lower the value the closer the match
  //set extra high for initialization
  float topEdgeBenchmark=500;
  float leftEdgeBenchmark=500;
  float rightEdgeBenchmark=500;
  float bottomEdgeBenchmark=500;


  //this is for color match tolerance in finding the of the player
  int trackingThreshold = 20;

  //for holding locations
  PVector currentLoc;
  PVector lastLoc;

  //this is the color of the player 
  //stored in a PVector for checking distances from other colors
  PVector targetColor;

  //should I be tracked?
  boolean active = false;
  
  


  Player()
  {
    //init vectors
    currentLoc = new PVector(0, 0, 0); 
    lastLoc = new PVector(0, 0, 0);
    targetColor = new PVector(0, 0, 0);

  }

  void init(int x, int y, color c)
  {
    active = true;
    lastLoc.x = x;
    lastLoc.y = y;
    currentLoc.x = x;
    currentLoc.y = y;

    targetColor.x = red(c);
    targetColor.y = green(c);
    targetColor.z = blue(c);
  }

  void disable()
  {
    active = false;
  }
}



