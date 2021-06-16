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

    Flower(PVector position) {
        for (int i = 0; i < segmentAmount; i++) {
            segments.add(new FlowerSegment(segmentSize));
        }
        this.position = position;

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