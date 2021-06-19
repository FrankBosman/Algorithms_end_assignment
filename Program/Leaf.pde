class Leaf extends FlowerSegment{
    float segmentWidth;

    Leaf(float segmentLength, FlowerSegment segmentBellow, float offsetAngle, int growTime){
        super(segmentLength, segmentBellow, offsetAngle, growTime);
        segmentWidth = segmentLength;

    }

     void display() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(totalAngle); //rotates the segment to match the flowers' rotation
        // stroke(segmentColor);
        // strokeWeight(5);
        // line(0, 0, 0, -segmentLength + segmentLength * grownAnimation/growTime); //draws the line of the segment

        //reset strokeWeight
        // strokeWeight(1);

        //draws leaf:
        noStroke();
        fill(255);
        beginShape();
        vertex(0, 0);
        bezierVertex(-segmentWidth/4, -segmentWidth*0.175, segmentWidth/10, -segmentLength+segmentWidth*0.1753, segmentWidth/10, -segmentLength);
        bezierVertex(segmentWidth/10, -segmentLength, segmentWidth*0.425, -segmentWidth/10, 0, 0);
        endShape();
        
        fill(51, 196, 51);
        fill(255,0,0);
        beginShape();
        vertex(0, 0);
        bezierVertex(-200, -segmentWidth*0.175, segmentWidth/10, -segmentLength+segmentWidth*0.175, segmentWidth/10, -segmentLength);
        bezierVertex(segmentWidth/10, -segmentLength, segmentWidth*0.175, -segmentWidth/8, 0, 0);
        endShape();
            
        fill(51, 176, 51);
        fill(0,0,255);
        beginShape();
        vertex(segmentWidth/10, -segmentLength);
        bezierVertex(segmentWidth/10, -segmentLength, segmentWidth*0.425, -segmentWidth/10, 0, 0);
        bezierVertex(0, 0, segmentWidth*0.175, -segmentWidth/20, segmentWidth/10, -segmentLength);
        endShape();
        stroke(0);
        
        popMatrix();
    }

}