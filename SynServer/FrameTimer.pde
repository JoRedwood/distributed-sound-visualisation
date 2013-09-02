/*
  FrameTimer
  Used as a timer based on the number of frames that have passed.
  This relies on a constant framerate, without it it will fall behind
  Frame dropping isn't possible as each sketch has to go through exactly the same sequence.
  
  author Jonathan Redwood jred.co.uk
*/

class FrameTimer{
 
  boolean running = true;
  boolean active = false;
  
  float age;
  int period = 0;
  float frames = 0; // Counter since timer started
  int cycleframes = 0; // Counter for a single cycle
  int framerate = 30;
  
  // If no period is set, just updates the age property
  FrameTimer(){}
  
  // If a period is set it sets active to true at that interval
  FrameTimer(int newPeriod){
    period = newPeriod;
  }
  
  // Updates the timer, must be called every frame
  void update(){
    if(running){
      frames++;
      cycleframes++;
      age = (frames/framerate)*1000; // Works out time by the number of frames assuming a constant framerate
      
      if(period != 0 && (cycleframes/framerate)*1000 > period){
        cycleframes = 0;
        active = true;
      }else{
        active = false; 
      }
    }
  }
  
  void setPeriod(int newPeriod){
    period = newPeriod;
  }
  
  // Resumes the timer
  void start(){
    running = true;
  }
  
  // Pauses the timer
  void stop(){
    running = false;
  }
  
  boolean active(){
    return active;
  }
}


