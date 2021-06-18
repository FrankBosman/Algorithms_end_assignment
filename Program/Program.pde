
Flock flock;
Inside inside;
Outside outside;

PImage landscape;

void setup() {
    size(1800, 900);
    rectMode(CENTER);
    imageMode(CENTER);
    inside = new Inside();
    outside = new Outside();

    landscape = loadImage("landscape2.png");
    landscape.resize(width*7/8, 0);
}

void draw() {
    image(landscape, width/2, height/2);  
    inside.display();
    inside.update();

    outside.display();
    outside.update();

}

void mousePressed() {
    inside.clicked(mouseX, mouseY);
}

void mouseDragged() {
    inside.dragged(mouseX, pmouseX);
}

void mouseReleased() {
    inside.released();
}