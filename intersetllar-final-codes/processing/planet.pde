class Planet {
  float radius;
  float angle;
  float distance;
  Planet[] planets;
  float orbitspeed;
  PVector v;
  
  PShape globe;
  

  Planet(float r, float d, float o, PImage img) {
    v = PVector.random3D();
    radius = r;
    distance = d;
    v.mult(distance);
    angle = random(TWO_PI);
    orbitspeed = o;
    
    noStroke();
    noFill();
    globe = createShape(SPHERE,radius);
    //globe.setTexture(img);
    globe.setTexture(img);
  }
  void orbit() {
    angle = angle + orbitspeed;
    if (planets != null) {
      for (int i=0; i<planets.length; i++) {
        planets[i].orbit();
      }
    }
  }
  void spawnMoons(int total, int level) {
    planets = new Planet[total];
    for (int i=0; i<planets.length; i++) {
      float r = radius/(level*4);
      float d = i*6 + random((radius + r), (radius+r)*6);
    
      float o = random(-0.005, 0.005);
      
      planets[i] = new Planet(r, d, o, textures[i]);
      if (level < 2) {
        int num = int(random(0,2));
        planets[i].spawnMoons(num, level+1);
      }
    }
  }


  void show() {
    pushMatrix();
    noStroke();
    fill(255);
    //rotate(angle);
    PVector v2 = new PVector(1,0,1);
    PVector p = v.cross(v2);
    rotate(angle,p.x,p.y,p.z);
    //stroke(255);
    //line(0,0,0,v.x,v.y,v.z);
    //line(0,0,0,p.x,p.y,p.z);
    
    translate(v.x,v.y,v.z);
    
    
    shape(globe);
    if(distance ==0){
      pointLight(255,255,255,300,187,0);
    }
    

    //sphere(radius);
    //ellipse(0, 0, radius*2, radius*2);

    if (planets != null) {
      //println(planets.length);
      for (int i=0; i<planets.length; i++) {
        planets[i].show();
      }
    }
    popMatrix();
  }
}
