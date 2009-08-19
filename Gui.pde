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


    selectLabel = controlP5.addTextarea("label1", "no selection", 350,490,300,20);
    myTextarea = controlP5.addTextarea(
      "label2", 
      "COMMANDS:\n"+
      "0-9 are for selecting players\n"+
      "'A','S','D' and 'F' are for selecting markers\n"+
      "'K' will reset all players\n"+
      "'V' starts recording\n"+
      "'X' pauses recording\n"+
      "'C' resumes recording\n"+
      "space bar ends recording and quits applicaiton\n", 350,510,300,300);
    myTextarea.setColorForeground(0xffff0000);

  }

  void keyPressed()
  {
    //team one players
    if(key == '0')
    {
      selectLabel.setText("team one : player one");
    }
    if(key == '1')
    {
      selectLabel.setText("team one : player two");
    }
    if(key == '2')
    {
      selectLabel.setText("team one : player three");
    }
    if(key == '3')
    {
      selectLabel.setText("team one : player four");
    }
    if(key == '4')
    {
      selectLabel.setText("team one : player five");
    }
    
    //team two players
    if(key == '5')
    {
      selectLabel.setText("team two : player one");
    }
    if(key == '6')
    {
      selectLabel.setText("team two : player two");
    }
    if(key == '7')
    {
      selectLabel.setText("team two : player three");
    }
    if(key == '8')
    {
      selectLabel.setText("team two : player four");
    }
    if(key == '9')
    {
      selectLabel.setText("team two : player five");
    }
    
    
    //these are keys for setting markers
    if(key == 'a')
    {
      selectLabel.setText("marker : upper left");
    }
    if(key == 's')
    {
      selectLabel.setText("marker : upper right");
    }
    if(key == 'd')
    {
      selectLabel.setText("marker : lower right");
    }
    if(key == 'f')
    {
      selectLabel.setText("marker : lower left");
    }

    //this are keys for video capture
    if(key == 'v')
    {
      selectLabel.setText("recording started");
    }
    if(key == 'c')
    {
      selectLabel.setText("recording resumed");
    }
    if(key == 'x')
    {
      selectLabel.setText("recording paused");
    }
  }



}

















