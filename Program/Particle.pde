class Particle {

  int lifespan;

  PVector position;
  PVector velocity;
  PVector acceleration;

  float radius;
  Particle(PVector position) {
    this.position = position.copy();
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = velocity.copy().setMag(random(0.01, 0.2));

    radius = 5;
    lifespan = 255;
  }

  void display() {
    noStroke();
    fill(41, 170, 225, lifespan);
    circle(position.x, position.y, radius);
  }

  void update() {
    position.add(velocity);
    velocity.add(acceleration);
    lifespan--;
  }

  boolean isDead() {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
}
