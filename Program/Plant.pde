
/*  -- Plant Class --
 *  this Class manages the plant and everything surounding it.
 *  it updates the linked list with the mass spring damperer system.
 *  handles the interaction and draws everything.
 */

class Plant {
  //constants
  static final int UPPER_BRANCH_SIZE = 5;
  static final int LOWER_BRANCH_SIZE = 2;
  static final int GROW_INTERVAL = 30;    //in frames
  static final int BRANCH_INTERVAL = 2;   //in segments
  static final int SEGMENT_SIZE = 10;
  static final float WIND_FORCE_HIGH = 0.002; //the force of the wind when the window is open
  static final float WIND_FORCE_LOW = 0.001;  //when the window is closed

  //branches
  float branchChance;
  int intervalSinceBranch;
  IntList branchesLengths = new IntList(); //stores the length of the growing branches.
  ArrayList<PlantSegment> segments = new ArrayList<PlantSegment>(); //stores the segments as a linked list, Plant segments can be normal/basic segments leafs or the flower.
  String previousDirection;
  int mainBranchSize;

  //growing
  int growTimer;
  boolean isGrowning; //if the plant is still growing its branches
  IntList growLocations = new IntList(); //the indexes where the plant can grow from
  float hydratedTimer; //count's down until the plant isn't hydrated anymore.

  //wind
  float time;
  Windows windows;

  PVector position;
  float flowerPotWidth;
  PImage[] flowerImages;

  //colors
  // HashMap<String,color> colors = new HashMap<String,color>();
  color[] colorsBrown = {color(155, 83, 0), color(144, 76, 1), color(180, 105, 22), color(164, 97, 19)};
  color[] colorsBlue = {color(106, 196, 184), color(79, 160, 143), color(114, 211, 192), color(106, 200, 182)};
  color[] colorsYellow = {color(246, 197, 0), color(234, 175, 13), color(255, 226, 65), color(255, 206, 12)};
  color[] colorsRed = {color(208, 78, 88), color(187, 67, 77), color(223, 102, 117), color(218, 92, 96)};
  color[] currentColorPallet = new color[4];

  Plant(float x, float y, int startAmount, PImage[] flowerImages, Windows windows) {
    //constructs the main branch
    for (int i = 0; i < startAmount; i++) { 
      PlantSegment segmentBellow = null;
      if (i > 0) segmentBellow = segments.get(i-1);
      segments.add(new PlantSegment(SEGMENT_SIZE, segmentBellow, 0, GROW_INTERVAL));

      if (i > 0) segmentBellow.addSegmentAbove(segments.get(i));
    }
    branchesLengths.append(startAmount); //writes down the current branch length
    growLocations.append(startAmount-1); //add the main brach as a grow location

    position = new PVector(x, y);
    this.flowerImages = flowerImages; //the flower array from which one will be choosen.

    //wind:
    time = 0;
    this.windows = windows;

    //setup for growing:
    isGrowning = true;
    branchChance = 2; //50%
    intervalSinceBranch = 0;
    previousDirection = (int(random(0, 2)) == 0) ? "Right" : "Left";
    hydratedTimer = 0;   
    mainBranchSize = 30 + int(random(-10, 10));

    //colors
    switch (int(random(0, 4))) {
    case 0: 
      currentColorPallet = colorsBrown; 
      break;
    case 1: 
      currentColorPallet = colorsBlue; 
      break;
    case 2: 
      currentColorPallet = colorsYellow; 
      break;
    case 3: 
      currentColorPallet = colorsRed; 
      break;
    }

    flowerPotWidth = width/24;
  }

  void update() {
    //adds wind force to the plant
    for (PlantSegment segment : segments) {
      if (segment.isTopSegment()) segment.wind(time, (windows.windowIsOpen()) ? WIND_FORCE_HIGH : WIND_FORCE_LOW); //add wind to top of all the branches
    }

    //update the timers
    time+= 1/frameRate;
    growTimer -= 1/frameRate;
    hydratedTimer -= 1/frameRate;

    //if the plant is still hydrated then grow
    grow();

    //update all the segments
    for (PlantSegment segment : segments) {
      segment.update(hydratedTimer > 0);
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);

    //displays all the segments
    for (PlantSegment segment : segments) {
      segment.display();
    }

    drawFlowerPot(); //draws the flower pot
    popMatrix();
  }

