// Imports the necessary Java classes
import org.json.*;
import java.util.Random;
import java.net.InetAddress;
import java.awt.Toolkit;
import processing.net.*; 


// SETTINGS
float monitorsize = 24.0; // Monitor size in inches
float offsetX = 0.0; // Offsets in metres
float offsetY = 0.0;
boolean hasMic = true;
float micOffsetX = 0.25; // Offsets in metres
float micOffsetY = 0.18; 
float micsensitivity = 5;
float micInterval = 100;

float targetFramerate = 30.0;
float lowestFramerate = 29.0;
 
String serverIP = "localhost";
int serverPort = 5204;

String uid;

//Controller controller = new Controller();

Client client; 
 
String localIP;

FrameTimer connectTimer;

FrameTimer cleanTimer;

// Creates a native java Random object as it gives us more control
Random rand = new Random(0); // Sets an initial random seed of 0

ArrayList visualisations; // Contains all the currently running effects

boolean incoming = false; // true if new data has arrived
JSON incomingObj; // Stores the new data before use

FrameTimer eventTimer;

SoundDetection sounddetect;

float ppm;
float scaleMultiplier = 1;
float scale;

Timer budgetTimer;

// Run once at start
void setup(){
  localIP = getLocalIP();
  
  uid = localIP+"-"+floor(random(1000,9999));
  println(uid);
  
  float aspectratio = (float)displayWidth/(float)displayHeight;
  float horiScreen = monitorsize * sin(sin(aspectratio))*0.0254;
  float vertScreen = monitorsize * cos(sin(aspectratio))*0.0254;
  float horiPPM = displayWidth/horiScreen;
  float vertPPM = displayHeight/vertScreen;
  ppm = (horiPPM+vertPPM)/2;
  
  scale = (floor(ppm)/1000.0)*scaleMultiplier;
 
  size(1024,768); // Will be mapped to window size
  if (frame != null) {
    frame.setResizable(true);
  }
  
  frameRate(targetFramerate); // Must be the same for all devices running the sketch
  smooth();
   
  client = new Client(this, serverIP, serverPort); 
    
  randomSeed(0); // only needed for built in random(), shouldn't be used anyway
     
  visualisations = new ArrayList();
  
  if(hasMic){
    eventTimer = new FrameTimer();
    sounddetect = new SoundDetection();
  }
  
  connectTimer = new FrameTimer(5000); // reconnect every 5 seconds
  cleanTimer = new FrameTimer(6666); // reconnect every 5 seconds
}

// Main loop
void draw(){
  budgetTimer = new Timer();
  budgetTimer.update();
  
   // we reconnect to the server periodically incase the server has gone away
  connectTimer.update();
  if(connectTimer.active()){
    client = new Client(this, serverIP, serverPort);
  }
  
  if(frameRate < lowestFramerate){
    println(frameRate);
  }

  if(hasMic){
    sounddetect.update();
    
    eventTimer.update();
    if(eventTimer.age > micInterval){
      eventTimer = new FrameTimer();
      if(sounddetect.amplitude > micsensitivity){
        send(sounddetect.pitchAverage, sounddetect.amplitudeAverage);
      }
    }
  }
  background(0); // Wipe the window

  
  pushMatrix(); // Allows grouped transformations of everything
  
  // Scale and transform will need to be set here, currently done manually,
  // eventually it will be calculated based on position setting and screen size
  
  float ratio = (float)width/height;
    
  float scaleX = scale*ratio;
  float scaleY = scale*(1.0/ratio);
  
  scale(scale);
  
  float transX = frame.getX() / -scale;
  float transY = frame.getY() / -scale;
  translate(transX - (offsetX*ppm)/scale, transY - (offsetY*ppm)/scale);

  // Cycle through each visualisation   
  for (int i = 0; i < visualisations.size(); i++) { 
    Visualisation visualisation = (Visualisation) visualisations.get(i);
    visualisation.update(); // Update positions
    visualisation.display(); // Update appearance
    
    // If a visualisation has finished, remove it
    if (visualisation.finished()) {
      visualisation = null; // Destroy it
      visualisations.remove(i);
      i--;
    }
  }    
  
  // If there is a new wave, this is done here so we can make sure it happens after the older visualisations are run first  
  while (client.available() > 0) { 
    byte[] data = client.readBytesUntil(10);
    if(data != null){
      String dataIn = new String(data);
      JSON incomingObj = JSON.parse(dataIn);
      if(visualisations.size() < 100){
        // Synchronises the random seed, resetting the random number generator
        rand.setSeed(incomingObj.getInt("pitch"));
        // Create a new visualisation with the data contained
        //visualisations.add(new Visualisation("SquareCircle", (float)incomingObj.getDouble("x"),(float)incomingObj.getDouble("y"),(float)incomingObj.getDouble("pitch"),incomingObj.getInt("duration")));
        visualisations.add(new Visualisation("ParticleVisualisation", (float)incomingObj.getDouble("x"),(float)incomingObj.getDouble("y"),(float)incomingObj.getDouble("pitch"),incomingObj.getInt("duration")));
        incoming = false;
      }
      //break;
    }
  } 
  popMatrix();

  cleanTimer.update();
  if(cleanTimer.active()){
    System.gc(); // Free up memory
  }
}

void send(float pitch, float amplitude){
  JSON obj = JSON.createObject();
  obj.setString("ip", localIP);
  obj.setString("uid", uid);
  //obj.put("offsetX", offsetX);
  //obj.put("offsetY", offsetY);
  obj.setFloat("x", (offsetX + micOffsetX)*1000);
  obj.setFloat("y", (offsetY + micOffsetY)*1000);
  obj.setFloat("pitch", map(pitch,0,7000,0,200));
  obj.setFloat("amplitude", amplitude);
  obj.setFloat("duration", map(amplitude, 0, 100, 0, 200));
  client.write(obj.toString().replace("\n","")+"\n");
}

// Uses the global Random object to get a random float in a range
float randomFloat(float lower, float upper){
  return map(rand.nextFloat(), 0, 1, lower, upper);
}

String getLocalIP(){
  try{
    InetAddress ownIP=InetAddress.getLocalHost();
    return ownIP.getHostAddress();
  }catch (Exception e){
    return "";
  } 
}

