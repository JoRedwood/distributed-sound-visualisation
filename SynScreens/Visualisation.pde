/*
  Visualisation
  An individual effect containing a number of particles
*/

class Visualisation{
  
  String type; 
  ArrayList item;
      
  // Create the visualisation
  Visualisation(String newtype, float x, float y, float newPitch, int newDuration){
    type = newtype;
    
    item = new ArrayList();
   
    if(type == "ParticleVisualisation"){
      ParticleVisualisation vis = new ParticleVisualisation(x, y, newPitch, newDuration);
      item.add(vis);
    }
    
    if(type == "SquareCircle"){
      SquareCircle vis = new SquareCircle(x, y, newPitch, newDuration);
      item.add(vis);
    }
   
  } 
  
  
  
  void update(){   
    if(type == "ParticleVisualisation"){
      ParticleVisualisation vis = (ParticleVisualisation)item.get(0);
      vis.update();
    }
    if(type == "SquareCircle"){
      SquareCircle vis = (SquareCircle)item.get(0);
      vis.update();
    }
  }
 
  void display(){
    if(type == "ParticleVisualisation"){
      ParticleVisualisation vis = (ParticleVisualisation)item.get(0);
      vis.display();
    }
    if(type == "SquareCircle"){
      SquareCircle vis = (SquareCircle)item.get(0);
      vis.display();
    }
  }
 
  boolean finished(){
    if(type == "ParticleVisualisation"){
      ParticleVisualisation vis = (ParticleVisualisation)item.get(0);
      return vis.finished;
    }
   if(type == "SquareCircle"){
      SquareCircle vis = (SquareCircle)item.get(0);
      return vis.finished;
    }
    return true;
  }
 
  
  
}
