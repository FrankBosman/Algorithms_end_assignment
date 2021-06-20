class Surface {
  float levelHeight;
  PVector pos;
  PVector waterSize;
  ArrayList<WaterSegment> segments = new ArrayList<WaterSegment>();

  Surface(PVector pos, float initWidth, float initHeight, int segmentSize) {
    for (int i = 0; i < int(initWidth / segmentSize); i++) {
      segments.add(new WaterSegment(new PVector(segmentSize/2 + i*segmentSize, 0), segmentSize));
    }

    this.pos = pos;
    waterSize = new PVector(initWidth, initHeight);
    levelHeight = 0; //the level of the water relative to the position
  }

  void update() {
    for (int i = 0; i < segments.size(); i++) {
      WaterSegment segment = segments.get(i);
      float forceLeft = (i > 0) ?  segments.get(i-1).getSpringForce(segment.getHeightOffset()) : 0;
      float forceRight = (i < segments.size()-1) ?  segments.get(i+1).getSpringForce(segment.getHeightOffset()) : 0;

      segment.updateForces(forceLeft, forceRight);
    }

    for (WaterSegment segment : segments) {
      segment.updateMovement();
    }
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);   
      beginShape();
      noStroke();
      fill(0, 64, 128);
      vertex(0, levelHeight);
      for (WaterSegment segment : segments) {
        segment.display();
      }
      vertex(waterSize.x, levelHeight);
      vertex(waterSize.x, waterSize.y);
      vertex(0, waterSize.y);
      endShape();
    popMatrix();
  }

  boolean addAreaForce(float x, float y, int dist, float multiplier) {
    boolean hit = false;
    for (WaterSegment segment : segments) {
      if (segment.distance(x, y) <= dist) {
        //segment.addForce(segment.distVect(new PVector(x,y)).y * segment.springConst);
        segment.addForce((dist-segment.distance(x, y)) * multiplier);
        hit = true;
      }
    }
    return hit;
  }

  boolean hit(PVector posIn){
    if(posIn.y >= pos.y + levelHeight )
  }
}