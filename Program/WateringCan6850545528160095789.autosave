class WateringCan {

  PVector position;
  PVector velocity;
  float gravity;
  PImage wateringCanImage;

  float angle;
  float rotationSpeed;

  boolean isSelected;
  boolean isWatering;

  ParticleSystem water;

  WateringCan(PVector position, ParticleSystem water) {
    wateringCanImage = loadImage("wateringCan.png");
    wateringCanImage.resize(0, 160);
    this.position = position;
    velocity = new PVector(0, 0);
    gravity = 0.5;
    isSelected = false;
    isWatering = false;
    this.water = water;
    angle = 0;
    rotationSpeed = 0.025;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    stroke(0);
    image(wateringCanImage, 0, 0);
    line(-120, -71, -81, -32);
    popMatrix();

    fill(0, 0);
    rect(width/2, height/2, width/4 + 20, height*3/4 + 60);

    waterPlants();
  }

  void update() {
    if (!isSelected && !isOnWindowSill()) {
      velocity.y += gravity;
      if (position.y > height + wateringCanImage.height/2) position = new PVector(width*3/4, wateringCanImage.height/2);
      position.add(velocity);
    }
    if (isOnWindowSill()) position.y = height*7/8 + 30 - 80;

    if (isOnWindowSill() || isSelected) velocity.y = 0;

    rotateWateringCan();
  }

  boolean isOnWindowSill() {
    return position.y > height*7/8 + 30 - 80 &&
      position.x > width/8 - 85 - wateringCanImage.width/2 + 37 &&
      position.x < width*7/8 + 85 + wateringCanImage.width/2 - 92;
  }

  boolean isOverHandle(float x, float y) {
    return (x > position.x - wateringCanImage.width/2 && 
      x < position.x + wateringCanImage.width/2 && 
      y > position.y - wateringCanImage.height/2 && 
      y < position.y + wateringCanImage.height/2);
  }

  boolean abovePlant() {
    return position.x > width*3/8 - 10 &&
      position.x < width*5/8 + 10 &&
      position.y > height/8 - 30 &&
      position.y < height*7/8 + 30;
  }

  void selectWateringCan(float x, float y) {
    if (isOverHandle(x, y)) isSelected = true;
  }

  void moveWateringCan(float x, float px, float y, float py) {
    if (isSelected) {
      position.x += x - px;
      if (y > height*7/8 + 30 - 80 &&
        x > width/8 - 85 - wateringCanImage.width/2 + 37 &&
        x < width*7/8 + 85 + wateringCanImage.width/2 - 92) {
        y += y - py;
      }

      if (isOnWindowSill()) position.y = height*7/8 + 30 - 80;
    }
  }

  void rotateWateringCan() {
    if (abovePlant() && isSelected) {
      if (angle > radians(-60)) angle -= rotationSpeed;
      else isWatering = true;
      
    } else if ((!abovePlant() || !isSelected) && angle < 0) {
      angle += rotationSpeed * 2;
      isWatering = false;
    }
  }

  void waterPlants() {
    if (isWatering) water.addParticle(new PVector(position.x - 81, position.y - 32));
  }

  void releaseWateringCan() {
    isSelected = false;
  }
}
