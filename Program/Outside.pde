class Outside {//this class handels all objects Outside the room and the interactions between them 

  Flock flock;
  PImage landscape;
  PImage[] birdAnimation = new PImage[9];

  Outside() {

    //loads the images
    landscape = loadImage("landscape2.png");
    landscape.resize(width*7/8, 0);
    
    for(int i = 1; i <= 9; i++){
      birdAnimation[i-1] = loadImage("Birds/Bird_0" + i +".png");
    }

    //create the flock
    flock = new Flock(75, birdAnimation);
  }

  void display() {
    drawBackground();
    flock.display();
  }

  void update() {
    flock.update();
  }

  void drawBackground() {
    image(landscape, width/2, height/2);
  }
}
