class Inside{//this class handels all objects inside the room and the interactions between them 
    Flower flower;

    Inside(){
        flower = new Flower(new PVector(width/2, height/2));
    }

    void display(){
        flower.display();
    }

    void update(){
        flower.update();
    }

    void drawBackground(){

    }

    void clicked(){

    }

    void dragged(){

    }
}