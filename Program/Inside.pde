class Inside{//this class handels all objects inside the room and the interactions between them 
    Flower flower;
    Room room;

    Inside(){
        flower = new Flower(new PVector(width/2, height*3/4 + 60));
        room = new Room(new PVector(width/2, height/2));
    }

    void display(){
        room.display();
        flower.display();
    }

    void update(){
        flower.update();
    }

    void drawBackground(){

    }

    void clicked(float x, float y){
        room.selectWindow(x, y);
    }

    void dragged(float x, float px){
        room.moveWindow(x - px);
    }

    void released() {
        room.releaseWindow();
    }
}