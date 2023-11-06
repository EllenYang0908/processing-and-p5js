import processing.serial.*;
Serial myPort;
String inString ;
float[] data = new float [6];
float xA = data[0];
float DxA = data[1];
float yA = data[2];
float DyA = data[3];
float zA = data[4];
float DzA = data[5];
int cnt = 0;
int mode = 0;
Boolean currentlyOnFirstScreen = true;
//float xV = xA*0.1;
//float yV = yA*0.1;
//float zV = zA*0.1;

//float xS = 1/2*xA*0.01+xV*0.1;
//float yS = 1/2*yA*0.01+yV*0.1;
//float zS = 1/2*zA*0.01+zV*0.1;
//float xS =width/2;
//float yS =height/2;
//float zS =333;
float xS;
float yS;
float zS;


Planet sun;

PImage sunTexture;
PImage[] textures = new PImage[10];

PImage img;

float fov = PI/3.0;
float cameraZ = (height/2.0) / tan(fov/2.0);

public void setup() {
  img = loadImage("GUI.jpg");

  size(2400, 1200, P3D);
  xS = width/2;
  yS = height/2;
  zS = 450;


  myPort = new Serial(this, Serial.list()[1], 9600);
  //println(Serial.list()[1]);
  myPort.bufferUntil('\n');



  sunTexture = loadImage("sun.jpg");
  textures[0] = loadImage("dirt.jpg");
  textures[1] = loadImage("eris.jpg");
  textures[2] = loadImage("golden.jpg");
  textures[3] = loadImage("green.jpg");
  textures[4] = loadImage("ice.jpg");
  textures[5] = loadImage("lava.jpg");
  textures[6] = loadImage("north.jpg");
  textures[7] = loadImage("ocean.jpg");
  textures[8] = loadImage("pink.jpg");
  textures[9] = loadImage("purple.jpg");


  sun = new Planet(50, 0, 0, sunTexture);
  sun.spawnMoons(10, 1);
}

public void draw() {
  if (currentlyOnFirstScreen == true) {
    image(img, 0, 0);
  } else {
    background(0);
    camera(xS, yS, zS, (width/2.0), (height/2.0), 0, 0, 1, 0);
    translate(width/2, height/2);
    sun.show();
    sun.orbit();
  }
}


void serialEvent(Serial myPort) {

  String inString = myPort.readStringUntil('\n');


  if (inString != null) {

    inString = trim(inString);
    println(inString);
    data = float (split(inString, ','));
    //println(data);
    xA = map(data[0], 0, width, 0, width*2);
    DxA = data[1];
    yA = map(data[2]*10, 0, width, 0, width*2);
    DyA = data[3];
    zA = map(data[4]*10, 0, width, 0, width*2);
    DzA = data[5];
    //if (DxA < 0)
    //  xA = -xA;
    if (DyA < 0)
      yA = -yA;
    if (DzA < 0)
      zA = -zA;

    float xA1 = xA/10;
    float yA1 = yA/10;
    float zA1 = zA/10;
    print (xS);

    for (int i = 0; i< 10; i++) {
      if (xS <= 7)
        mode = 0;
      else if (xS >= 10)
        mode = 1;
      if  (mode ==0) {

        xS += 0.1*xA1;
        yS += yA1;
        zS += zA1;
      }
      if ( mode ==1 ) {
        mode = 1;
        xS -= 0.1*xA1;
        yS += yA1;
        zS += zA1;
      }
      delay(45);
    }
    //xS += xA*10;
    //yS += yA*10;
    //zS += zA*10;

    //xV = xA*0.1;
    //yV = yA*0.1;
    //zV = zA*0.1;

    //xS = 1/2*xA*0.01+xV*0.1;
    //yS = 1/2*yA*0.01+yV*0.1;
    //zS = 1/2*zA*0.01+zV*0.1;
    cnt ++;
  }
}
void keyPressed(){ 

if(currentlyOnFirstScreen == true){
  currentlyOnFirstScreen = false; 
}
else{
  currentlyOnFirstScreen = true; 
}

}
