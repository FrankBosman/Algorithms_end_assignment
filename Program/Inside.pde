// class Inside {//this class handels all objects inside the room and the interactions between them 
//   Plant plant;
//   Room room;
//   ParticleSystem particleSystem;
//   WateringCan wateringCan;
//   Glass glass;

//   PImage[] flowerImages = new PImage[5];

//   float windowSillHeight;
//   PImage wateringCanImage;

//   Inside() {
//     windowSillHeight = height*7/8 + 30;
//     for (int i = 0; i < flowerImages.length; i ++) {
//       flowerImages[i] = loadImage("flower" + i + ".png");
//       flowerImages[i].resize(100, 0);
//     }
//     plant = new Plant(width/2, height*3/4 + 60, 1, flowerImages);
//     room = new Room(new PVector(width/2, height/2));
//     particleSystem = new ParticleSystem();
//     glass = new Glass(new PVector(width*5/8, windowSillHeight - 52.5));



//     wateringCanImage = loadImage("wateringCan.png");
//     wateringCanImage.resize(0, 160);

//     wateringCan = new WateringCan(new PVector(width*3/4 + wateringCanImage.height/2, windowSillHeight - wateringCanImage.height/2 - 60), particleSystem, wateringCanImage, plant);
//   }

//   void display() {
//     if (room.windowIsOpen() && wateringCan.isInsideWindow()) wateringCan.display();
//     room.display();
//     plant.display();
//     particleSystem.display();
//     glass.display();
//     if (!room.windowIsOpen() || !wateringCan.isInsideWindow()) wateringCan.display();
//   }

//   void update() {
//     plant.update();
//     particleSystem.update();
//     wateringCan.update(room.windowIsOpen());
//   }

//   void clicked(float x, float y) {
//     room.selectWindow(x, y);
//     wateringCan.selectWateringCan(x, y);
//   }

//   void dragged(float x, float px, float y, float py) {
//     room.moveWindow(x - px);
//     wateringCan.moveWateringCan(x - px, y - py);
//   }

//   void released() {
//     room.releaseWindow();
//     wateringCan.releaseWateringCan();
//   }
// }
