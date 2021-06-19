//Flower Class
//Adapted from Topic 6 Assignments 1, 2 and 3 made by Jelle Gerritsen and Sterre Kuijper

class Flower {
    static final float WIND_FORCE = 0.001;
    int segmentAmount = 50;
    int segmentSize = 5;
    float radiusFlower = 80;
    ArrayList<FlowerSegment> segments = new ArrayList<FlowerSegment>();
    PVector position;
    float time;

    float xoff = 0.0;

    color petalColor;
    color pistilColor;

    PVector flowerPotPosition;

    Flower(PVector position) {
        for (int i = 0; i < segmentAmount; i++) {
            segments.add(new FlowerSegment(segmentSize));
        }
        this.position = position;
        flowerPotPosition = new PVector(width/2, height*3/4 + 60);

        petalColor = color(237,188,7);
        pistilColor = color(230,23,59);
        time = 0;
    }
    
    void update(){
        time+= 1/frameRate;
        for(int i = 0; i < segments.size(); i++){
            float velocity;
            float force;

            if (i == 0) velocity = 0;
            else velocity = segments.get(i-1).velocity;
            
            if (i == segments.size() - 1) force = 0;
            else force = segments.get(i + 1).force; 

            segments.get(i).update(velocity, force);
            
        }    
    }

    void display() {
        wind();
        pushMatrix();
        translate(position.x, position.y);        
        for(int i = 0; i < segments.size(); i++){
            segments.get(i).display();
        } 
        
        noStroke();
        fill(petalColor);        
        pushMatrix();
            for(int i = 0; i<8; i++){
                rotate(TWO_PI/8);
                ellipse(radiusFlower*0.75, 0, radiusFlower, radiusFlower*0.75);
            }
        popMatrix();
        fill(pistilColor);
        circle(0, 0, radiusFlower);

        //reset strokeWeight
        strokeWeight(1);
      
        popMatrix();

        drawFlowerPot();
    }

    void drawFlowerPot() {
        pushMatrix();
        translate(flowerPotPosition.x, flowerPotPosition.y);

        //flower pot
        noStroke();
        fill(155, 83, 0);
        beginShape();
        vertex(-40, height/8 - 30);
        vertex(-60, 0);
        vertex(0, 0);
        vertex(0, height/8 - 30);
        endShape();

        fill(144, 76, 1);
        beginShape();
        vertex(0, height/8 - 30);
        vertex(0, 0);
        vertex(60, 0);
        vertex(40, height/8 - 30);
        endShape();

        rectMode(CORNER);
        fill(180, 105, 22);
        rect(-75, -30, 75, 30, 4, 0, 0, 4);
        
        fill(164, 97, 19);
        rect(0, -30, 75, 30, 0, 4, 4, 0);
        rectMode(CENTER);
        popMatrix();
    }

    void addForce(float power){
        segments.get(segments.size() - 1).force = power;
    }

    void wind(){
        float n = noise(position.x + time, position.y) * WIND_FORCE;
        segments.get(segments.size() - 1).force = n;
    }

    void grow(){

    }
}