  void grow() { //this function is resonsible for growing the plant, it adds new segments, this can be normal segments, leafs or the flower.
    if (isGrowning && growTimer <= 0 && hydratedTimer > 0) {

      //update the timers
      growTimer = GROW_INTERVAL;

      boolean createdBranch = false; //check if a branch was created, if that's the case then don't also grow it

      if (branchesLengths.get(0) < float(mainBranchSize) * 0.7 && intervalSinceBranch >= BRANCH_INTERVAL) { //don't spawn a branch at the top
        if (int(random(0, branchChance)) == 0) { //small chance to create a new branch
          int index = growLocations.get(0);
          if (previousDirection.equals("Right")) previousDirection = "Left";
          else previousDirection = "Right";

          segments.add(new PlantSegment(SEGMENT_SIZE, segments.get(index), (previousDirection.equals("Left") ? -1 : 1) * random(HALF_PI/4, HALF_PI/2), GROW_INTERVAL));
          growLocations.append(segments.size()-1);
          branchesLengths.append(1);
          createdBranch = true;

          intervalSinceBranch = 0;
        }
      }

      //grows the plant on all the growing places
      for (int i = 0; i < growLocations.size() - (createdBranch ? 1 : 0); i++) { //if a branch was created then don't loop until the end.
        int index = growLocations.get(i);
        segments.add(new PlantSegment(SEGMENT_SIZE, segments.get(index), 0, GROW_INTERVAL));
        segments.get(index).addSegmentAbove(segments.get(segments.size()-1));
        growLocations.set(i, segments.size()-1);
        branchesLengths.add(i, 1);

        //decide if the branch should end.
        if (i == 0 && branchesLengths.get(i) > mainBranchSize) {
          //add a flower.
          PImage flowerImage = flowerImages[int(random(flowerImages.length))];

          segments.add(new Flower(SEGMENT_SIZE, segments.get(segments.size()-1), 0, flowerImage));
          segments.get(segments.size()-2).addSegmentAbove(segments.get(segments.size()-1));


          isGrowning = false;
        } else if ((i > 0 && branchesLengths.get(i) > random(LOWER_BRANCH_SIZE, UPPER_BRANCH_SIZE)) || (i > 0 && !isGrowning)) { //if the branch reases it's end or if it the plant has stopped growing
          //add a leaf at the end.
          segments.add(new Leaf(SEGMENT_SIZE, segments.get(segments.size()-1), 0));
          segments.get(segments.size()-2).addSegmentAbove(segments.get(segments.size()-1));

          growLocations.remove(i);
          branchesLengths.remove(i);
        }
      }

      intervalSinceBranch++;
    }
  }

  void hydrate() { //hydrates the plant so it can continue growing
    hydratedTimer = 0.5;
  }

  boolean isInFlowerPot(PVector posIn) { //if the vector is inside the flower pot
    return abs(position.y - posIn.y) <= height/30 && abs(position.x - posIn.x) <= flowerPotWidth;
  }


  void drawFlowerPot() { //draws the flowerpot

    //flower pot
    noStroke();
    //Bottom Left
    // fill(155, 83, 0); //brown
    // fill(106, 196, 184); //blue
    // fill(246,197,0);  //yellow
    // fill(208,78,88);
    fill(currentColorPallet[0]);
    beginShape();
    vertex(-width/45, height/8 - 30);
    vertex(-width/30, 0);
    vertex(0, 0);
    vertex(0, height/8 - 30);
    endShape();

    //Bottom Right 
    // fill(144, 76, 1);
    // fill(79, 160, 143);
    // fill(234,175,13);
    // fill(187,67,77);
    fill(currentColorPallet[1]);
    beginShape();
    vertex(0, height/8 - 30);
    vertex(0, 0);
    vertex(width/30, 0);
    vertex(width/45, height/8 - 30);
    endShape();

    rectMode(CORNER);
    //Top Left
    // fill(180, 105, 22);
    // fill(114, 211, 192);
    // fill(255,226,65);
    // fill(223,102,117);
    fill(currentColorPallet[2]);
    rect(-flowerPotWidth, -height/30, flowerPotWidth, height/30, 4, 0, 0, 4);

    //Top Right
    // fill(164, 97, 19);
    // fill(106, 200, 182);
    // fill(255,206,12);
    // fill(218,92,96);
    fill(currentColorPallet[3]);
    rect(0, -height/30, flowerPotWidth, height/30, 0, 4, 4, 0);
    rectMode(CENTER);
  }
}
