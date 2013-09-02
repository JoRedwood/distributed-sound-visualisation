/*
  Visualisation
  An individual effect containing a number of particles
*/

class ParticleVisualisation{
 
  float posX;
  float posY;
  float pitch;
  int duration;
  int particleNumber = 20;
    
  float twist = 0.0;  
    
  boolean finished = false;
  boolean finishing = false;
  
  ArrayList particles; // contains all the particles
  
  FrameTimer timer; // Timer for limiting the duration of a visualisation
  
  // Create the visualisation
  ParticleVisualisation(float x, float y, float newPitch, int newDuration){
    posX = x;
    posY = y;
    pitch = newPitch;
    duration = newDuration;
    
    timer = new FrameTimer(); // Start the timer
    
    particles = new ArrayList();
    // Generate the desired number of particles
    for(int i = 0; i < particleNumber; i++){
      particles.add(new Particle(posX, posY, pitch, 6000));
    }
  } 
  
  
  
  void update(){
    timer.update(); // Update the timer
    
    /* Once the visualisation is too old, rather than just stopping it and making all the
      particles disappear at once we set finishing to true to stop it generating new particles, 
      once the last has finished we then set finished to true, this tells the sketch that the 
      visualisation can be stopped. */
    if(timer.age > duration){
      // Stop making particles
      finishing = true; 
    }
    
    if(particles.size() < 1){
      // No more particles
      finished = true;
    }
    pushMatrix();   
    twist += 0.01;
    //rotate(twist);
    
    // Loop through particles
    budgetTimer.update();
    for (int i = 0; i < particles.size(); i++) { 
      Particle particle = (Particle) particles.get(i); // Get a particle
      particle.update(); // Update it
      if (particle.finished()) {
        particle = null; // Destroy it
        particles.remove(i);
        
        if(!finishing){
          // Not finishing, create more
          particles.add(new Particle(posX,posY,pitch,6000));
          /* Since the particles were created with random lifespans they also die with them so we 
             don't need to generate a new random number here */
        }
        i--;
      }else{
        if(budgetTimer.age < 1000/targetFramerate){
          particle.display(); // Draw the particles
        }
      }
    }  
    popMatrix();
  }
 
  void display(){
    // Any single effects the visualisation has
  }
 
  boolean finished(){
    return finished;
  }
 
  
}
