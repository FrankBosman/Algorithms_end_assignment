
/*  -- Leaf Class --
 *  This Class displays the leaf and manages the growing animation 
 */

class Leaf extends PlantSegment {
  static final float ANIMATION_TIME = 500;
  float leafSize;
  float maxLeafSize;
  color leafColor;
  color[] leafColors = new color[4];
  int cooldown;

  Leaf(float segmentLength, PlantSegment segmentBellow, float offsetAngle) {
    super(segmentLength, segmentBellow, offsetAngle, int(ANIMATION_TIME));
    leafSize = 0;
    maxLeafSize = segmentLength*10;
    for (int i = 2; i < 10; i += 2) {
      leafColors[-1 + i/2] = color (110 + i*2, 140 + i*6, 20 + i*4);
    }
    //leafColors[0] = color(102, 143, 30);
    //leafColors[1] = color(132, 193, 36);
    //leafColors[2] = color(141, 206, 38);
    //leafColors[3] = color(115, 168, 31);
    leafColor = leafColors[int(random(leafColors.length))];
    cooldown = growTime;
  }

  void display() {
    println(red(leafColors[0]), green(leafColors[0]), blue(leafColors[0]));
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
