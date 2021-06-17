//Flower Class
//Adapted from Topic 6 Assignments 1, 2 and 3 made by Jelle Gerritsen and Sterre Kuijper

class SideBranch {
    static final float WIND_FORCE = 0.001;
    // int segmentAmount;
    int segmentSize = 5;
    ArrayList<FlowerSegment> segments = new ArrayList<FlowerSegment>();
    PVector position;

    float xoff = 0.0;
    float startAngle;


    SideBranch(float startAngle,int segmentAmount) {
        for (int i = 0; i < segmentAmount; i++) {
            segments.add(new FlowerSegment(segmentSize));
        }
        this.startAngle = startAngle;

    }
    
    void update(FlowerSegment connectSegment){
        segments.get(0).setForces(connectSegment);

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
        rotate(startAngle);
        for(int i = 0; i < segments.size(); i++){
            segments.get(i).display();
        } 
        popMatrix();
    }

    void addForce(float power){
        segments.get(segments.size() - 1).force = power;
    }

    void wind(float time){
        float n = noise(time) * WIND_FORCE;
        segments.get(segments.size() - 1).force = n;
    }

    void grow(){

    }
}