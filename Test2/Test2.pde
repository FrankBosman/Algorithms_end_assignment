
Flower flower;

void setup() {
    size(900,900);

    flower = new Flower(width/2, height*0.75, 50);    
}

void draw() {
    background(200);
    flower.display();
    flower.update();   

    if(frameCount % 20 == 0) flower.grow(1);
}
