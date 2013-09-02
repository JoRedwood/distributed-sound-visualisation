/*
  Timer
  Simple timer that makes use of real world time so will still be fairly accurate with framerate issues
  
  author Jonathan Redwood jred.co.uk
*/

class Timer{
  
  int period; // milliseconds
  int time;
  int lastTime = 1;
  
  int age = 0; // Counter since timer started
  int last = millis();
  
  boolean active = false;
  boolean running = true;
  
  // If no period is set, just updates the age property
  Timer(){
    period = 0;
    lastTime = millis();
  }
  
  // If a period is set it sets active to true at that interval
  Timer(int newPeriod){
    period = newPeriod;
    lastTime = millis();
  }
  
  // Updates the timer, must be called as often as possible
  void update(){
    if(running){
      time = millis();
      
      // for the total time the timer has been running
      if(time > last){
        // Works out the difference from the last time recorded
        age += (time - last);
      }
      last = time;
      
      if(time - lastTime >= period){
        lastTime = time;
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
    lastTime = millis();
  }
  
  // Pauses the timer
  void stop(){
    running = false;
  }
  
  boolean active(){
    return active;
  }
}

