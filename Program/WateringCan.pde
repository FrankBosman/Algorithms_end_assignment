
/*  -- WateringCan Class --
 *  This Class displays and manages the watering can.
 *  It handles the interaction with the user.
 */

class WateringCan {
  static final float NOZZLE_WIDTH = 54.45;
  static final float MIN_ROTATION = 0;
  static final float MAX_ROTATION = -PI/3;

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

  void display() { //draws the watering can
    //adds particles to the watering can
    if (isWatering) {
      waterParticleSystem.addParticle(PVector.add(nozzlePosition, position), nozzleDirection.copy(), NOZZLE_WIDTH);
    }

    //watering can
    pushMatrix();
    translate(position.x, position.y);
    if (isOutside) scale(0.9);
    rotate(angle);   
    image(wateringCanImage, positionOffSetX, positionOffSetY);
    popMatrix();
  }

  void update() { //updates the watering can
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

  void selectWateringCan(float x, float y) { //selects the watering can
    if (isOverWateringCan(x, y)) isSelected = true;
  }

  void moveWateringCan(float deltaX, float deltaY) { //moves the watering can
    if (isSelected) {
      PVector deltaPosition = new PVector(deltaX, deltaY);
      position.add(deltaPosition);

      isOutside = isInsideWindow();
    }
  }

  void releaseWateringCan() { //releases the watering can
    isSelected = false;
  }

  void rotateWateringCan() { //rotates the watering can back if released
    if (!isSelected) {
      angle += rotationSpeed * 2;
      if (angle > MIN_ROTATION) angle = MIN_ROTATION;
    } 

    if (angle == MAX_ROTATION) isWatering = true;
    else isWatering = false;

    if (angle < MAX_ROTATION) angle = MAX_ROTATION;
    if (angle > MIN_ROTATION) angle = MIN_ROTATION;
  }

  void rotateWateringCanScroll(float scroll) {
    angle -= scroll * 0.1;
  }

  boolean isOnWindowSill() {//checks if the watering can is standing on the window sill
    //if the window is open and the watering can is placed inside the left window
    //the watering can will be plased outside so it is not on the window sill

    if (isOutside) return false;
    else {
      return  position.x - 9 > width/8 - 85 &&
        position.x - 119 < width*7/8 + 85 &&
        position.y >= startPosition.y;
    }
  }

  boolean isOverWateringCan(float x, float y) { //checks if the mouse is on the watering can
    return (x > position.x - wateringCanImage.width/2 + positionOffSetX && 
      x < position.x + wateringCanImage.width/2 + positionOffSetX && 
      y > position.y - wateringCanImage.height/2 + positionOffSetY && 
      y < position.y + wateringCanImage.height/2 + positionOffSetY);
  }

  boolean isInsideWindow() { //checks if the watering can is inside the left window
    return position.x - wateringCanImage.width/2 + positionOffSetX > width/8 - 10 &&
      position.x + wateringCanImage.width/2 + positionOffSetX < windows.getPosWindowLeft() &&
      position.y + wateringCanImage.height/2 + positionOffSetY <  800 &&
      position.y - wateringCanImage.height/2 + positionOffSetY > 120;
  }

  boolean isOutside() { //checks if the watering can is outside (the window)
    return isOutside;
  }
}
