Outside outside;
Room room;

void setup() {
  //fullScreen();
  size(1800, 900, P2D);
  rectMode(CENTER);
  imageMode(CENTER);
  room = new Room(new PVector(width/2, height/2));

  outside = new Outside();
}

void draw() {
  background(100);
  outside.display();
  outside.update();

  room.display();
  room.update();

  fill(0);
  text(frameRate, 5, 20);
}

void mousePressed() {
  room.clicked(mouseX, mouseY);
  println(mouseX, mouseY);
}

void mouseDragged() {
  room.dragged(mouseX, pmouseX, mouseY, pmouseY);
}

void mouseReleased() {
  room.released();
}
