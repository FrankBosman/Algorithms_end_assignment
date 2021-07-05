class GlassWater {

  PVector position;

  GlassWater(PVector position) {
    this.position = position;
  }

  void display() {

    pushMatrix();
    translate(position.x, position.y);
    noStroke();

    fill(174, 232, 254);
    rect(0, 0, 100, 200, 8, 8, 10, 10);

    fill(174, 232, 254, 127);
    rect(0, -5, 80, 180, 5, 5, 20, 20);

    popMatrix();
  }
}
