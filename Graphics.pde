class Graphics
{
  PApplet parent;
  PVector uL, uR, lL, lR;
  PVector nUL, nUR, nLL, nLR;

  Graphics(PApplet app)
  {
    parent = app;

    //init vectors
    uL = new PVector(0,0,0);
    uR = new PVector(640,0,0);
    lR = new PVector(640,480,0);
    lL = new PVector(0,480,0);

    //update vectors
    nUL  = new PVector(0,0,0);
    nUR  = new PVector(0,0,0);
    nLR  = new PVector(0,0,0);
    nLL  = new PVector(0,0,0);

    //stuff for GLGraphics
    model = new GLModel(parent, numPoints, QUADS, GLModel.DYNAMIC);
    model.initColors();
    tex = new GLTexture(parent, "milan.jpg");
    cam = new GLCamera(parent, video.width/2, video.height/2, distance, video.width/2, video.height/2-59, 0);
    coords = new float[16];
    colors = new float[4 * numPoints];
    texcoords = new float[8];

    //corner 1
    coords[0] = uL.x;
    coords[1] = uL.y;
    coords[2] = uL.z;

    texcoords[0] = 0;
    texcoords[1] = 1;

    //corner 2
    coords[4] = uR.x;
    coords[5] = uR.y;
    coords[6] = uR.z;

    texcoords[2] = 1;
    texcoords[3] = 1;

    //corner 3
    coords[8] = lR.x;
    coords[9] = lR.y;
    coords[10] = lR.z;

    texcoords[4] = 1;
    texcoords[5] = 0;

    //corner 4
    coords[12] = lL.x;
    coords[13] = lL.y;
    coords[14] = lL.z;

    texcoords[6] = 0;
    texcoords[7] = 0;

    for (int i = 0; i < colors.length; i++) colors[i] = 1;

    model.updateVertices(coords);
    model.updateColors(colors);
    model.initTexures(1);
    model.setTexture(0, tex);
  }

  void update()
  {
    if (video.available()) {
      background(0);

      //update vectors
      uL.add(nUL);
      uR.add(nUR);
      lL.add(nLL);
      lR.add(nLR);

      //corner 1
      coords[0] = uL.x;
      coords[1] = uL.y;
      coords[2] = uL.z;
      //corner 2
      coords[4] = uR.x;
      coords[5] = uR.y;
      coords[6] = uR.z;
      //corner 3
      coords[8] = lR.x;
      coords[9] = lR.y;
      coords[10] = lR.z;
      //corner 4
      coords[12] = lL.x;
      coords[13] = lL.y;
      coords[14] = lL.z;

      video.read();
      tex.putPixelsIntoTexture(video);

      //reset update vectors
      nUL.set(0,0,0);
      nUR.set(0,0,0);
      nLR.set(0,0,0);
      nLL.set(0,0,0);
    }

    model.updateVertices(coords);
    model.updateTexCoords(0, texcoords);

    cam.jump(video.width/2,video.height/2,distance);
    cam.roll(camRoll);
    camRoll=0;
    cam.feed();
    cam.clear(0);
    model.render();
    cam.done();
  }

  void SX(float x)
  {
    nUL.x = x;
    nUR.x = x;
    nLL.x = x;
    nLR.x = x;
  }

  void SY(float y)
  {
    nUL.y = y;
    nLL.y = y;
    nUR.y = y;
    nLR.y = y;
  }

  void DIST(float d)
  {
    distance = d;
  }

  void ROLL(float r)
  {
    camRoll = radians(r);
  }
}





