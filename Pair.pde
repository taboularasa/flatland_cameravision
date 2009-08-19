class Pair
{
  public float x, y;
  Pair(float _x, float _y)
  {
    x = _x;
    y = _y;
  }

  Pair scale(float f)
  { 
    return new Pair(x*f,y*f); 
  }

  float getMagnitude()
  { 
    return sqrt(x*x+y*y); 
  }
  Pair getNormal()
  { 
    try { 
      return new Pair(x/getMagnitude(),y/getMagnitude()); 
    }
    catch(Exception e) { 
      return new Pair(0,0); 
    }
  }
}
