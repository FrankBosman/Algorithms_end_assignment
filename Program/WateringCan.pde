class WateringCan {
  static final float NOZZLE_WIDTH = 54.45;
  

  //movement
  PVector velocity;
  float gravity;
  PVector position; 
  PVector startPosition;
  boolean isSelected;
  boolean isOutside;
  Windows windows;

  //display
  PImage wateringCanImage;

  //watering
  float angle;
  float rotationSpeed;
  boolean isWatering;
  ParticleSystem waterParticleSystem;

  float windowSillHeight;
  float positionOffSetX;
  float positionOffSetY;
  PVector nozzlePosition;
  PVector nozzleDirection;

  WateringCan(PVector position, ParticleSystem waterParticleSystem, PImage wateringCanImage, Windows windows) {
    this.position = position;
    this.waterParticleSystem = waterParticleSystem;
    this.wateringCanImage = wateringCanImage;
    this.windows = windows;

    //movement
    windowSillHeight = height*7/8 + 30;
    startPosition = new PVector(width*3/4 + wateringCanImage.height/2, windowSillHeight - wateringCanImage.height/2 - 60);
    velocity = new PVector(0, 0);
    gravity = 0.1;
    isSelected = false;

    //watering
    isWatering = false;
    angle = 0;
    rotationSpeed = 0.025;

    positionOffSetX = -90;
    positionOffSetY = 60;

    nozzleDirection = PVector.fromAngle(radians(165)).setMag(20);
    nozzlePosition = new PVector(-60 + nozzleDirection.x, 160 + nozzleDirection.y);
  }

  //draws the watering can
  void display() {
    //adds particles to the watering can
    if (isWatering) {
      waterParticleSystem.addParticle(PVector.add(nozzlePosition, position), nozzleDirection.copy(), NOZZLE_WIDTH);
    }
    
    //watering can
    pushMatrix();
    translate(position.x, position.y);
    if(isOutside) scale(0.9);
    rotate(angle);   
    image(wateringCanImage, positionOffSetX, positionOffSetY);
    popMatrix();   
  }

  //updates the watering can
  void update() {
    if ((!isSelected && !isOnWindowSill())) { //if the watering can is not selected and also not on the window sill gravity will be added
      velocity.y += gravity;
      if (position.y > height + wateringCanImage.height) {//once the watering can is outside the screen make it fall back in
        isOutside = false;
        position = new PVector(startPosition.x, -wateringCanImage.height); 
      }
    }

    if (isOnWindowSill() && !isSelected) position.y = startPosition.y; //sets position to the height of the window sill

    if (isOnWindowSill() || isSelected) velocity.y = 0; //sets velocity to 0

    rotateWateringCan();

    position.add(velocity);

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

      isOutside = isInsideWindow();
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

    if(isOutside) return false;
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
      position.x + wateringCanImage.width/2 + positionOffSetX < windows.getPosWindowLeft() &&
      position.y + wateringCanImage.height/2 + positionOffSetY <  800 &&
      position.y - wateringCanImage.height/2 + positionOffSetY > 120;
  }

  boolean isOutside(){
    return isOutside;
  }
}
