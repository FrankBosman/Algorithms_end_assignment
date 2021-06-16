
Flock flock;
Inside inside;
Outside outside;


void setup() {
    size(1800, 900);
    inside = new Inside();
    outside = new Outside();
}

void draw() {
    background(255);
    inside.display();
    inside.update();

    outside.display();
    outside.update();

}