//Flower Class
//Adapted from Topic 6 Assignments 1, 2 and 3 made by Jelle Gerritsen and Sterre Kuijper

class Flower {
    int segmentAmount = 10;
    // FlowerSegment[] segments = new FlowerSegment[segmentAmount];
    ArrayList<FlowerSegment> segments = new ArrayList<FlowerSegment>();
    PVector position;

    float xoff = 0.0;
   

    Flower(PVector position) {
        for (int i = 0; i < segmentAmount; i++) {
            segments.add(new FlowerSegment());
        }
        this.position = position;
    }
    
    void update(){
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
        pushMatrix();
        translate(position.x, position.y);        
        for(int i = 0; i < segments.size(); i++){
            segments.get(i).display();
        } 
        noStroke();
        fill(245, 130, 32);
        ellipse(0, 0, 65, 45);
        fill(255,212,0,255);
        ellipse(0, 0, 55, 35);
        fill(255);
        ellipse(0, 0, 45, 25);
        fill(0);
        ellipse(-10, -5, 5, 5);
        rect(-10, 0, 5, 10);
        ellipse(-10, 5, 5, 5);
        ellipse(10, -5, 5, 5);
        rect(10, 0, 5, 10);
        ellipse(10, 5, 5, 5);

        //reset strokeWeight
        strokeWeight(1);

        popMatrix();
    }

    void addForce(float power){
        segments.get(segments.size() - 1).force = power;
    }

    void wind(){
        float n = noise(position.x + time, position.y) * 0.005;
        segments.get(segments.size() - 1).force = n;
    }

    void grow(){

    }
}