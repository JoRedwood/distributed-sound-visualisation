import ddf.minim.*;
import ddf.minim.analysis.*;

class SoundDetection{
  
  Minim minim;
  AudioInput in;
  FFT fft;
  int highest=0;
   
  float pitch = 0;
  ArrayList pitchArray = new ArrayList();
  float pitchAverage = 0;
  int pitchSmoothing = 1;
  
  float amplitude = 0;
  ArrayList amplitudeArray = new ArrayList();
  float amplitudeAverage = 0;
  int amplitudeSmoothing = 1;
    
  SoundDetection(){
    minim = new Minim(this);
    //minim.debugOn();
  
    in = minim.getLineIn(Minim.MONO, 4096, 22050);
    fft = new FFT(in.bufferSize(), in.sampleRate());
  }
  
  void update(){
    
    fft.forward(in.left);
    highest = 0;
    
    for (int n = 0; n < fft.specSize(); n++) {
      //find frequency with highest amplitude
      if (fft.getBand(n) > fft.getBand(highest)){
        highest = n;
        pitch = highest * 10.76;
        amplitude = fft.getBand(n);
      }
    }
  
    // Smooths pitch
    if(pitchArray.size() > pitchSmoothing){
      pitchArray.remove(0);
    }
    pitchArray.add(pitch);
    for (int i = 0; i < pitchArray.size(); i++) { 
      Float value = (Float)pitchArray.get(i);
      pitchAverage += value;
    }  
    pitchAverage = pitchAverage/pitchArray.size();
    //println(pitchAverage);
    
    
    // Smooths amplitude
    if(amplitudeArray.size() > amplitudeSmoothing){
      amplitudeArray.remove(0);
    }
    amplitudeArray.add(amplitude);
    for (int i = 0; i < amplitudeArray.size(); i++) { 
      Float value = (Float)amplitudeArray.get(i);
      amplitudeAverage += value;
    }  
    amplitudeAverage = amplitudeAverage/amplitudeArray.size();
    //println(amplitudeAverage);
    
    
    //println(pitch+"Hz at "+amplitude);
  }
   
  void stop(){
    // always close Minim audio classes when you are done with them
    in.close();
    minim.stop();
  }
}
