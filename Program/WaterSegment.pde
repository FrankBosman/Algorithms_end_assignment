
/*  -- WaterSegment Class --
 *  This Class displays, the water at the points and interact with the other segments through surface. 
 *  Adapted from topic 6 assignment 6.6, made by Ysbrand Burgstede, Frank Bosman.
 */

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
  Surface surface;

  WaterSegment(PVector pos, float radius, Surface surface) {
    this.pos = pos;
    this.radius = radius;
    this.surface = surface;
    heightOffset = 0; //the offset from the default water level
  }

  void display() { //draws the segment
    curveVertex(pos.x, pos.y + heightOffset + surface.levelHeight);
  }

  void updateForces(float forceLeft, float forceRight) { //only update the forces
    float springForce = -heightOffset * springConst;
    float friction =  -frictionConst * speed;  

    force = springForce + friction + forceLeft + forceRight; //the neto force on the segment

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

  float distance(float x, float y, PVector posWater) { //calcs the distance between 
    return dist(x, y, pos.x+ posWater.x, pos.y + posWater.y + heightOffset + surface.levelHeight);
  }

  PVector getPos() {
    return new PVector(pos.x, pos.y + heightOffset + surface.levelHeight);
  }

  PVector distVect(PVector otherPos) { //the distance vector from this segment to the other
    PVector distVect = getPos().sub(otherPos);
    return distVect;
  }

  float getHeightOffset() { //return the offset from the default water levels, used in calculating the spring force
    return heightOffset;
  }

  float getSpringForce(float fromHeight) { //caluclates the spring force
    return (heightOffset - fromHeight) * springConst;
  }
}
