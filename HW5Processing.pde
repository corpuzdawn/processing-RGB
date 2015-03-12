/* Created by: Dawn Christine P. Corpuz
   CIE 150 Homework 5
   RGB
*/

import processing.serial.*;
Serial myPort;

HScrollbar hs1, hs2, hs3;
int red, green, blue;

void setup() {
  size(500, 300);
    String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 9600);
  
  noStroke(); 
  hs1 = new HScrollbar(0, height/4 + 10, width, 16, 16);
  hs2 = new HScrollbar(0, height/4*2 +10, width, 16, 16);
  hs3 = new HScrollbar(0, height/4*3 +10, width, 16, 16);
}

void draw(){
    background(red, green, blue);
  hs1.update();
  hs1.display();
  
  hs2.update();
  hs2.display();
  
  hs3.update();
  hs3.display();
  
  red = (int) map (hs1.getPos(), 0, width, 0, 255);
  green = (int) map (hs2.getPos(), 0, width, 0, 255);
  blue = (int) map (hs3.getPos(), 0, width, 0, 255);
 
  textAlign(CENTER);
  fill(255);
  textFont(createFont("Bebas Neue", 20));
  text(red,width/2,height/4-10);
  text(green,width/2,height/4*2-10);
  text(blue,width/2,height/4*3-10);
  
  myPort.write(red >> 8);
  myPort.write(red & 0xFF);
  myPort.write(green >> 8);
  myPort.write(green & 0xFF);
  myPort.write(blue >> 8);
  myPort.write(blue & 0xFF);
} 


class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = sw / widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(230);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
       fill(255);
    } else {
       fill(200);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
    
  }
}
  
/* //Arduino Code
int red = 5;
int green = 6;
int blue = 9;

int r, g, b;


void setup()
{
  pinMode(red, OUTPUT);
  pinMode(green, OUTPUT);
  pinMode(blue, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  if(Serial.available()>6)
  {
    r= Serial.read()<< 8 | Serial.read();
    g= Serial.read()<< 8 | Serial.read();
    b= Serial.read()<< 8 | Serial.read();

  }
  analogWrite(red, r);
  analogWrite(green, g);
  analogWrite(blue, b);
} 
*/
