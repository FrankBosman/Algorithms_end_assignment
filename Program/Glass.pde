class Glass {
  static final int GLASS_HEIGHT = 200;
  static final int GLASS_WIDTH = 75;
  static final int STROKE_WEIGHT = 5;

  PVector position;
  Surface surface;

  Glass(PVector position) {
    this.position = position.sub(0, GLASS_HEIGHT/2); //move the pos coordinate so the glass sits on the given coordinate
    surface = new Surface(PVector.add(position, new PVector(-GLASS_WIDTH/2 + STROKE_WEIGHT/2, -STROKE_WEIGHT)), GLASS_WIDTH - STROKE_WEIGHT, GLASS_HEIGHT/2, 10);
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);

    strokeWeight(STROKE_WEIGHT);
    stroke(174, 232, 240);
    fill(174, 232, 240, 127);
    rect(0, 0, GLASS_WIDTH, GLASS_HEIGHT, 5, 5, 10, 10);

    popMatrix();
    //reset strokeWeight
    strokeWeight(1);

    surface.update();
    surface.display();
  }
}
