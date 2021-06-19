Flower flower;
void setup() {
    size(900, 900);
    flower = new Flower(width/2, height*0.75, 1);
}

void draw() {
    background(200);
    flower.update();
    flower.display();

    if(frameCount % 30 == 0) flower.grow();
}

