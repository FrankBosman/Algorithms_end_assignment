//Plant Class

class Plant {
  //constants
  static final int UPPER_BRANCH_SIZE = 5;
  static final int LOWER_BRANCH_SIZE = 2;
  static final int MAIN_BRANCH_SIZE = 30;
  static final int GROW_INTERVAL = 30;    //in frames
  static final int BRANCH_INTERVAL = 2;   //in segments

  //branches/growing
  float branchChance;
  int intervalSinceBranch;
  int growTimer;
  boolean isGrowning; //if the plant is still growing its branches
  IntList growLocations = new IntList(); //the indexes where the plant can grow from
  IntList branchesLengths = new IntList(); //stores the length of the growing branches.
  ArrayList<PlantSegment> segments = new ArrayList<PlantSegment>(); //stores the segments as a linked list
  String previousDirection;

  int segmentSize = 10;
  float radiusFlower = 80;
  PVector position;
  float time;

  //colors
  color petalColor;
  color pistilColor;

  PImage[] flowerImages;

  Plant(float x, float y, int startAmount, PImage[] flowerImages) {
    for (int i = 0; i < startAmount; i++) { //constructs the main branch
      PlantSegment segmentBellow = null;
      if (i > 0) segmentBellow = segments.get(i-1);
      segments.add(new PlantSegment(segmentSize, segmentBellow, 0, GROW_INTERVAL));

      if (i > 0) segmentBellow.addSegmentAbove(segments.get(i));
    }
    branchesLengths.append(startAmount);
    growLocations.append(startAmount-1);
    position = new PVector(x, y);

    petalColor = color(237, 188, 7);
    pistilColor = color(230, 23, 59);
    time = 0;
    isGrowning = true;
    branchChance = 2; //50%
    intervalSinceBranch = 0;
    previousDirection = "Right";

    this.flowerImages = flowerImages;
  }

  void update() {
    wind();       
    time+= 1/frameRate;

    for (PlantSegment segment : segments) {
      segment.update();
    } 

    grow(); //TEMP
  }


  void display() {
    pushMatrix();
    translate(position.x, position.y);
    for (PlantSegment segment : segments) {
      segment.display();
    }

    drawFlowerPot();
    popMatrix();
  }

  void wind() {
    for (PlantSegment segment : segments) {
      if (segment.isTopSegment()) segment.wind(time); //add wind to the top of the plant
    }
  }

  void grow() {
    growTimer -= 1/frameRate;
    if (isGrowning && frameCount % GROW_INTERVAL == 0) {
      growTimer = GROW_INTERVAL;

      boolean createdBranch = false; //check if a branch was created, if that's the case then don't also grow it

      if (branchesLengths.get(0) < float(MAIN_BRANCH_SIZE) * 0.8 && intervalSinceBranch >= BRANCH_INTERVAL) { //don't spawn a branch at the top
        if (int(random(0, branchChance)) == 0) { //small chance to create a new branch
          int index = growLocations.get(0);
          if (previousDirection.equals("Right")) previousDirection = "Left";
          else previousDirection = "Right";

          segments.add(new PlantSegment(segmentSize, segments.get(index), (previousDirection.equals("Left") ? -1 : 1) * random(HALF_PI/4, HALF_PI/2), GROW_INTERVAL));
          growLocations.append(segments.size()-1);
          branchesLengths.append(1);
          createdBranch = true;

          intervalSinceBranch = 0;
        }
      }

      //growns the flower on all the growing places
      for (int i = 0; i < growLocations.size() - (createdBranch ? 1 : 0); i++) { //if a branch was created then don't loop until the end.
        int index = growLocations.get(i);
        segments.add(new PlantSegment(segmentSize, segments.get(index), 0, GROW_INTERVAL));
        segments.get(index).addSegmentAbove(segments.get(segments.size()-1));
        growLocations.set(i, segments.size()-1);
        branchesLengths.add(i, 1);

        //decide if the branch should end.
        if (i == 0 && branchesLengths.get(i) > MAIN_BRANCH_SIZE) {
          //add a flower.
          PImage flowerImage = flowerImages[int(random(flowerImages.length))];

          segments.add(new Flower(segmentSize, segments.get(segments.size()-1), 0, flowerImage));
          segments.get(segments.size()-2).addSegmentAbove(segments.get(segments.size()-1));


          isGrowning = false;
        } else if ((i > 0 && branchesLengths.get(i) > random(LOWER_BRANCH_SIZE, UPPER_BRANCH_SIZE)) || (i > 0 && !isGrowning)) { //if the branch reases it's end or if it the plant has stopped growing
          //add a leaf at the end.
          segments.add(new Leaf(segmentSize, segments.get(segments.size()-1), 0));
          segments.get(segments.size()-2).addSegmentAbove(segments.get(segments.size()-1));

          growLocations.remove(i);
          branchesLengths.remove(i);
        }
      }

      intervalSinceBranch++;
    }
  }

  void drawFlowerPot() { //draws the flowerpot
    pushMatrix();
    // translate(flowerPotPosition.x, flowerPotPosition.y);

    //flower pot
    noStroke();
    fill(155, 83, 0);
    beginShape();
    vertex(-40, height/8 - 30);
    vertex(-60, 0);
    vertex(0, 0);
    vertex(0, height/8 - 30);
    endShape();

    fill(144, 76, 1);
    beginShape();
    vertex(0, height/8 - 30);
    vertex(0, 0);
    vertex(60, 0);
    vertex(40, height/8 - 30);
    endShape();

    rectMode(CORNER);
    fill(180, 105, 22);
    rect(-75, -30, 75, 30, 4, 0, 0, 4);

    fill(164, 97, 19);
    rect(0, -30, 75, 30, 0, 4, 4, 0);
    rectMode(CENTER);
    popMatrix();
  }
}
