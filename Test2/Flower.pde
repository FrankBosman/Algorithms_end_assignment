//Flower Class
//Adapted from Topic 6 Assignments 1, 2 and 3 made by Jelle Gerritsen and Sterre Kuijper

class Flower {
    static final float WIND_FORCE = 0.001;
    int segmentSize = 5;
    float radiusFlower = 80;
    int age;                    //how old the plant is / how much it has grown
    ArrayList<FlowerSegment> segments = new ArrayList<FlowerSegment>();
    PVector position;
    float time;

    color petalColor;
    color pistilColor;

    ArrayList<SideBranch> sideBranches = new ArrayList<SideBranch>();
    IntList locationBranches = new IntList();


    Flower(float x, float y, int startAmount) {
        for (int i = 0; i < startAmount; i++) { //constructs the main branch
            segments.add(new FlowerSegment(segmentSize));
        }
        position = new PVector(x,y);

        // locationBranches.append(5);
        //testing:
        // sideBranches.add(new SideBranch(PI*0.25, 20));

        petalColor = color(237,188,7);
        pistilColor = color(230,23,59);
        time = 0;
        age = 0;
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
                if(locationBranches.size() > 0){
                if(locationBranches.get(currentBranch) == i){
                    sideBranches.get(currentBranch).display();
                    if(currentBranch < locationBranches.size()-1) currentBranch++;
                }
                segments.get(i).display();
            }
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

    void grow(float delta){
        age += delta;

        if(int(random(0,501)) == 0){
            locationBranches.append(segments.size());
            sideBranches.add(new SideBranch(HALF_PI * (random(10, 25)/100), int(random(5, 20)))); //die laatste random moet nog anders
        }

        segments.add(new FlowerSegment(segmentSize));

    }
}