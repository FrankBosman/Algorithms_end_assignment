Flower flower;
void setup() {
    size(900, 900);
    flower = new Flower(width/2, height*0.75, 1);
}

void draw() {
    background(200);
    flower.update();
    flower.display();

   flower.grow();

   if(flower.branchesLengths.get(0) >= flower.MAIN_BRANCH_SIZE) flower = new Flower(width/2, height*0.75, 1);
}

