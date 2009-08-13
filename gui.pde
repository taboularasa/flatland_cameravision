class GUI
{
  int sheerVertex=0;
  float zdist = 26400;
  
  GUI(PApplet app)
  {

    controlP5 = new ControlP5(app);
    
    Slider s = controlP5.addSlider("SX",-50,50,0,100,500,100,10);
    s = controlP5.addSlider("SY",-50,50,0,100,512,100,10);
    s = controlP5.addSlider("SZX",-100,100,0,100,524,100,10);
    s = controlP5.addSlider("SZY",-100,100,0,100,536,100,10);
    s = controlP5.addSlider("DIST",10000,40000,26400,100,548,100,10);
    Radio sV = controlP5.addRadio("sheerVertex",20,500);
    sV.add("lock-all",0);
    sV.add("up-right",1);
    sV.add("low-left",2);
    sV.add("low-right",3);
    sV.add("up-left",4);
    Radio pC = controlP5.addRadio("radioColor",300,500);
    pC.deactivateAll();
    pC.add("red",0);
    pC.add("green",1);
    pC.add("blue",2);
    pC.add("yellow",3);
    pC.add("orange",4);
    pC.add("purple",5);
  }

  void SX(float x)
  {
    switch(sheerVertex) 
    {
      case(0):
      nUL.x = x;
      nUR.x = x;
      nLL.x = (-1*x);
      nLR.x = (-1*x);
      break;  
      case(1):
      nUR.x = x;
      break;  
      case(2):
      nLL.x = x;
      break;  
      case(3):
      nLR.x = x;
      break;
      case(4):
      nUL.x = x;
      break;    
    }
  }

  void SY(float y)
  {
    switch(sheerVertex) 
    {
      case(0):
      nUL.y = y;
      nLL.y = y;
      nUR.y = (-1*y);
      nLR.y = (-1*y);
      break;  
      case(1):
      nUR.y = y;
      break;  
      case(2):
      nLL.y = y;
      break;  
      case(3):
      nLR.y = y;
      break;
      case(4):
      nUL.y = y;
      break;    
    }
  }

  void SZX(float z)
  {
    switch(sheerVertex) 
    {
      case(0):
      nUL.z = z;
      nLL.z = z;
      nUR.z = (-1*z);
      nLR.z = (-1*z);
      break;  
      case(1):
      nUR.z = z;
      break;  
      case(2):
      nLL.z = z;
      break;  
      case(3):
      nLR.z = z;
      break;
      case(4):
      nUL.z = z; 
      break;    
    }
  }

  void SZY(float z)
  {
    switch(sheerVertex) 
    {
      case(0):
      nUL.z = z;
      nUR.z = z;
      nLL.z = (-1*z);
      nLR.z = (-1*z);
      break;  
      case(1):
      nUR.z = z;
      break;  
      case(2):
      nLL.z = z;
      break;  
      case(3):
      nLR.z = z;
      break;
      case(4):
      nUL.z = z; 
      break;    
    }
  }
  
  void DIST(float d)
  {
    zdist = d;
  }

}


