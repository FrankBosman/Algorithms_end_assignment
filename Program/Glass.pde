class Glass {

  PVector position;

  Glass(PVector position) {
    this.position = position;
  }

  void display() {

    pushMatrix();
    translate(position.x, position.y);

    strokeWeight(5);
    stroke(174, 232, 254);
    noFill();
    rect(0, 0, 50, 100, 5, 5, 10, 10);

    noStroke();
    fill(174, 232, 254, 127);
    rect(0, 0, 50, 100, 5, 5, 10, 10);
    popMatrix();
    
    //reset strokeWeight
    strokeWeight(1);
  }
}
