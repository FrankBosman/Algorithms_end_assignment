class WateringCan {

  PVector position; 
  PVector startPosition;

  PVector velocity;
  float gravity;
  PImage wateringCanImage;

  float angle;
  float rotationSpeed;

  boolean isSelected;
  boolean isWatering;

  ParticleSystem water;

  float windowSillHeight;
  float positionOffSetX;
  float positionOffSetY;

  Plant plant;

  boolean windowIsOpen;

  WateringCan(PVector position, ParticleSystem water, PImage wateringCanImage, Plant plant) {
    this.plant = plant;
    this.wateringCanImage = wateringCanImage;
    windowSillHeight = height*7/8 + 30;
    startPosition = new PVector(width*3/4 + wateringCanImage.height/2, windowSillHeight - wateringCanImage.height/2 - 60);
    this.position = position;
    velocity = new PVector(0, 0);
    gravity = 0.1;
    isSelected = false;
    isWatering = false;
    this.water = water;

    angle = 0;
    rotationSpeed = 0.025;

    positionOffSetX = -90;
    positionOffSetY = 60;
  }

  //draws the watering can
  void display() {
    //adds particles to the watering can
    if (isWatering) {
      water.addParticle(new PVector(position.x - 60, position.y + 160), PVector.fromAngle(radians(165)));
      plant.grow();
    }
    //println(-60 + degrees(PI) + degrees(HALF_PI/2));
    
    //watering can
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);   
    image(wateringCanImage, positionOffSetX, positionOffSetY);
    //stroke(0);
    //line(-120 + positionOffSetX, -71 + positionOffSetY, -81 + positionOffSetX, -32 + positionOffSetY);
    popMatrix();
  }

  //updates the watering can
  void update(boolean windowIsOpen) {
    if ((!isSelected && !isOnWindowSill())) { //if the watering can is not selected and also not on the window sill gravity will be added
      velocity.y += gravity;
      if (position.y > height + wateringCanImage.height) position = new PVector(startPosition.x, -wateringCanImage.height); //once the watering can is outside the screen a new position will be given
    }

    if (isOnWindowSill() && !isSelected) position.y = startPosition.y; //sets position to the height of the window sill

    if (isOnWindowSill() || isSelected) velocity.y = 0; //sets velocity to 0

    rotateWateringCan();

    position.add(velocity);

    this.windowIsOpen = windowIsOpen;
  }

  //selects the watering can
  void selectWateringCan(float x, float y) {
    if (isOverWateringCan(x, y)) isSelected = true;
  }

  //moves the watering can
  void moveWateringCan(float deltaX, float deltaY) {
    if (isSelected) {
      PVector deltaPosition = new PVector(deltaX, deltaY);
      position.add(deltaPosition);

      //position = new PVector(x, y);

      // position.x += x - px;
      // if (y > height*7/8 + 30 - 80 &&
      //   x > width/8 - 85 - wateringCanImage.width/2 + 37 &&
      //   x < width*7/8 + 85 + wateringCanImage.width/2 - 92) {
      //   position.y += y - py;
      // }
    }
  }

  //releases the watering can
  void releaseWateringCan() {
    isSelected = false;
  }

  //rotates the watering can if it is near the plant
  void rotateWateringCan() {
    float minRotation = 0;
    float maxRotation = radians(-60);

    if (nearPlant() && isSelected) {
      angle -= rotationSpeed;
      if (angle < maxRotation) angle = maxRotation;
    } else if (!isSelected) {
      angle += rotationSpeed * 2;
      if (angle > minRotation) angle = minRotation;
    } 

    if (angle == maxRotation) isWatering = true;
    else isWatering = false;

    //if (abovePlant() && isSelected) {
    //  if (angle > maxRotation) angle -= rotationSpeed;
    //  else isWatering = true;
    //} else if ((!abovePlant() || !isSelected) && angle < minRotation) {
    //  angle += rotationSpeed * 2;
    //  isWatering = false;
    //}
  }

  //checks if the watering can is standing on the window sill
  boolean isOnWindowSill() {
    //if the window is open and the watering can is placed inside the left window
    //the watering can will be plased outside so it is not on the window sill
    if (isInsideWindow() && windowIsOpen) return false; 
    else {
      return  position.x - 9 > width/8 - 85 &&
        position.x - 119 < width*7/8 + 85 &&
        position.y >= startPosition.y;
    }
  }

  //checks if the mouse is on the watering can
  boolean isOverWateringCan(float x, float y) {
    return (x > position.x - wateringCanImage.width/2 + positionOffSetX && 
      x < position.x + wateringCanImage.width/2 + positionOffSetX && 
      y > position.y - wateringCanImage.height/2 + positionOffSetY && 
      y < position.y + wateringCanImage.height/2 + positionOffSetY);
  }

  //checks if the watering can is near the plant
  boolean nearPlant() {
    return position.x > width*3/8 + wateringCanImage.width/2 &&
      position.x < width*5/8 + wateringCanImage.width/4 &&
      position.y > height/8 &&
      position.y < height*5/8;
  }

  //checks if the watering can is inside the left window
  boolean isInsideWindow() {
    return position.x - wateringCanImage.width/2 + positionOffSetX > width/8 - 10 &&
      position.x + wateringCanImage.width/2 + positionOffSetX < width*3/8 - 50;
  }
}
