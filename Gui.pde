class Gui
{

  Gui(PApplet app)
  {
    controlP5 = new ControlP5(app);
    Slider s = controlP5.addSlider("DIST",10000,70000,32800,10,500,400,10);
    s = controlP5.addSlider("ROLL",-5,5,0,10,512,400,10);
    s = controlP5.addSlider("SX",-10,10,0,10,524,400,10);
    s = controlP5.addSlider("SY",-10,10,0,10,536,400,10);
  }
}

