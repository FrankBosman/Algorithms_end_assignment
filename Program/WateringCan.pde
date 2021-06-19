class WateringCan {

    PVector position;
    PImage wateringCanImage;

    boolean isSelected;

    WateringCan(PVector position) {
        this.position = position;
        wateringCanImage = loadImage("wateringCan.png");
        wateringCanImage.resize(0, 160);
        isSelected = false;
        
    }

    void display() {
        pushMatrix();
        translate(position.x, position.y);
        image(wateringCanImage, 0, 0);
        popMatrix();
    }

    void update() {

    }

    boolean isOverHandle(float x, float y) {
    return (x > position.x - wateringCanImage.width/2 && 
      x < position.x + wateringCanImage.width/2 && 
      y > position.y - wateringCanImage.height/2 && 
      y < position.y + wateringCanImage.height/2);
  }

    void selectWateringCan(float x, float y) {
        if (isOverHandle(x, y)) isSelected = true;
    }

    void moveWateringCan(float deltaX, float deltaY) {
        if (isSelected) {
            position.x += deltaX;
            position.y += deltaY;
            if(position.y > height*7/8 + 30 - 80 &&
            position.x > width*3/4 + 140 - wateringCanImage.width/2 &&
            position.x < width*3/4 + 160 + wateringCanImage.width/2) {
                position.y = height*7/8 + 30 - 80;
            }
        }
    }

    void releaseWateringCan() {
        isSelected = false;
        position.y += 10;
        if(position.y > height*7/8 + 30 - 80 &&
        position.x > width*3/4 + 140 - wateringCanImage.width/2 &&
        position.x < width*3/4 + 160 + wateringCanImage.width/2) {
            position.y = height*7/8 + 30 - 80;
        }

        if(position.y > height + wateringCanImage.height/2) {
            position.x = width*3/4;
            position.y = -wateringCanImage.height/2;            
            position.y -= 1;
        }

    }
}