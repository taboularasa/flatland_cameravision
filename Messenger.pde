class Messenger
{
  PApplet parent;
  //stuff for TCP
  Client myClient;
  String serverMessage = "";
  boolean ready = false;

  boolean networkingEnabled = false;

  Messenger(PApplet app, String server)
  {
    parent = app;
    if(networkingEnabled)
    {
      //stuff for networking
      myClient = new Client(parent, server, 51007);
    }

  }
  
  void resetMessage()
  {
    serverMessage = "";
    ready = false;
  }
  
  void addMessage(String nm)
  {
    serverMessage += nm;
  }
  
  void sendMessage()
  {
    myClient.write(serverMessage);
  }

  String PEGMessage(String name, int y, int x)
  {
    String msg = "";
    msg += zfill("name",20);
    msg += zfill(name,20);
    msg += zfill("y",20) + zfill(y,20) + zfill("x",20) + zfill(x,20);
    msg += zfill("entity",20) + zfill("ShapeEn",20) + zfill("type",20) + zfill("position",20);
    msg = makeMessage(msg);
    return msg;  
  }
  String zfill(String m, int l){
    String r = "";
    for(int i = 0; i < l - m.length(); i++) 
    {
      r+="0";
    }
    r+=m;
    return r;
  }
  String zfill(int m, int l){
    String s = "" + m;
    return zfill(s,l);
  }
  String makeMessage(String m){
    String s = "" + m.length();
    return zfill(s,6) + m;
  }
}




