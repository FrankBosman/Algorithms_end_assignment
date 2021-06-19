class Inside {//this class handels all objects inside the room and the interactions between them 
  Plant plant;
  Room room;
  ParticleSystem particleSystem;

  WateringCan wateringCan;

  PImage[] flowerImages = new PImage[5];

  Inside() {
    for (int i = 0; i < flowerImages.length; i ++) {
      flowerImages[i] = loadImage("flower" + i + ".png");
      flowerImages[i].resize(100, 0);
    }
    plant = new Plant(width/2, height*3/4 + 60, 1, flowerImages);
    room = new Room(new PVector(width/2, height/2));
    particleSystem = new ParticleSystem();
    wateringCan = new WateringCan(new PVector(width*3/4, height*7/8 + 30 - 80), particleSystem);
  }

  void display() {
    room.display();
    plant.display();
    particleSystem.display();
    wateringCan.display();
  }

  void update() {
    plant.update();
    particleSystem.update();
    wateringCan.update();
  }

  void drawBackground() {
  }

  void clicked(float x, float y) {
    room.selectWindow(x, y);
    wateringCan.selectWateringCan(x, y);
  }

  void dragged(float x, float px, float y, float py) {
    room.moveWindow(x - px);
    wateringCan.moveWateringCan(x, px, y, py);
  }

  void released() {
    room.releaseWindow();
    wateringCan.releaseWateringCan();
  }
}
