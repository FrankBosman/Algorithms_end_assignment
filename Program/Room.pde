class Room {

  PVector position;
  PVector positionLeftWindow;
  boolean isSelected;

  Room(PVector position) {
    this.position = position;
    positionLeftWindow = new PVector(-width/4 - 20, 0);
    isSelected = false;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);



    //wall
    strokeWeight(width/8);
    stroke(195, 166, 142);
    fill(0, 0);
    rect(0, 0, width*7/8 + 100, height*7/8 + 135);



    //frame
    strokeWeight(20);
    stroke(255);
    fill(0, 0);
    rect(0, 0, width*3/4 + 80, height*3/4 + 40);



    //window left
    pushMatrix();
    translate(positionLeftWindow.x, positionLeftWindow.y);

    strokeWeight(20);
    stroke(223);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //noStroke();
    //fill(227, 246, 250, 191);
    //beginShape();
    //vertex(-width/8 + 10, 50);
    //vertex(-width/8 + 10, 100);
    //vertex(width/8 - 10, -150);
    //vertex(width/8 - 10, -200);
    //endShape();

    //beginShape();
    //vertex(-width/8 + 10, 150);
    //vertex(-width/8 + 10, 250);
    //vertex(width/8 - 10, 0);
    //vertex(width/8 - 10, -100);
    //endShape();

    //handle
    strokeWeight(7);
    stroke(63);
    line(-width/8, -50, -width/8, 50);
    popMatrix();



    //window center
    pushMatrix();
    translate(0, 0);

    strokeWeight(20);
    stroke(255);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //noStroke();
    //fill(227, 246, 250, 191);
    //beginShape();
    //vertex(-width/8 + 10, -220);
    //vertex(-width/8 + 10, -170);
    //vertex(width/8 - 10, -420);
    //vertex(width/8 - 10, -470);
    //endShape();

    //beginShape();
    //vertex(-width/8 + 10, -120);
    //vertex(-width/8 + 10, -20);
    //vertex(width/8 - 10, -270);
    //vertex(width/8 - 10, -height*3/8 + 10);
    //vertex(140, -height*3/8 + 10);
    //endShape();
    popMatrix();



    //window right
    pushMatrix();
    translate(width/4 + 20, 0);

    strokeWeight(20);
    stroke(255);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //noStroke();
    //fill(227, 246, 250, 191);
    //beginShape();
    //vertex(-width/8 + 10, 50);
    //vertex(-width/8 + 10, 100);
    //vertex(width/8 - 10, -150);
    //vertex(width/8 - 10, -200);
    //endShape();

    //beginShape();
    //vertex(-width/8 + 10, 150);
    //vertex(-width/8 + 10, 250);
    //vertex(width/8 - 10, 0);
    //vertex(width/8 - 10, -100);
    //endShape();
    popMatrix();



    //windowsill
    strokeWeight(20);
    stroke(191);
    rect(0, height*3/8 + 50, width*3/4 + 150, 20);    



    //reste strokeWeight
    strokeWeight(1);
    popMatrix();
  }

  boolean isOverHandle(float x, float y) {
    return (x > position.x + positionLeftWindow.x - width/8 - 7 && 
      x < position.x + positionLeftWindow.x - width/8 + 7 && 
      y > position.y + positionLeftWindow.y - 55 && 
      y < position.y + positionLeftWindow.y + 55);
  }

  void selectWindow(float x, float y) {
    if (isOverHandle(x, y)) isSelected = true;
  }

  void moveWindow(float delta) {
    if (isSelected) {
      positionLeftWindow.x += delta;
      if (positionLeftWindow.x > -40) positionLeftWindow.x = -40;
      if (positionLeftWindow.x < -width/4 - 20) positionLeftWindow.x = -width/4 - 20;
    }
  }

  void releaseWindow() {
    isSelected = false;
  }
}
