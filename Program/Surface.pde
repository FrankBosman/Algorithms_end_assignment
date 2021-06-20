/*  -- Surface Class --
 *  This Class displays, handles the water segments and the interactions between them
 *  It also handles the interaction between te water and the particles
 *  Adapted from topic 6 assignment 6.6, made by Ysbrand Burgstede, Frank Bosman.
 */

class Surface {
  float levelHeight;
  PVector pos;
  PVector waterSize;
  ArrayList<WaterSegment> segments = new ArrayList<WaterSegment>();

  Surface(PVector pos, float initWidth, float initHeight, int segmentSize) {
    for (int i = 0; i < int(initWidth / segmentSize); i++) {//setup the segments that will form the water
      segments.add(new WaterSegment(new PVector(segmentSize/2 + i*segmentSize, 0), segmentSize, this));
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
      fill(0, 64, 128, 150);
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

  //the methoud adds force to the water, it returns if it was succesfull
  boolean addAreaForce(float x, float y, int dist, float multiplier) {
    boolean hit = false;
    for (WaterSegment segment : segments) {
      if (segment.distance(x, y, pos) <= dist) {
        segment.addForce((dist-segment.distance(x, y, pos)) * multiplier);
        hit = true;
      }
    }
    if(hit) levelHeight -= 0.1; //increase the water level
    return hit;
  }

  boolean hit(PVector posIn){
    return posIn.y >= pos.y + levelHeight && posIn.x >= pos.x && posIn.x <= pos.x + waterSize.x;
  }
}