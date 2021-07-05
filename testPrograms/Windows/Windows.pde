
Window window;
Plant plant;

Flock flock;

PImage leliepad;
PImage[] birdImages = new PImage[4];
PImage birdImage;

int amount = 100;


void setup() {
  size(1800, 900);
  rectMode(CENTER);
  imageMode(CENTER);
  window = new Window(new PVector(width/2, height/2));
  plant = new Plant(new PVector(width/2, height*3/4 + 60));

  flock = new Flock();

  for (int i = 0; i < birdImages.length; i++) {
    birdImages[i] = loadImage("bird" + i + ".png");
    birdImages[i].resize(0, 50);
  }

  for (int i = 0; i < amount; i++) {
    birdImage = birdImages[int(random(birdImages.length))];
    flock.addBird(new Bird(new PVector(random(width), random(height)), birdImage));
  }
}

void draw() {
  background(93, 203, 207);
  //flock.run();

  window.display();
  plant.display();
}

void mousePressed() {
  println(mouseX - width/2, mouseY - height/2);
  window.selectWindow(mouseX, mouseY);
}

void mouseDragged() {
  window.moveWindow(mouseX-pmouseX);
}

void mouseReleased() {
  window.releaseWindow();
}
