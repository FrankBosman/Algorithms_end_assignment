
/*  -- Flower Class --
 *  This Class displays the flower and manages the growing animation 
 */

class Flower extends PlantSegment {
  static final float ANIMATION_TIME = 100;
  float flowerSize;
  float maxFlowerSize;
  int cooldown;

  PImage flowerImage;

  Flower(float segmentLength, PlantSegment segmentBellow, float offsetAngle, PImage flowerImage) {
    super(segmentLength, segmentBellow, offsetAngle, int(ANIMATION_TIME));
    flowerSize = 0;
    maxFlowerSize = segmentLength*10;
    cooldown = growTime;

    this.flowerImage = flowerImage;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(totalAngle);

    image(flowerImage, 0, 0, flowerImage.width * flowerSize, flowerImage.height * flowerSize);
    popMatrix();
  }

  void growAnimation() {
    //update the grow animation
    if (growAnimation > 0) growAnimation--;
    if (growAnimation <= ANIMATION_TIME) {
      flowerSize = (1 - growAnimation / ANIMATION_TIME);
    }
  }
}
