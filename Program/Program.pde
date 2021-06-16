
Flock flock;

float time = 0;//why tho ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Flower flower;

void setup() {
    size(900, 900);
    flower = new Flower(new PVector(width/2, height/2));
}

void draw() {
    background(255);
    flower.display();
    flower.update();

}