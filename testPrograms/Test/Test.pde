
Flower flower;

void setup() {
    size(900,900);

    flower = new Flower(new PVector(width/2, height*0.75));    
}

void draw() {
    background(200);
    flower.display();
    flower.update();   
}
