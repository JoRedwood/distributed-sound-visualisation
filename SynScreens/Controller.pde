import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

JSlider slider1,slider2,slider3,slider4;

class Controller extends Frame implements WindowListener
{
  public Controller()
  {
    super("Controller");
    this.setSize(280,140);
    this.setLayout(new GridLayout(6,1));
    this.add(new Panel());
    slider1 = new JSlider(1,255,128);
    this.add(slider1);
    slider2 = new JSlider(1,255,128);
    this.add(slider2);
    slider3 = new JSlider(1,255,128);
    this.add(slider3);
    slider4 = new JSlider(1,255,128);
    this.add(slider4);
    
    SpinnerModel model = new SpinnerNumberModel(9.9, 1, 15, 0.1);     
    JSpinner spinner = new JSpinner(model);
    this.add(spinner);
    
    this.add(new Panel());
    this.addWindowListener(this);
    this.setVisible(true);
  }

  public void windowClosing(WindowEvent e)
  {
    this.setVisible(false);
  }
  
  public void windowOpened(WindowEvent e) {}
  public void windowClosed(WindowEvent e) {}
  public void windowIconified(WindowEvent e) {}
  public void windowDeiconified(WindowEvent e) {}
  public void windowActivated(WindowEvent e) {}
  public void windowDeactivated(WindowEvent e) {}

}
