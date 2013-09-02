/*
  Particle
  Example particles, fading rotating squares with colour and roundness set by pitch
*/

class Particle{
  // Persistant properties
  float parentX;
  float parentY;
  float posX;
  float posY;
  float velocityX;
  float velocityY;
  float rotation = 0;
  float rotspeed = (rand.nextFloat()-0.5)*40;
  color colour;
  float rounding;
  float pitch;
  float size = (rand.nextFloat()*10)+5;
  
   
  // Timer  
  boolean finished = false;
  FrameTimer fadetimer;
  int fadeTime;
   
  // Creates the particle
  Particle(float x, float y, float newPitch, int fade){
    
    posX = x;
    posY = y;
    parentX = x;
    parentY = y;

    float angle = rand.nextFloat() * 360; // Sets a random direction
    float length = 5.0; // Multiplier for the particle's speed
    
    // Fancy maths for making the effect circular
    velocityX = length * cos(angle);
    velocityY = length * sin(angle);
    
    fadetimer = new FrameTimer();
    fadeTime = fade;
    
    pitch = newPitch;
    
    //Sets Colour
    float red = map(pitch, 0, 200, 0, 255);
    float blue = map(pitch, 0, 200, 255, 0);
    colour = color(red, 0, blue);
    
    // Sets rounding
    rounding = map(pitch, 0, 200, size/2, 0);
  }
  
  void update(){
   // Once the timer expires the particle reports that it has finished  
   fadetimer.update();
   if(fadetimer.age > fadeTime){
     fadetimer = null;
     finished = true;
   }
   
   rotation += rotspeed;
   rotation = rotation % 360;
   
   // Updates the particle's position based on velocity
   posX += velocityX;
   posY += velocityY;
  }
  
  // Draw the particle
  void display(){
    
    noStroke();
    float alpha = map(fadetimer.age, 0, 6000, 255, 0); // Change the transparency based on age
    fill(colour,alpha); // Set the particle's colour
    pushMatrix(); // Contains transformations so they dont affect other particles
    translate(posX, posY); // Move the object to where it should be
    
    // Rotate the object
    rotate(radians(rotation));
    
    // Draw the shape
    rectMode(CENTER);
    rect(0, 0, size, size, rounding);
    
    popMatrix();
  }
  
 boolean finished(){
   return finished;
 }
}
