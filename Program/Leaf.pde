class Leaf extends PlantSegment{
    float leafSize;
    color leafColor;

    Leaf(float segmentLength, PlantSegment segmentBellow, float offsetAngle, int growTime){
        super(segmentLength, segmentBellow, offsetAngle, growTime);
        leafSize = segmentLength*10;
        leafColor = color(132, 191, 3);

    }

     void display() {
        pushMatrix();
        translate(position.x, position.y);
        rotate(totalAngle); //rotates the segment to match the flowers' rotation

        //draws leaf:
        noStroke();

        //background
        fill(segmentColor);
        beginShape();
        vertex(-leafSize/40, 0);
        bezierVertex(-leafSize/4, -leafSize*0.175, leafSize/10, -leafSize + leafSize*0.1753, leafSize/10, -leafSize);
        bezierVertex(leafSize/10, -leafSize, leafSize*0.425, -leafSize/10, 0, 0);
        endShape();

        //left side
        fill(leafColor);
        beginShape();
        vertex(-leafSize/40, 0);
        bezierVertex(-leafSize/4, -leafSize*0.175, leafSize/10, -leafSize+leafSize*0.175, leafSize/10, -leafSize);
        bezierVertex(leafSize/10, -leafSize, leafSize*0.14, -leafSize/8, -leafSize/40, 0);
        endShape();

        //right side
        fill(leafColor);
        beginShape();
        vertex(leafSize/10, -leafSize);
        bezierVertex(leafSize/10, -leafSize, leafSize*0.425, -leafSize/10, 0, 0);
        bezierVertex(0, 0, leafSize*0.175, -leafSize/20, leafSize/10, -leafSize);
        endShape();
        
        popMatrix();
    }

    void growAnimation(){
        
    }

}