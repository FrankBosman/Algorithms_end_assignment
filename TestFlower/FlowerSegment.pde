//Flower Segment Class

class FlowerSegment {

    color segmentColor;
    float force, velocity, angle, totalAngle;
    PVector position;
    int segmentLength;

    static final float DAMPING_CONSTANT = 0.02;
    static final float SPRING_CONSTANT = 0.02;
    static final float WIND_FACTOR = 0.001;


    FlowerSegment segmentBellow;
    ArrayList<FlowerSegment> segmentsAbove = new ArrayList<FlowerSegment>();
    boolean isBottom; //if it's the bottom segment, so if it has a segment bellow it.

    FlowerSegment(int segmentLength, FlowerSegment segmentBellow) {
        this.segmentLength = segmentLength;
        this.segmentBellow = segmentBellow;
        
        if(segmentBellow == null) isBottom = true;
        else isBottom = false;

        segmentColor = color(51, 196, 51); //green//color(random(255), random(255), random(255));
        position = new PVector();

        angle = 0;
        totalAngle = 0;
        velocity = 0;
        force = 0;
    }

    void display() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(totalAngle); //rotates the segment to match the flowers' rotation
        stroke(segmentColor);
        strokeWeight(5);
        line(0, 0, 0, -segmentLength); //draws the line of the segment

        //reset strokeWeight
        strokeWeight(1);
        
        popMatrix();

    }

    void addSegmentAbove(FlowerSegment segment){
        segmentsAbove.add(segment);
    }

    void update() {
        float tempVelocity = 0;
        if(!isBottom) tempVelocity = velocity - segmentBellow.getVeloctiy(); //calculates the temp velocity to be used in the calculations. if there is a segment bellow it 

        float friction = tempVelocity * DAMPING_CONSTANT;           //calulates the friction with the velocity it's self and bellow
        angle += tempVelocity;
        force = SPRING_CONSTANT * angle + friction;                 //calculates the new force
        
        float forceAbove = 0;                                       //init it with 0 so if segmentsAbove is empty it's 0 and so we can sum over it.
        for(FlowerSegment segment : segmentsAbove){                 //sums the forces from all the segments above
            forceAbove += segment.getForce();
        }

        velocity += forceAbove - force;                             //calculates the new velocity with the velocity of the segments above

        if(!isBottom){ //calculate the new position
            totalAngle = angle + segmentBellow.getTotalAngle();
            position = segmentBellow.getPosition();
            position.x += -cos(-(segmentBellow.getTotalAngle() + HALF_PI)) * segmentLength;
            position.y += sin(-(segmentBellow.getTotalAngle() + HALF_PI)) * segmentLength;
        }
    }

    void wind(float time){
        float windForce = noise(position.x + time, position.y) * WIND_FACTOR;
        force = windForce;
    }

    float getVeloctiy(){
        return velocity;
    }

    float getForce(){
        return force;
    }

    float getTotalAngle(){
        return totalAngle;
    }
    float getAngle(){
        return angle;
    }

    PVector getPosition(){
        return position.copy();
    }

    void setForce(float forceIn){
        force = forceIn;
    }

    boolean isTopSegment(){
        return segmentsAbove.size() == 0;
    }
}