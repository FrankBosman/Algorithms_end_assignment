/*
 *  End Assignment Algorithms Module 4 2021
 *  Made by Sterre Kuijper s2402858 and Frank Bosman s2611775.
 *  This is the program we made for our end assignment, inspired by prevoius assignemnt made this module
 *  
 *  A room where you can water a plant pot to make it sproud a plant.
 *  Interactions:
 *    -Move watercan, rotate it by scrolling
 *    -open window, to let wind in
 *    -water plant
 *    -water vase
 *    -a few eastereggs
 */

Outside outside;
Room room;

void setup() {
  size(1800, 900, P2D);
  rectMode(CENTER);
  imageMode(CENTER);
  
  room = new Room(new PVector(width/2, height/2));
  outside = new Outside();
}

void draw() {
  background(100);
  outside.update();
  outside.display();
  
  room.update();
  room.display();
}

void mousePressed() {
  room.clicked(mouseX, mouseY);
}

void mouseDragged() {
  room.dragged(mouseX, pmouseX, mouseY, pmouseY);
}

void mouseReleased() {
  room.released();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  room.scroll(e);
}
