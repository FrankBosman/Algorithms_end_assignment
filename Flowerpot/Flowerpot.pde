

void setup() {
  size(500, 500);
  rectMode(CENTER);
}

void draw() {
  pushMatrix();
  translate(width/2, height/2);
  noStroke();
  fill(202, 114, 2);
  rect(0, 50, 50, 10, 5, 5, 5, 5);
  fill(255, 160, 1);
  arc(0, 0, 100, 100, -QUARTER_PI - radians(10), PI+QUARTER_PI + radians(10), CHORD);
  stroke(0);
  fill(0);
  beginShape();
  vertex(cos(PI+QUARTER_PI - radians(10))*50, sin(PI+QUARTER_PI - radians(10))*50);
  vertex(cos(PI+QUARTER_PI - radians(10) + 10)*50, sin(PI+QUARTER_PI - radians(10))*50);
  curveVertex(cos(PI+QUARTER_PI - radians(10) - 10)*50/2, sin(PI+QUARTER_PI - radians(10))*50/2);
  vertex(cos(HALF_PI)*50, sin(HALF_PI)*50);
  curveVertex(cos(PI+QUARTER_PI - radians(10))*50/2, sin(PI+QUARTER_PI - radians(10))*50/2);
  vertex(cos(PI)*50, sin(PI)*50);
  endShape(CLOSE);
  //arc(0, 0, 80, 80, 0, PI+QUARTER_PI, OPEN);
  popMatrix();
}

void mousePressed() {
  println(mouseX - width/2, mouseY - height/2);
}
