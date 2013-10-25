import processing.net.*;

Server server;

Timer timer;

int eventsSent = 0;
int eventLimit = 200;

ArrayList events;

void setup(){
  //frameRate(30);
  size(800,400);
  
  server = new Server(this, 5204);
  
  timer = new Timer(100);
}

void draw(){
  
  events = new ArrayList();  

  timer.update();
  if(timer.active){
    background(100);
    // Listens to incoming messages from clients
    Client client = server.available();
    while(client !=  null) { 
      byte[] data = client.readBytesUntil(10);
      if(data != null){
        String dataIn = new String(data);
        JSONObject incomingObj = JSONObject.parse(dataIn);
        //println(incomingObj);
        events.add(incomingObj);
       // server.write(incomingObj.toString()+"\n"); // Just immediatly sends it out to all clients
        
        // Processes client data
      }
      //Fetch the next client and start again
      client = server.available();
    }
    // Updates the model
    
    float sensitivity = 100.0;
    
    
    for (int i = 0; i < events.size(); i++) { 
      JSONObject event = (JSONObject) events.get(i);
  
      // Go through all the others and look for a pair
      for (int j = 0; j < events.size(); j++) { 
        // Stops it matching to itself
        if(i != j){
          JSONObject matchEvent = (JSONObject) events.get(j);
          // check for same origin and that they were not created on the server
          if(event.getString("uid") != matchEvent.getString("uid") && event.getString("uid") != "server" && matchEvent.getString("uid") != "server"){
            // check for shared pitch
            if((float)event.getDouble("pitch") < (float)matchEvent.getDouble("pitch")+sensitivity && (float)event.getDouble("pitch") > (float)matchEvent.getDouble("pitch")-sensitivity){
              // Combine them and remove the originals
    
              // Determine the loudest
              JSONObject loudest;
              JSONObject quietest; 
              if(event.getDouble("amplitude") > matchEvent.getDouble("amplitude")){
                loudest = event;
                quietest = matchEvent;
              }else{
                loudest = matchEvent;
                quietest = event;
              }
             
              PVector vloud, vquiet, vbalanced;
              vloud = new PVector(loudest.getInt("x"), loudest.getInt("y"));
              vquiet = new PVector(quietest.getInt("x"), quietest.getInt("y")); 
              
              float ratio = ((float)quietest.getDouble("amplitude")/(float)loudest.getDouble("amplitude"))/2;
              vbalanced = PVector.lerp(vloud, vquiet, ratio);
              
              JSONObject obj = new JSONObject();
              obj.setString("uid", "server");
              obj.setFloat("x", vbalanced.x);
              obj.setFloat("y", vbalanced.y);
              obj.setFloat("pitch", (event.getInt("pitch")+matchEvent.getInt("pitch"))/2);
              obj.setFloat("amplitude", (event.getFloat("amplitude")+matchEvent.getFloat("amplitude"))/2);
              obj.setFloat("duration", map((float)obj.getFloat("amplitude"), 0, 100, 0, 200));
             // server.write(obj.toString()+"\n");
              
              events.remove(i);
              //events.remove(j-1);
             // if(events.get(j-1) != null) events.remove(j-1); // we remove the one below because the previous removal has already taken one out 
              events.add(obj); 
            }
          }else{
            //println("Shared origin"); 
          }
        }
      }
     // println("/////");
    }
    eventsSent = 0;
    for (int i = 0; i < events.size(); i++) { 
      if(eventsSent < eventLimit){
        JSONObject event = (JSONObject) events.get(i);
        server.write(event.toString().replace("\n","")+"\n");
        
        float scale = 10.0;
        if(event.getString("uid") == "server"){
          fill(255,0,0);
        }else{
          fill(255);
        }
        ellipse((event.getInt("x")/scale)+(width/2)-5,(event.getInt("y")/scale)+(height/2)-5, 10, 10);
      }
    }
  
    // Sends to clients
    System.gc();
  }
}

/*
void send(float pitch, float amplitude){
  JSONObjectObject obj = new JSONObjectObject();
  //200 pixels in this is 20cm
  obj.put("x", (offsetX + micOffsetX)*1000);
  obj.put("y", (offsetY + micOffsetY)*1000);
  obj.put("pitch", map(pitch,0,7000,0,200));
  obj.put("duration", map(amplitude, 0, 100, 0, 200));
  server.write(obj.toString()+"\n");
}
*/

