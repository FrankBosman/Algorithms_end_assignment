
/*  -- Particle Class --
 *  This Class handels the particle
 *  Adapted from Topic 4 Assignment 1 made by Marnix Lueb and Sterre Kuijper 
 */

class Particle {
  int lifespan;

  PVector position;
  PVector velocity;
  PVector acceleration;

  float gravity;

  //interaction
  PVector windowSillPos;
  float windowSillWidth;
  Plant plant;

  float radius;

  Particle(PVector position, PVector direction, PVector windowSillPos, float windowSillWidth) {
    this.position = position.copy();
    this.windowSillPos = windowSillPos;
    this.windowSillWidth = windowSillWidth;

    velocity = direction.copy().setMag(random(5, 15));
    gravity = 1;

    radius = 5;
    lifespan = 255;
  }

  void display() {
    noStroke();
    fill(20, 100, 255, lifespan);//41, 170, 225, lifespan); //blue color that is faded based on its lifespan
    circle(position.x, position.y, radius);
  }

  void update() {
    velocity.y += gravity;

    if (position.y >= windowSillPos.y && position.y < windowSillPos.y + 20 && abs(position.x - windowSillPos.x) <= windowSillWidth/2) { //collide with sill
      velocity.y = 0;     //remove the velocty in the direction to the sill
      velocity.x *= 0.9;  //add some drag from the sill
      position.y = windowSillPos.y;
      lifespan -= 2;//lower the life more quickly
    } 

    position.add(velocity);

    lifespan--;
  }

  boolean isDead() {
    if (lifespan <= 0) {
      return true;
    } else {
      return false;
    }
  }

  PVector getPos() {
    return position.copy();
  }

  void kill() {
    lifespan = 0;
  }

  float getForceDown() {
    return gravity;
  }
}
