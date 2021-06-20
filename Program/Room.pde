/*  -- Room Class --
 *  this class handels all objects inside the room and the interactions between them 
 */
class Room {

  Plant plant;
  ParticleSystem particleSystem;
  WateringCan wateringCan;
  Glass glass;
  Windows windows;

  PVector position;
  PImage[] flowerImages = new PImage[5];

  float windowSillHeight;
  PImage wateringCanImage;
  
  Room(PVector position) {
    this.position = position;

    windowSillHeight = height*7/8 + 30;
    for (int i = 0; i < flowerImages.length; i ++) {
      flowerImages[i] = loadImage("flower" + i + ".png");
      flowerImages[i].resize(100, 0);
    }

    windows = new Windows(new PVector(-width/4 - 20, 0),  position);
    plant = new Plant(width/2, height*3/4 + 60, 1, flowerImages, windows);
    
    glass = new Glass(new PVector(width*5/8, windowSillHeight));
    particleSystem = new ParticleSystem(new PVector(position.x, windowSillHeight), width*3/4 + 150, plant, glass);

    wateringCanImage = loadImage("wateringCan.png");
    wateringCanImage.resize(0, 160);

    wateringCan = new WateringCan(new PVector(width*3/4 + wateringCanImage.height/2, windowSillHeight - wateringCanImage.height/2 - 60), particleSystem, wateringCanImage, windows);
  }

  void display() {
    

    if (wateringCan.isOutside()) wateringCan.display();
    drawBackground();
    windows.display();
    plant.display();
    particleSystem.display();
    glass.display();
    if (!wateringCan.isOutside()) wateringCan.display();

  }

  void update(){
    plant.update();
    particleSystem.update();
    wateringCan.update();
  }

  void clicked(float x, float y) {
    windows.selectWindow(x, y);
    wateringCan.selectWateringCan(x, y);
  }

  void dragged(float x, float px, float y, float py) {
    windows.moveWindow(x - px);
    wateringCan.moveWateringCan(x - px, y - py);
  }

  void released() {
    windows.releaseWindow();
    wateringCan.releaseWateringCan();
  }
  
  void drawBackground(){
    pushMatrix();
    translate(position.x, position.y);
    rectMode(CENTER);
    
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

    //windowsill
    strokeWeight(20);
    stroke(191);
    rect(0, height*3/8 + 50, width*3/4 + 150, 20);    

    //reset strokeWeight
    strokeWeight(1);
    popMatrix();
  }
}
