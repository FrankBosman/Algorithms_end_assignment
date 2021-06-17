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

    color petalColor;
    color pistilColor;

    ArrayList<SideBranch> sideBranches = new ArrayList<SideBranch>();
    IntList locationBranches = new IntList();


    Flower(PVector position) {
        for (int i = 0; i < segmentAmount; i++) { //constructs the main branch
            segments.add(new FlowerSegment(segmentSize));
        }
        this.position = position;

        locationBranches.append(5);
        //testing:
        sideBranches.add(new SideBranch(PI*0.25, 20));

        petalColor = color(237,188,7);
        pistilColor = color(230,23,59);
        time = 0;
    }
    
    void update(){
        wind();       
        time+= 1/frameRate;

        int currentBranch = 0;
        for(int i = 0; i < segments.size(); i++){
            float velocity;
            float force;

            if (i == 0) velocity = 0;
            else velocity = segments.get(i-1).velocity;
            
            if (i == segments.size() - 1) force = 0;
            else force = segments.get(i + 1).force; 

            if(locationBranches.get(currentBranch) == i){
                sideBranches.get(currentBranch).update(segments.get(i));
            }
            segments.get(i).update(velocity, force);
            
        }    
    }


    void display() {
        int currentBranch = 0;
        pushMatrix();
        translate(position.x, position.y);        
        for(int i = 0; i < segments.size(); i++){
            if(locationBranches.get(currentBranch) == i){
                sideBranches.get(currentBranch).display();
                if(currentBranch < locationBranches.size()-1) currentBranch++;
            }
            segments.get(i).display();
        } 
        popMatrix();
    }

    void addForce(float power){
        // segments.get(segments.size() - 1).force = power;
    }

    void wind(){
        float n = noise(position.x + time, position.y) * WIND_FORCE;
        segments.get(segments.size() - 1).force = n;

        for(SideBranch sideBranch : sideBranches){
            sideBranch.wind(time);
        }
    }

    void grow(){

    }
}