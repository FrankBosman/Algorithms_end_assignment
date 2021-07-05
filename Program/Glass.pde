
/*  -- Glass Class --
 *  This Class displays the glass.
 *  and it handles the surface which can be changed by throwing water on it
 */

class Glass {
  static final int GLASS_HEIGHT = 200;
  static final int GLASS_WIDTH = 75;
  static final int STROKE_WEIGHT = 5;

  PVector position;
  Surface surface;

  PImage tulipImage;

  Glass(PVector position, PImage tulipImage) {
    this.position = position.add(0, -GLASS_HEIGHT/2 - STROKE_WEIGHT/2); //move the pos coordinate so the glass sits on the given coordinate
    this.tulipImage = tulipImage;
    surface = new Surface(PVector.add(position, new PVector(-GLASS_WIDTH/2 + STROKE_WEIGHT/2, -STROKE_WEIGHT/2)), GLASS_WIDTH - STROKE_WEIGHT, GLASS_HEIGHT/2, 2, GLASS_HEIGHT/2 - STROKE_WEIGHT); //creates the surface that handles the water
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);

    //tulip
    pushMatrix();
    rotate(PI/12);  
    image(tulipImage, 0, -tulipImage.height/3);
    rotate(-PI/8);  
    image(tulipImage, 0, -tulipImage.height/3);
    popMatrix();
    popMatrix();
    //water
    surface.display();
    pushMatrix();
    translate(position.x, position.y);
    strokeWeight(STROKE_WEIGHT);
    stroke(174, 232, 240);    //light blue
    fill(174, 232, 240, 100); //light blue
    rect(0, 0, GLASS_WIDTH, GLASS_HEIGHT, 5, 5, 10, 10);

    popMatrix();
    //reset strokeWeight
    strokeWeight(1);
  }

  void update() {
    surface.update();
  }

  void collide(Particle particle) {
    //test if the particle hit the glass
    PVector posIn = particle.getPos();
    if (posIn.y >= position.y - GLASS_HEIGHT/2 && posIn.y <= position.y + GLASS_HEIGHT/2 && //test the Y coords
      ((posIn.x >= position.x - GLASS_WIDTH/2 - STROKE_WEIGHT*3 && posIn.x <= position.x - GLASS_WIDTH/2 + STROKE_WEIGHT*3) || //test the x coords of the left wall
      (posIn.x >= position.x + GLASS_WIDTH/2 - STROKE_WEIGHT*3 && posIn.x <= position.x + GLASS_WIDTH/2 + STROKE_WEIGHT*3))) {  //test the x coords of the right wall
      particle.velocity.x *= -1;
    }
  }

  boolean addForceToSurface(float x, float y, int dist, float multiplier) {
    return surface.addAreaForce(x, y, dist, multiplier);
  }
}
