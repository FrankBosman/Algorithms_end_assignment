class Plant {

  PVector position;
  color flowerPotColor;

  Plant(PVector position) {
    this.position = position;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);

    //flower pot
    noStroke();
    fill(155, 83, 0);
    beginShape();
    vertex(-40, height/8 - 30);
    vertex(-60, 0);
    vertex(0, 0);
    vertex(0, height/8 - 30);
    endShape();

    fill(144, 76, 1);
    beginShape();
    vertex(0, height/8 - 30);
    vertex(0, 0);
    vertex(60, 0);
    vertex(40, height/8 - 30);
    endShape();

    rectMode(CORNER);
    fill(180, 105, 22);
    rect(-75, -30, 75, 30, 4, 0, 0, 4);
    
    fill(164, 97, 19);
    rect(0, -30, 75, 30, 0, 4, 4, 0);
    rectMode(CENTER);
    popMatrix();
  }
}
