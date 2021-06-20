
/*  -- Leaf Class --
 *  This Class displays the leaf and manages the growing animation 
 */

class Leaf extends PlantSegment {
  static final float ANIMATION_TIME = 500;
  float leafSize;
  float maxLeafSize;
  color leafColor;
  int cooldown;

  Leaf(float segmentLength, PlantSegment segmentBellow, float offsetAngle) {
    super(segmentLength, segmentBellow, offsetAngle, int(ANIMATION_TIME));
    leafSize = 0;
    maxLeafSize = segmentLength*10;
    leafColor = color(132, 191, 3);
    cooldown = growTime;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(totalAngle); //rotates the segment to match the flowers' rotation

    //draws leaf:
    noStroke();

    //background
    fill(segmentColor);
    beginShape();
    vertex(-leafSize/40, 0);
    bezierVertex(-leafSize/4, -leafSize*0.175, leafSize/10, -leafSize + leafSize*0.1753, leafSize/10, -leafSize);
    bezierVertex(leafSize/10, -leafSize, leafSize*0.425, -leafSize/10, 0, 0);
    endShape();

    //left side
    fill(leafColor);
    beginShape();
    vertex(-leafSize/40, 0);
    bezierVertex(-leafSize/4, -leafSize*0.175, leafSize/10, -leafSize+leafSize*0.175, leafSize/10, -leafSize);
    bezierVertex(leafSize/10, -leafSize, leafSize*0.14, -leafSize/8, -leafSize/40, 0);
    endShape();

    //right side
    fill(leafColor);
    beginShape();
    vertex(leafSize/10, -leafSize);
    bezierVertex(leafSize/10, -leafSize, leafSize*0.425, -leafSize/10, 0, 0);
    bezierVertex(0, 0, leafSize*0.175, -leafSize/20, leafSize/10, -leafSize);
    endShape();

    popMatrix();
  }

  void growAnimation() {
    //update the grow animation
    if (growAnimation > 0) growAnimation--;
    leafSize = maxLeafSize * (1 - growAnimation / ANIMATION_TIME);
  }
}
