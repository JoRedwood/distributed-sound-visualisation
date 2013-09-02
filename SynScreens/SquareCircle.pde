/*
  Visualisation
*/

class SquareCircle{
 
  float posX;
  float posY;
  float pitch;
  float duration;
  color colour;
  float rotation = 0;
 // float rotspeed = (rand.nextFloat()-0.5)*40;
  float rotspeed = random(-20,20);
  float red;
  float blue;

  int particleNumber = 20;
  float circleSize = 0.0;
    
  boolean finished = false;
  
  ArrayList particles; // contains all the particles
  
  FrameTimer timer; // Timer for limiting the duration of a visualisation
  
  // Create the visualisation
  SquareCircle(float x, float y, float newPitch, float newDuration){
    posX = x;
    posY = y;
    pitch = newPitch;
    duration = newDuration * 15.0;
    timer = new FrameTimer(); // Start the timer 
   
    red = map(pitch, 0, 100, 0, 255);
    blue = map(pitch, 0, 100, 255, 0); 
  } 
  
  
  void update(){
    timer.update(); // Update the timer
    if(timer.age > duration){
    //timer = null;
      finished = true; 
    }

    //fill(255);
    circleSize += 10.0;  
    rotation += rotspeed;
    rotation = rotation % 360;
  }
 
  void display(){
    
    float alpha = map(timer.age, 0, duration+200, 255, 0); // Change the transparency based on age
    noStroke(); 
    // Any single effects the visualisation has
    if(pitch <= 15){
      colour = color(red, 0, blue);
      fill(colour,alpha);
      ellipse(posX,posY,circleSize, circleSize); 
    }else{
      pushMatrix();
      translate(posX, posY); 
      rotate(radians(rotation));
      colour = color(red, 0, blue);
      fill(colour,alpha);
      rectMode(CENTER);
      rect(0, 0, circleSize, circleSize);
      popMatrix();
    }

  }
 
  boolean finished(){
    return finished;
  }
 
  
}
