class Gui
{
  color myColorBackground;
  Radio team1control;
  Radio team2control;
  Radio markersControl;

  Gui(PApplet app)
  {
    controlP5 = new ControlP5(app);
    Slider s = controlP5.addSlider("DIST",10000,70000,32800,10,500,300,10);
    s = controlP5.addSlider("ROLL",-5,5,0,10,512,300,10);
    s = controlP5.addSlider("SX",-10,10,0,10,524,300,10);
    s = controlP5.addSlider("SY",-10,10,0,10,536,300,10);


    myTextarea = controlP5.addTextarea("label1", "no selection", 350,490,300,20);
    myTextarea.setColorForeground(0xffff0000);

  }

  void keyPressed()
  {
    //team one players
    if(key == '0')
    {
      myTextarea.setText("team one : player one");
    }
    if(key == '1')
    {
      myTextarea.setText("team one : player two");
    }
    if(key == '2')
    {
      myTextarea.setText("team one : player three");
    }
    if(key == '3')
    {
      myTextarea.setText("team one : player four");
    }
    if(key == '4')
    {
      myTextarea.setText("team one : player five");
    }
    
    //team two players
    if(key == '5')
    {
      myTextarea.setText("team two : player one");
    }
    if(key == '6')
    {
      myTextarea.setText("team two : player two");
    }
    if(key == '7')
    {
      myTextarea.setText("team two : player three");
    }
    if(key == '8')
    {
      myTextarea.setText("team two : player four");
    }
    if(key == '9')
    {
      myTextarea.setText("team two : player five");
    }
    
    
    //these are keys for setting markers
    if(key == 'a')
    {
      myTextarea.setText("marker : upper left");
    }
    if(key == 's')
    {
      myTextarea.setText("marker : upper right");
    }
    if(key == 'd')
    {
      myTextarea.setText("marker : lower right");
    }
    if(key == 'f')
    {
      myTextarea.setText("marker : lower left");
    }

    //this are keys for video capture
    if(key == 'v')
    {
      myTextarea.setText("recording started");
    }
    if(key == 'c')
    {
      myTextarea.setText("recording resumed");
    }
    if(key == 'x')
    {
      myTextarea.setText("recording paused");
    }
  }



}

















