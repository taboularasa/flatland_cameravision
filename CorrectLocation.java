import processing.core.*;


@SuppressWarnings("serial")
public class CorrectLocation extends PApplet
{
  float SCALE = 1;
  PVector rectify(PVector _P, PVector _upperLeft, PVector _upperRight, PVector _lowerRight, PVector _lowerLeft)
  {
    //corners
    PVector upperLeft, upperRight, lowerRight, lowerLeft;

    //this is where I plug in the boundary locaitons
    upperLeft = _upperLeft;
    upperRight = _upperRight;
    lowerRight = _lowerRight;
    lowerLeft = _lowerLeft;

    Line AB = new Line(upperLeft,upperRight);
    Line BC = new Line(lowerRight,upperRight);
    Line CD = new Line(lowerRight,lowerLeft);
    Line DA = new Line(upperLeft,lowerLeft);


    PVector P = _P;


    //HORIZONTAL LINES (y)
    if(isParallel(AB, CD))
    { 
      AB.p1.x += 1;
    }
    if(isParallel(AB, CD))
    { 
      AB.p1.y += 1;
    }
    float y = (getAngle(AB, new Line(getIntersect(AB,CD),P))/getAngle(AB,CD));

    //VERTICAL LINES (x)
    if(isParallel(DA, BC))
    {  
      BC.p1.x += 1;  
    }
    if(isParallel(DA, BC))
    {  
      BC.p1.y += 1;  
    }
    float x = (getAngle(DA, new Line(getIntersect(DA,BC),P))/getAngle(DA,BC));

    return new PVector(x*800,y*480);
  }



  PVector plus(PVector p1, PVector p2)
  { 
    return new PVector(p1.x + p2.x, p1.y + p2.y); 
  }
  PVector minus(PVector p1, PVector p2)
  { 
    return new PVector(p1.x-p2.x, p1.y-p2.y); 
  }
  float distance(PVector a, PVector b)
  {  
    return sqrt(a.x*a.x + b.x*b.x); 
  }
  float distance(Line l, PVector p)
  {
    float A = l.getSlope();
    float B = l.getb();
    return (A*p.x + p.y + B)/sqrt(A*A + B*B);
  }
  float distance(PVector p, Line l)
  { 
    return distance(l,p); 
  }

  PVector midpoint(PVector a, PVector b)
  {  
    return new PVector((a.x+b.x)/2, (a.y+b.y)/2); 
  }
  PVector midpercent(PVector a, PVector b, float per)
  {  
    return new PVector((a.x+b.x)*per, (a.y+b.y)*per); 
  }
  Line midline(Line a, Line b)
  {  
    return new Line(midpoint(a.p1,b.p1),midpoint(a.p2,b.p2)); 
  }

  PVector getIntersect(Line l1, Line l2)
  {
    float mn = l1.getSlope()-l2.getSlope();
    return new PVector( (-l1.getb() + l2.getb())/mn, (l2.getb()*l1.getSlope() - l1.getb()*l2.getSlope())/mn );
  }

  boolean isParallel(Line m1, Line m2)
  { 
    return m1.getSlope() == m2.getSlope(); 
  }

  float getAngle(Line m1, Line m2)
  { 
    //float c = (new Line(m1.getVector(),m2.getVector())).getVector().getMagnitude();
    //float a = m1.getVector().getMagnitude();
    //float b = m2.getVector().getMagnitude();
    //return acos((a*a+b*b-c*c)/(2*a*b));
    Float ang = acos(m1.getUnitVector().x*m2.getUnitVector().x + m1.getUnitVector().y*m2.getUnitVector().y);
    if(ang.isNaN())
    { 
      return 0; 
    } 
    if(ang > PI/2)
    { 
      ang = PI - ang; 
    }
    return ang;
  }
  float getAngleLAME(Line m1, Line m2)
  {
    PVector isect = getIntersect(m1,m2);  
    Float a1;
    Float a2;
    a1 = atan2(m1.p1.y - isect.y, m1.p1.x-isect.x);
    println(a1);
    if( a1.isNaN() )
    { 
      a1 = atan2(m1.p2.y - isect.y, m1.p2.x-isect.x); 
    }
    println(a1);
    a2 = atan2(m2.p1.y - isect.y, m2.p1.x-isect.x); 
    println(a2);
    if( a2.isNaN() )
    { 
      a2 = atan2(m2.p2.y - isect.y, m2.p2.x-isect.x); 
    }
    println(a2);
    return a1-a2; 
  }
}


