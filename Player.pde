class Player
{

  //this is the size of the player bounding box for tracking
  int neighborhood = 60;

  //this is an array for storing edges of player bounding box
  HashMap boundaries = new HashMap();

  //this is the size of the bounding box for the player
  int playerSize = 10;

  //these are benchmarks for finding player bounding box
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
  PVector trackColor;

  //should I be tracked?
  boolean active = false;


  Player()
  {
    boundaries.put("top",0);
    boundaries.put("right",0);
    boundaries.put("bottom",0);
    boundaries.put("left",0);
  }

  void update()
  {

  }

  void distroy()
  {

  }
}


