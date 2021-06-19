//Flower Segment Class
//Adapted from Topic 6 Assignments 1, 2 and 3 made by Jelle Gerritsen and Sterre Kuijper

class FlowerSegment {

    color segmentColor;
    float force, velocity, angle;
    PVector position;
    int segmentLength;

    static final float DAMPING_CONSTANT = 0.02;
    static final float SPRING_CONSTANT = 20;

    FlowerSegment(int segmentLength) {
        segmentColor = color(51, 196, 51); //green
        this.segmentLength = segmentLength;
        angle = 0;
        velocity = 0;
        force = 0;
    }

    void display() {
        rotate(angle); //rotates the segment to match the flowers' rotation
        stroke(segmentColor);
        strokeWeight(5);
        line(0, 0, 0, -segmentLength); //draws the line of the segment

        //reset strokeWeight
        strokeWeight(1);
        
        //translate up for the next segment
        translate(0, -segmentLength);
    }

    void update(float v, float f) {
        float tempVelocity = velocity - v; //hier nog comments toevoegen
        float friction = tempVelocity * DAMPING_CONSTANT;
        angle += tempVelocity;
        force = 1 / SPRING_CONSTANT * angle + friction;
        velocity += f - force;
    }
}