//Flower Class
//Adapted from Topic 6 Assignments 1, 2 and 3 made by Jelle Gerritsen and Sterre Kuijper

class Flower {
    int segmentSize = 20;
    float radiusFlower = 80;
    int age;                    //how old the plant is / how much it has grown
    ArrayList<FlowerSegment> segments = new ArrayList<FlowerSegment>();
    PVector position;
    float time;

    color petalColor;
    color pistilColor;

    Flower(float x, float y, int startAmount) {
        for (int i = 0; i < startAmount; i++) { //constructs the main branch
            FlowerSegment segmentBellow = null;
            if(i > 0) segmentBellow = segments.get(i-1);
            segments.add(new FlowerSegment(segmentSize, segmentBellow));

            if(i > 0) segmentBellow.addSegmentAbove(segments.get(i));
        }
        position = new PVector(x,y);

        petalColor = color(237,188,7);
        pistilColor = color(230,23,59);
        time = 0;
        age = 0;
    }
    
    void update(){
        wind();       
        time+= 1/frameRate;

        for(FlowerSegment segment : segments){
            segment.update();
        } 
    }


    void display() {
        pushMatrix();
        translate(position.x, position.y);
        for(FlowerSegment segment : segments){
            segment.display();
        }
        popMatrix();

        // int currentBranch = 0;
        // pushMatrix();
        // translate(position.x, position.y);        
        // for(int i = 0; i < segments.size(); i++){
        //         if(locationBranches.size() > 0){
        //         if(locationBranches.get(currentBranch) == i){
        //             sideBranches.get(currentBranch).display();
        //             if(currentBranch < locationBranches.size()-1) currentBranch++;
        //         }
        //         segments.get(i).display();
        //     }
        // } 
        // popMatrix();
    }

    void addForce(float power){
        // segments.get(segments.size() - 1).force = power;
    }

    void wind(){
        for(FlowerSegment segment : segments){
            if(segment.isTopSegment()) segment.wind(time);//setForce(windForce); //add wind to the top of the plant
        }
    }

    // void grow(float delta){
    //     age += delta;

    //     if(int(random(0,501)) == 0){
    //         locationBranches.append(segments.size());
    //         sideBranches.add(new SideBranch(HALF_PI * (random(10, 25)/100), int(random(5, 20)))); //die laatste random moet nog anders
    //     }

    //     segments.add(new FlowerSegment(segmentSize));

    // }
}