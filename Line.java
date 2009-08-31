import processing.core.*;

@SuppressWarnings("serial")
public class Line extends PApplet
{

  float SCALE = 1;
  PVector p1, p2;
  Line(PVector _p1, PVector _p2)
  {
    p1 = _p1;
    p2 = _p2;
  }


  float getSlope()
  {
    try
    { 
      return (p1.y - p2.y)/(p1.x - p2.x); 
    }
    catch(Exception e)
    { 
      return (float) 999999999.0; 
    }
  }

  float getb()
  { 
    return p1.y - this.getSlope()*p1.x;  
  }

  PVector getUnitVector()
  { 
    PVector uV = new PVector(p2.x-p1.x,p2.y-p1.y);
    uV.normalize();
    return uV;
  }
  PVector getVector()
  { 
    return new PVector(p2.x-p1.x,p2.y-p1.y); 
  }
}

