class WaterSegment {
  PVector pos;
  float heightOffset;
  float radius;
  float speed;
  float acceleration;
  static final float springConst = 0.01;
  static final float frictionConst = 0.01;
  int mass = 1;
  float force;

  WaterSegment(PVector pos, float radius) {
    this.pos = pos;
    this.radius = radius;
    heightOffset = 0;
  }

  void display() { //draws the segment
    // fill(0,0,200);
    // noStroke();
    // circle(pos.x, pos.y + heightOffset, radius);
    curveVertex(pos.x, pos.y + heightOffset);
  }

  void updateForces(float forceLeft, float forceRight) { //only update the forces
    float springForce = -heightOffset * springConst;
    float friction =  -frictionConst * speed;  

    force = springForce + friction + forceLeft + forceRight;

    acceleration = force/mass;
  }

  void updateMovement() { //update the speed and position
    speed += acceleration;
    heightOffset += speed;
  }

  void addForce(float force) {//add force to the segment
    acceleration = force/mass;

    speed += acceleration;
  }

  float distance(float x, float y) { //calcs the distance between 
    return dist(x, y, pos.x, pos.y + heightOffset);
  }

  PVector getPos() {
    return new PVector(pos.x, pos.y + heightOffset);
  }

  PVector distVect(PVector otherPos) {
    PVector distVect = getPos().sub(otherPos);
    return distVect;
  }

  float getHeightOffset() {
    return heightOffset;
  }

  float getSpringForce(float fromHeight) {
    return (heightOffset - fromHeight) * springConst;
  }
}