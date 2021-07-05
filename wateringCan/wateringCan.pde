PImage can;

void setup() {
  //size(240, 160);
  size(500, 500);
  imageMode(CENTER);
  can = loadImage("wateringCan.png");
  can.resize(0, 160);
}

void draw() {
  pushMatrix();
  translate(width/2 + 90, height/2 - 60);
  //rotate(radians(-60));
  image(can, -90, 60);
  popMatrix();
}

void mousePressed() {
  //println(mouseX - width/2, mouseY - height/2);
  //println(mouseX, mouseY);
  println(-width/2 - 90 + mouseX, -height/2 + 60 + mouseY);
}
