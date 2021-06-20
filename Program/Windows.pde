
/*  -- Windows Class --
 *  This Class displays the windows and manages the left window.
 *  It handles the interaction with the left window.
 */

class Windows {

  PVector position;
  PVector positionLeftWindow;
  
  boolean isSelected;

  Windows(PVector positionLeftWindow, PVector position) {
    this.positionLeftWindow = positionLeftWindow;
    this.position = position;
    isSelected = false;
  }

  void display() {
    //drawing of all the windows
    pushMatrix();
    translate(position.x, position.y);

    //window left
    pushMatrix();
    translate(positionLeftWindow.x, positionLeftWindow.y);    

    //strokes over the window
    pushMatrix();
    translate(-positionLeftWindow.x, -positionLeftWindow.y);
    noStroke();
    fill(227, 246, 250, 63);
    //stroke 1
    beginShape();
    vertex(positionLeftWindow.x + 10 - width/8, 50 - (1 - (positionLeftWindow.x + 20)/(-width/4 - 20))*250);
    vertex(positionLeftWindow.x + 10 - width/8, 100 - (1 - (positionLeftWindow.x + 20)/(-width/4 - 20))*250);
    vertex(-width/8 - 10, -150);
    vertex(-width/8 - 10, -200);
    endShape();    
    //stroke 2
    beginShape();
    vertex(positionLeftWindow.x + 10 - width/8, 150 - (1 - (positionLeftWindow.x + 20)/(-width/4 - 20))*250);
    vertex(positionLeftWindow.x + 10 - width/8, 250 - (1 - (positionLeftWindow.x + 20)/(-width/4 - 20))*250);
    vertex(-width/8 - 10, 0);
    vertex(-width/8 - 10, -100);
    endShape();
    popMatrix();

    //glass with frame
    strokeWeight(20);
    stroke(223);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    //grey lines
    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //handle
    strokeWeight(7);
    stroke(63);
    line(-width/8, -50, -width/8, 50);
    popMatrix();

    //window center
    pushMatrix();
    translate(0, 0);

    //glass with frame
    strokeWeight(20);
    stroke(255);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //stroke over the window        
    noStroke();
    fill(227, 246, 250, 63);
    //stroke 1
    beginShape();
    vertex(-width/8 + 10, 50);
    vertex(-width/8 + 10, 100);
    vertex(width/8 - 10, -150);
    vertex(width/8 - 10, -200);
    endShape();
    //stroke 2
    beginShape();
    vertex(-width/8 + 10, 150);
    vertex(-width/8 + 10, 250);
    vertex(width/8 - 10, 0);
    vertex(width/8 - 10, -100);
    endShape();
    popMatrix();

    //window right
    pushMatrix();
    translate(width/4 + 20, 0);

    //glass with frame
    strokeWeight(20);
    stroke(255);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    //grey lines
    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //stroke over the window
    noStroke();
    fill(227, 246, 250, 63);
    //stroke 1
    beginShape();
    vertex(-width/8 + 10, 50);
    vertex(-width/8 + 10, 100);
    vertex(width/8 - 10, -150);
    vertex(width/8 - 10, -200);
    endShape();
    //stroke 2
    beginShape();
    vertex(-width/8 + 10, 150);
    vertex(-width/8 + 10, 250);
    vertex(width/8 - 10, 0);
    vertex(width/8 - 10, -100);
    endShape();
    popMatrix();

    popMatrix();
  }

  boolean windowIsOpen() { //checks if the left window is open
    return  positionLeftWindow.x == -40.0;
  }
  float getPosWindowLeft() { //gets the position of the left window
    return PVector.add(position, positionLeftWindow).x - width/8;
  }

  void selectWindow(float x, float y) { //user clicks on the window to select it
    if (isOverHandle(x, y)) isSelected = true;
  }

  void moveWindow(float delta) { //user dragges the window to move it left and right
    if (isSelected) {
      positionLeftWindow.x += delta;
      if (positionLeftWindow.x > -40) positionLeftWindow.x = -40;
      if (positionLeftWindow.x < -width/4 - 20) positionLeftWindow.x = -width/4 - 20;
    }
  }

  void releaseWindow() { //user releases the window
    isSelected = false;
  }

  boolean isOverHandle(float x, float y) { //checks if the user is over the handle
    return (x > position.x + positionLeftWindow.x - width/8 - 7 && 
      x < position.x + positionLeftWindow.x - width/8 + 7 && 
      y > position.y + positionLeftWindow.y - 55 && 
      y < position.y + positionLeftWindow.y + 55);
  }
}
