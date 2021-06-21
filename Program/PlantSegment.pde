
/*  -- PlantSegment Class --
 *  This Class manages the plantSegment and everything surounding it.
 *  It updates the linked list with the mass spring damperer system.
 *  Handles the interaction and draws everything.
 */

class PlantSegment {
  static final float DAMPING_CONSTANT = 0.02;
  static final float SPRING_CONSTANT = 0.02;

  color segmentColor;
  float force, velocity, angle, totalAngle, offsetAngle;
  PVector position;
  float segmentLength;
  float growAnimation;
  int growTime; //in frames

  PlantSegment segmentBellow;
  ArrayList<PlantSegment> segmentsAbove = new ArrayList<PlantSegment>();
  boolean isBottom; //if it's the bottom segment, so if it has a segment bellow it.

  PlantSegment(float segmentLength, PlantSegment segmentBellow, float offsetAngle, int growTime) {
    this.segmentLength = segmentLength;
    this.segmentBellow = segmentBellow;
    this.growTime = growTime;
    growAnimation = growTime;

    if (segmentBellow == null) {
      isBottom = true;
      force = 0;
      velocity = 0;
    } else {
      isBottom = false;
      force = segmentBellow.getForce();
      velocity = segmentBellow.getVeloctiy();
    }

    segmentColor = color(94, 135, 5); //green
    position = new PVector();

    angle = 0;
    totalAngle = 0;
    this.offsetAngle = offsetAngle;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(totalAngle); //rotates the segment to match the flowers' rotation
    stroke(segmentColor);
    strokeWeight(5);
    line(0, 0, 0, -segmentLength + segmentLength * growAnimation/growTime); //draws the line of the segment

    //reset strokeWeight
    strokeWeight(1);

    popMatrix();
  }

  void update(boolean hydrated) {
    float tempVelocity = 0;
    if (!isBottom) tempVelocity = velocity - segmentBellow.getVeloctiy(); //calculates the temp velocity to be used in the calculations. if there is a segment bellow it 

    float friction = tempVelocity * DAMPING_CONSTANT;           //calulates the friction with the velocity it's self and bellow
    angle += tempVelocity;
    force = SPRING_CONSTANT * angle + friction;                 //calculates the new force

    float forceAbove = 0;                                       //init it with 0 so if segmentsAbove is empty it's 0 and so we can sum over it.
    for (PlantSegment segment : segmentsAbove) {                 //sums the forces from all the segments above
      forceAbove += segment.getForce();
    }

    velocity += forceAbove - force;                             //calculates the new velocity with the velocity of the segments above

    if (!isBottom) { //calculate the new position
      totalAngle = angle + segmentBellow.getTotalAngle() + offsetAngle;
      position = segmentBellow.getPosition();
      position.x += -cos(-(segmentBellow.getTotalAngle() + HALF_PI)) * segmentLength;
      position.y += sin(-(segmentBellow.getTotalAngle() + HALF_PI)) * segmentLength;
    }

    if (hydrated) growAnimation();
  }

  void growAnimation() {
    //update the grow animation
    if (growAnimation > 0) growAnimation--;
  }

  void addSegmentAbove(PlantSegment segment) {
    segmentsAbove.add(segment);
  }

  void wind(float time, float windFactor) {
    float windForce = noise(position.x + time, position.y) * windFactor;
    force = windForce;
  }

  float getVeloctiy() {
    return velocity;
  }

  float getForce() {
    return force;
  }

  float getTotalAngle() {
    return totalAngle;
  }
  float getAngle() {
    return angle;
  }

  PVector getPosition() {
    return position.copy();
  }

  void setForce(float forceIn) {
    force = forceIn;
  }

  boolean isTopSegment() {
    return segmentsAbove.size() == 0;
  }
}
