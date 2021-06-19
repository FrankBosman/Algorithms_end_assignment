class Particle {

  int lifespan;

  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float gravity;

  float radius;
  Particle(PVector position, PVector direction) {
    this.position = position.copy();
    velocity = direction.copy().setMag(random(5, 15));
    gravity = 1;

    radius = 5;
    lifespan = 255;
  }

  void display() {
    noStroke();
    fill(41, 170, 225, lifespan);
    circle(position.x, position.y, radius);
  }

  void update() {
    velocity.y += gravity;
    position.add(velocity);
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
