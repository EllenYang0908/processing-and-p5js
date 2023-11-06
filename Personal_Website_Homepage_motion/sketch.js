let particles = [];
let flowfield;

function setup() {
  createCanvas(600, 400, WEBGL);
  background(0);
  flowfield = new FlowField(20);
  for (let i = 0; i < 1000; i++) {
    particles[i] = new Particle();
  }
}

function draw() {
  for (let i = 0; i < particles.length; i++) {
    particles[i].follow(flowfield);
    particles[i].update();
    particles[i].display();
    particles[i].edges();
  }
}

class Particle {
  constructor() {
    this.position = createVector(random(width), random(height), random(200));
    this.velocity = createVector(0, 0, 0);
    this.acceleration = createVector(0, 0, 0);
    this.maxspeed = 0.25;
    this.size = random(1, 10);
    this.color = color(random(100, 200), 0, random(150, 255));
  }

  follow(flowfield) {
    const x = floor(this.position.x / flowfield.resolution);
    const y = floor(this.position.y / flowfield.resolution);
    const z = floor(this.position.z / flowfield.resolution);
    const index = x + y * flowfield.cols + z * flowfield.cols * flowfield.rows;
    const force = flowfield.field[index];
    this.applyForce(force);
  }

  applyForce(force) {
    this.acceleration.add(force);
  }

  update() {
    this.velocity.add(this.acceleration);
    this.velocity.limit(this.maxspeed);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
  }

  display() {
    noStroke();
    fill(this.color);
    push();
    translate(this.position.x - width / 2, this.position.y - height / 2, this.position.z - 100);
    sphere(this.size);
    pop();
  }

  edges() {
    if (this.position.x > width) this.position.x = 0;
    if (this.position.x < 0) this.position.x = width;
    if (this.position.y > height) this.position.y = 0;
    if (this.position.y < 0) this.position.y = height;
    if (this.position.z > 200) this.position.z = 0;
    if (this.position.z < 0) this.position.z = 200;
  }
}

class FlowField {
  constructor(res) {
    this.resolution = res;
    this.cols = width / res;
    this.rows = height / res;
    this.depth = 200 / res;
    this.field = new Array(this.cols * this.rows * this.depth);
    this.init();
  }

  init() {
    let xoff = 0;
    for (let x = 0; x < this.cols; x++) {
      let yoff = 0;
      for (let y = 0; y < this.rows; y++) {
        let zoff = 0;
        for (let z = 0; z < this.depth; z++) {
          const index = x + y * this.cols + z * this.cols * this.rows;
          const angle = noise(xoff, yoff, zoff) * TWO_PI * 4;
          const v = p5.Vector.fromAngle(angle);
          v.setMag(1);
          this.field[index] = v;
          zoff += 0.1;
        }
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }
}

function mousePressed() {
  loop(); // Start animation when the mouse is pressed.
}

