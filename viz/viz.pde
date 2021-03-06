  import oscP5.*;
import netP5.*;
  
OscP5 oscP5;

// image dimensions
final int IMG_WIDTH = 1280;
final int IMG_HEIGHT = 720;

//device management
IntDict dev_timers;
IntDict dev_patches;

//patches
//circle circ;
ripplingColors rc;
rippling3D r3D;
daisies da;
gameOfLife gol;
FFTCircles circs;
ArrayList<patch> patches;
ArrayList<Boolean> patch_switch;

//random color weights
float red_weight = .5;
float green_weight = .5;
float blue_weight = .5;

void setup(){
  size(IMG_WIDTH,IMG_HEIGHT, P3D);
  oscP5 = new OscP5(this,12000);
  dev_patches = new IntDict();
  dev_timers = new IntDict();
  patches = new ArrayList<patch>();
  patch_switch = new ArrayList<Boolean>();
 
  for (int i=0; i < 6; i++) {
    patch_switch.add(false);
  }
  patch_switch.set(3,true);
  rc = new ripplingColors();
  r3D = new rippling3D();
  da = new daisies(this);
  gol = new gameOfLife();
  circs = new FFTCircles(this);
  patches.add(rc);
  patches.add(r3D);
  patches.add(da);
  patches.add(gol);
  patches.add(circs);
 
  oscP5.plug(this,"pinged","/ping");
//  oscP5.plug(this,"update_red_weight","/1/fader1");
//  oscP5.plug(this,"update_green_weight","/1/fader2");
//  oscP5.plug(this,"update_blue_weight","/1/fader3");

  noCursor();
}

void draw(){
  timeout_check();
  //background(0);
//  red_weight = int(random(255));
//  green_weight = int(random(255));
//  blue_weight = int(random(255));

  for (int i=0; i<patches.size(); i++){
   if (patch_switch.get(i)){
     //println(patch_switch);
     patch p = patches.get(i);
     p.render(); 
   }
  }

  reset_patch_switch();
  for (int i : dev_patches.values()) {
    patch_switch.set((i-1), true);
  }
  draw_connection_info();
}

void draw_connection_info(){
  colorMode(RGB,100);
  fill(0,1);
  stroke(0,1);
  rect(0,0,650,50);
  fill(100,100);
  textAlign(LEFT,TOP);
  textSize(18);
  //text("Wifi: visuals, Address: 192.168.1.112",0,0);
}

void reset_patch_switch() {
  for (int i=0; i < patch_switch.size(); i++) {
    patch_switch.set(i,false);
  } 
}
void pick_single_patch(ArrayList<Boolean> patch_swtich, int num){
  for (int i=0; i < patch_switch.size(); i++) {
    if (i==num) {
      patch_switch.set(i,true);
    } else {
      patch_swtich.set(i,false);
    }
  }
}
/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
  */
 String ip = theOscMessage.get(0).stringValue();
// dev_timers.set(ip, millis());
 println("IP: " + ip);
 //println("addrPattern: " + theOscMessage.addrPattern());
 if(theOscMessage.isPlugged()==false) {
   if (theOscMessage.addrPattern().length() == 2) {
     try {
        int patch_num = int(str(theOscMessage.addrPattern().charAt(1)));
          
        println("IP: " +  ", Patch_num: " + str(patch_num));
        //device management
        if (patch_num==9){
          dev_timers.remove(ip);
          dev_patches.remove(ip);
        } else {
          dev_patches.set(ip,patch_num);
          dev_timers.set(ip, millis());
        }
      
      } catch (Exception e) {
        println("error parsing patch code");
      }

      
   } else {
        /* print the address pattern and the typetag of the received OscMessage */
        println("### received an osc message.");
        println("### addrpattern\t"+theOscMessage.addrPattern());
        println("### typetag\t"+theOscMessage.typetag());
        println("### netaddress"+theOscMessage.netaddress());
  }
 }
 
}

void timeout_check(){
  for (String ip : dev_timers.keys()){
    if ((millis()-dev_timers.get(ip))>10000){
      dev_timers.remove(ip);
      dev_patches.remove(ip);
      println(ip + " timedout");
    }
  }
}

void pinged(String ip){
  dev_timers.set(ip,millis());
}

void mouseDragged(){
  println("mouseX: " + mouseX);
  println("mouseY: " + mouseY);
  da.mouseDragged();
}

boolean sketchFullScreen() {
  return true;
}
