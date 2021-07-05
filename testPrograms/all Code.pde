/*
 *  End Assignment Algorithms Module 4 2021
 *  Made by Sterre Kuijper s2402858 and Frank Bosman s2611775.
 *  This is the program we made for our end assignment, inspired by prevoius assignemnt made this module
 *  
 *  A room where you can water a plant pot to make it sproud a plant.
 *  Interactions:
 *    -Move watercan, rotate it by scrolling or by pressing space.
 *    -open window, to let wind in
 *    -water plant
 *    -water vase
 *    -a few eastereggs
 */

Outside outside;
Room room;
boolean keyDown;

void setup() {
  size(1800, 900, P2D);
  rectMode(CENTER);
  imageMode(CENTER);
  
  room = new Room(new PVector(width/2, height/2));
  outside = new Outside();
}

void draw() {
  background(100);
  outside.update();
  outside.display();
  
  room.update();
  room.display();

  //test if keydown
  if(keyDown){
    if(key == ' '){
      room.scroll(0.5);
    }
  }

  fill(0);
  text(frameRate, 5, 20);
}

void mousePressed() {
  room.clicked(mouseX, mouseY);
}

void mouseDragged() {
  room.dragged(mouseX, pmouseX, mouseY, pmouseY);
}

void mouseReleased() {
  room.released();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  room.scroll(e);
}

void keyPressed(){
  keyDown = true;
}

void keyReleased() {
  keyDown = false;
}


/*  -- Bird Class --
 *  This Class displays the bird and is controlled by the flock 
 *  Adopted from Topic 5 assignment 2 made by Marnix Lueb and Frank Bosman
 */

class Bird {
  //movement and flocking
  static final float SPEED_FACTOR = 20;
  PVector position;
  PVector speed;
  float radius;
  int id;
  float speedLimit;

  //animation
  static final float ANIMATION_SPEED = 0.1;
  float animationTimer;
  PImage[] birdAnimation;
  int currentFrame;

  Bird(PVector position, int id, float speedLimit, PImage[] birdAnimation) {
    this.position = position;
    this.id = id;
    this.speedLimit = speedLimit;

    //animation
    this.birdAnimation = birdAnimation;
    currentFrame = int(random(0, birdAnimation.length));
    animationTimer = 0;

    //give the bird a random speed vector
    speed = PVector.random2D().setMag(speedLimit);
    radius = int(random(10, 20));
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);

    //rotate the image to the direction he's flying
    if (speed.x <= 0) {
      scale(1, -1);
      rotate(-speed.heading());
    } else rotate(speed.heading());

    //draws the bird at the current frame of it's animation
    image(birdAnimation[currentFrame], 0, 0, radius*2, radius*2);

    //loop one frame further.
    animationTimer += 1/frameRate;
    if (animationTimer >= ANIMATION_SPEED) {
      currentFrame++;
      if (currentFrame >= birdAnimation.length) currentFrame = 0;
      animationTimer = 0;
    }

    popMatrix();
  }

  void updateSpeed(PVector acceleration) {
    speed.add(acceleration.mult(1/frameRate * SPEED_FACTOR));        //adds the acceleration to the speed
    speed.limit(speedLimit);  //limits the speed of the bird
    position.add(speed.copy().mult(1/frameRate * SPEED_FACTOR));
  }

  PVector getPos() {
    return position.copy();
  }

  PVector getSpeed() {
    return speed.copy();
  }
}


/*  -- Flock Class --
 *  This Class displays the flower and manages the growing animation 
 *  Adopted from Topic 5 assignment 2 made by Marnix Lueb and Frank Bosman
 */

class Flock {
  static final float AVOIDANCE_FACTOR  = 15;
  static final float SEPERATION_FACTOR = 0.5;
  static final float COHESION_FACTOR   = 0.1;
  static final float ALIGNMENT_FACTOR  = 0.4;
  static final float SEARCH_RADIUS     = 75;
  static final float SPEED_LIMIT       = 4;

  ArrayList<Bird> flock = new ArrayList<Bird>();

  Flock(int startAmount, PImage[] birdAnimation) {
    for (int i = 0; i < startAmount; i++) { //fills the flock of birds
      flock.add(new Bird(new PVector(random(width), random(height)), i, SPEED_LIMIT, birdAnimation)); //at a random posistion
    }
  }

  void display() { //displays the birds that are part of the flock
    for (Bird bird : flock) {
      bird.display();
    }
  }

  void update() {//update the birds
    for (Bird bird : flock) {
      updateBird(bird);
    }
  }   

  void updateBird(Bird bird) {
    ArrayList<Bird> nearbyBirds = nearbyBirds(bird);
    PVector acceleration = new PVector(0, 0);

    //Avoidance
    PVector avoidanceVector = avoidance(bird).mult(AVOIDANCE_FACTOR);
    acceleration.add(avoidanceVector);

    //Seperation
    PVector seperationVector = seperation(nearbyBirds, bird).mult(SEPERATION_FACTOR);
    acceleration.add(seperationVector);

    //Cohesion
    PVector cohesionVector = cohesion(nearbyBirds, bird.getPos()).normalize().mult(COHESION_FACTOR);
    acceleration.add(cohesionVector);

    //Alignment
    PVector AlignmentVector = Alignment(nearbyBirds).normalize().mult(ALIGNMENT_FACTOR);
    acceleration.add(AlignmentVector);

    bird.updateSpeed(acceleration);
  }

  //Avoidance
  PVector avoidance(Bird bird) {
    PVector avoidance = new PVector(0, 0);
    float avoidancePower = 1; //the inverse strength at which they will move away from an object

    PVector position = bird.getPos();

    //wall avoidance
    if (position.x <= SEARCH_RADIUS) avoidance.add(new PVector(1 / (position.x * avoidancePower), 0));
    if (position.y <= SEARCH_RADIUS) avoidance.add(new PVector(0, 1 / (position.y * avoidancePower)));
    if (width - position.x <= SEARCH_RADIUS) avoidance.add(new PVector( -1 / ((width - position.x) * avoidancePower), 0));
    if (height - position.y <= SEARCH_RADIUS) avoidance.add(new PVector(0, -1 / ((height - position.y) * avoidancePower)));

    return avoidance;
  }

  //Seperation
  PVector seperation(ArrayList<Bird> nearbyBirds, Bird bird) {
    PVector seperation = new PVector(0, 0);
    PVector position = bird.getPos();
    if (nearbyBirds.size()>0) {
      for (Bird otherBird : nearbyBirds) {
        if (PVector.dist(position, otherBird.getPos()) <= bird.radius * 2 + otherBird.radius * 2) {//radius*8 is the seperation distance, that's when the birds almost hit eachother
          seperation.add(PVector.sub(position, otherBird.getPos()).normalize().setMag(1 / PVector.dist(position, otherBird.getPos())));
        }
      }
      seperation.mult(10);
    }
    return seperation;
  }


  //Cohesion
  PVector cohesion(ArrayList<Bird> nearbyBirds, PVector position) {
    PVector middle = new PVector(0, 0);
    if (nearbyBirds.size() > 0) {
      for (Bird otherBird : nearbyBirds) {
        middle.add(PVector.sub(otherBird.getPos(), position));
      }
      middle.div(nearbyBirds.size());
    }
    return middle;
  }

  //Alignment
  PVector Alignment(ArrayList<Bird> nearbyBirds) {
    PVector direction = new PVector(0, 0);
    if (nearbyBirds.size() > 0) {
      for (Bird bird : nearbyBirds) {
        direction.add(bird.getSpeed());
      }
      direction.div(nearbyBirds.size());
    }
    return direction;
  }

  ArrayList<Bird> nearbyBirds(Bird bird) {//gets the birds in the search radius of the bird
    ArrayList<Bird> nearbyBirds = new ArrayList<Bird>();

    for (int i = 0; i < flock.size(); i++) {
      Bird otherBird = flock.get(i);
      if (i != bird.id && PVector.dist(bird.getPos(), otherBird.getPos()) <= SEARCH_RADIUS) {
        nearbyBirds.add(otherBird);
      }
    }

    return nearbyBirds;
  }
}


/*  -- Leaf Class --
 *  This Class displays the flower and manages the growing animation 
 */

class Flower extends PlantSegment {
  static final float ANIMATION_TIME = 100;
  float flowerSize;
  float maxFlowerSize;
  int cooldown;

  PImage flowerImage;

  Flower(float segmentLength, PlantSegment segmentBellow, float offsetAngle, PImage flowerImage) {
    super(segmentLength, segmentBellow, offsetAngle, int(ANIMATION_TIME));
    flowerSize = 0;
    maxFlowerSize = segmentLength*10;
    cooldown = growTime;

    this.flowerImage = flowerImage;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(totalAngle);

    image(flowerImage, 0, 0, flowerImage.width * flowerSize, flowerImage.height * flowerSize);
    popMatrix();
  }

  void growAnimation() {
    //update the grow animation
    if (growAnimation > 0) growAnimation--;
    if (growAnimation <= ANIMATION_TIME) {
      flowerSize = (1 - growAnimation / ANIMATION_TIME);
    }
  }
}


/*  -- Glass Class --
 *  This Class displays the glass.
 *  and it handles the surface which can be changed by throwing water on it
 */

class Glass {
  static final int GLASS_HEIGHT = 200;
  static final int GLASS_WIDTH = 75;
  static final int STROKE_WEIGHT = 5;

  PVector position;
  Surface surface;

  PImage tulipImage;

  Glass(PVector position, PImage tulipImage) {
    this.position = position.add(0, -GLASS_HEIGHT/2 - STROKE_WEIGHT/2); //move the pos coordinate so the glass sits on the given coordinate
    this.tulipImage = tulipImage;
    surface = new Surface(PVector.add(position, new PVector(-GLASS_WIDTH/2 + STROKE_WEIGHT/2, -STROKE_WEIGHT)), GLASS_WIDTH - STROKE_WEIGHT, GLASS_HEIGHT/2, 2); //creates the surface that handles the water
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);

    //tulip
    pushMatrix();
    rotate(PI/12);  
    image(tulipImage, 0, -tulipImage.height/3);
    rotate(-PI/8);  
    image(tulipImage, 0, -tulipImage.height/3);

    popMatrix();

    strokeWeight(STROKE_WEIGHT);
    stroke(174, 232, 240);    //light blue
    fill(174, 232, 240, 127); //light blue
    rect(0, 0, GLASS_WIDTH, GLASS_HEIGHT, 5, 5, 10, 10);

    popMatrix();
    //reset strokeWeight
    strokeWeight(1);

    surface.display();
  }

  void update() {
    surface.update();
  }

  void collide(Particle particle) {
    //test if the particle hit the glass
    PVector posIn = particle.getPos();
    if (posIn.y >= position.y - GLASS_HEIGHT/2 && posIn.y <= position.y + GLASS_HEIGHT/2 && //test the Y coords
      ((posIn.x >= position.x - GLASS_WIDTH/2 - STROKE_WEIGHT*3 && posIn.x <= position.x - GLASS_WIDTH/2 + STROKE_WEIGHT*3) || //test the x coords of the left wall
      (posIn.x >= position.x + GLASS_WIDTH/2 - STROKE_WEIGHT*3 && posIn.x <= position.x + GLASS_WIDTH/2 + STROKE_WEIGHT*3))) {  //test the x coords of the right wall
      particle.velocity.x *= -1;
    }
  }

  boolean addForceToSurface(float x, float y, int dist, float multiplier){
    return surface.addAreaForce(x, y, dist, multiplier);
  }
}



/*  -- Leaf Class --
 *  This Class displays the leaf and manages the growing animation 
 */

class Leaf extends PlantSegment {
  static final float ANIMATION_TIME = 500;
  float leafSize;
  float maxLeafSize;
  color leafColor;
  int cooldown;

  Leaf(float segmentLength, PlantSegment segmentBellow, float offsetAngle) {
    super(segmentLength, segmentBellow, offsetAngle, int(ANIMATION_TIME));
    leafSize = 0;
    maxLeafSize = segmentLength*10;
    leafColor = color(132, 191, 3);
    cooldown = growTime;
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

  void growAnimation() {
    //update the grow animation
    if (growAnimation > 0) growAnimation--;
    leafSize = maxLeafSize * (1 - growAnimation / ANIMATION_TIME);
  }
}



/*  -- Outside Class --
 *  This Class handels all objects outside and the interactions between them 
 */

class Outside {

  Flock flock;
  PImage landscape;
  PImage[] birdAnimation = new PImage[9];

  Outside() {
    //loads the images
    landscape = loadImage("landscape2.png");
    landscape.resize(width*7/8, 0);

    for (int i = 1; i <= 9; i++) {
      birdAnimation[i-1] = loadImage("Birds/Bird_0" + i +".png");
    }

    //create the flock
    flock = new Flock(75, birdAnimation);
  }

  void display() {
    drawBackground();
    flock.display();
  }

  void update() {
    flock.update();
  }

  void drawBackground() {
    image(landscape, width/2, height/2);
  }
}



/*  -- Particle Class --
 *  This Class handels the particle
 *  Adapted from Topic 4 Assignment 1 made by Marnix Lueb and Sterre Kuijper 
 */

class Particle {
  int lifespan;

  PVector position;
  PVector velocity;
  PVector acceleration;

  float gravity;

  //interaction
  PVector windowSillPos;
  float windowSillWidth;
  Plant plant;

  float radius;

  Particle(PVector position, PVector direction, PVector windowSillPos, float windowSillWidth) {
    this.position = position.copy();
    this.windowSillPos = windowSillPos;
    this.windowSillWidth = windowSillWidth;

    velocity = direction.copy().setMag(random(5, 15));
    gravity = 1;

    radius = 5;
    lifespan = 255;
  }

  void display() {
    noStroke();
    fill(20, 100, 255, lifespan);//41, 170, 225, lifespan); //blue color that is faded based on its lifespan
    circle(position.x, position.y, radius);
  }

  void update() {
    velocity.y += gravity;

    if (position.y >= windowSillPos.y && abs(position.x - windowSillPos.x) <= windowSillWidth/2) { //collide with sill
      velocity.y = 0;     //remove the velocty in the direction to the sill
      velocity.x *= 0.9;  //add some drag from the sill
      position.y = windowSillPos.y;
      lifespan -= 2;//lower the life more quickly
    } 

    position.add(velocity);

    lifespan--;
  }

  boolean isDead() {
    if (lifespan <= 0) {
      return true;
    } else {
      return false;
    }
  }

  PVector getPos() {
    return position.copy();
  }

  void kill() {
    lifespan = 0;
  }

  float getForceDown() {
    return gravity;
  }
}



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
  color[] colorsYellow = {color(246,197,0), color(234,175,13), color(255,226,65), color(255,206,12)};
  color[] colorsRed = {color(208,78,88), color(187,67,77), color(223,102,117), color(218,92,96)};
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
    previousDirection = (int(random(0,2)) == 0) ? "Right" : "Left";
    hydratedTimer = 0;   
    mainBranchSize = 30 + int(random(-10, 10));

    //colors
    switch (int(random(0,4))) {
      case 0: currentColorPallet = colorsBrown; break;
      case 1: currentColorPallet = colorsBlue; break;
      case 2: currentColorPallet = colorsYellow; break;
      case 3: currentColorPallet = colorsRed; break;      
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

      if (branchesLengths.get(0) < float(mainBranchSize) * 0.8 && intervalSinceBranch >= BRANCH_INTERVAL) { //don't spawn a branch at the top
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



/*  -- PlantSegment Class --
 *  This Class manages the plantSegment and everything surounding it.
 *  It updates the linked list with the mass spring damperer system.
 *  Handles the interaction and draws everything.
 */

class PlantSegment {
  static final float DAMPING_CONSTANT = 0.02;
  static final float SPRING_CONSTANT = 0.02;

  color segmentColor;
  float force, velocity, angle, totalAngle, offsetAngle;
  PVector position;
  float segmentLength;
  float growAnimation;
  int growTime; //in frames

  PlantSegment segmentBellow;
  ArrayList<PlantSegment> segmentsAbove = new ArrayList<PlantSegment>();
  boolean isBottom; //if it's the bottom segment, so if it has a segment bellow it.

  PlantSegment(float segmentLength, PlantSegment segmentBellow, float offsetAngle, int growTime) {
    this.segmentLength = segmentLength;
    this.segmentBellow = segmentBellow;
    this.growTime = growTime;
    growAnimation = growTime;

    if (segmentBellow == null) {
      isBottom = true;
      force = 0;
      velocity = 0;
    } else {
      isBottom = false;
      force = segmentBellow.getForce();
      velocity = segmentBellow.getVeloctiy();
    }

    segmentColor = color(94, 135, 5); //green
    position = new PVector();

    angle = 0;
    totalAngle = 0;
    this.offsetAngle = offsetAngle;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(totalAngle); //rotates the segment to match the flowers' rotation
    stroke(segmentColor);
    strokeWeight(5);
    line(0, 0, 0, -segmentLength + segmentLength * growAnimation/growTime); //draws the line of the segment

    //reset strokeWeight
    strokeWeight(1);

    popMatrix();
  }

  void update(boolean hydrated) {
    float tempVelocity = 0;
    if (!isBottom) tempVelocity = velocity - segmentBellow.getVeloctiy(); //calculates the temp velocity to be used in the calculations. if there is a segment bellow it 

    float friction = tempVelocity * DAMPING_CONSTANT;           //calulates the friction with the velocity it's self and bellow
    angle += tempVelocity;
    force = SPRING_CONSTANT * angle + friction;                 //calculates the new force

    float forceAbove = 0;                                       //init it with 0 so if segmentsAbove is empty it's 0 and so we can sum over it.
    for (PlantSegment segment : segmentsAbove) {                 //sums the forces from all the segments above
      forceAbove += segment.getForce();
    }

    velocity += forceAbove - force;                             //calculates the new velocity with the velocity of the segments above

    if (!isBottom) { //calculate the new position
      totalAngle = angle + segmentBellow.getTotalAngle() + offsetAngle;
      position = segmentBellow.getPosition();
      position.x += -cos(-(segmentBellow.getTotalAngle() + HALF_PI)) * segmentLength;
      position.y += sin(-(segmentBellow.getTotalAngle() + HALF_PI)) * segmentLength;
    }

    if (hydrated) growAnimation();
  }

  void growAnimation() {
    //update the grow animation
    if (growAnimation > 0) growAnimation--;
  }

  void addSegmentAbove(PlantSegment segment) {
    segmentsAbove.add(segment);
  }

  void wind(float time, float windFactor) {
    float windForce = noise(position.x + time, position.y) * windFactor;
    force = windForce;
  }

  float getVeloctiy() {
    return velocity;
  }

  float getForce() {
    return force;
  }

  float getTotalAngle() {
    return totalAngle;
  }
  float getAngle() {
    return angle;
  }

  PVector getPosition() {
    return position.copy();
  }

  void setForce(float forceIn) {
    force = forceIn;
  }

  boolean isTopSegment() {
    return segmentsAbove.size() == 0;
  }
}



/*  -- Room Class --
 *  this class handels all objects inside the room and the interactions between them 
 */

class Room {

  Plant plants[] = new Plant[3];
  WaterSystem waterSystem;
  WateringCan wateringCan;
  Glass glass;
  Windows windows;

  PVector position;
  PImage[] flowerImages = new PImage[5];
  PImage tulipImage;

  float windowSillHeight;
  PImage wateringCanImage;

  Room(PVector position) {
    this.position = position;

    windowSillHeight = height*7/8 + 30;
    for (int i = 0; i < flowerImages.length; i ++) {
      flowerImages[i] = loadImage("flower" + i + ".png");
      flowerImages[i].resize(100, 0);
    }
    tulipImage = loadImage("tulip.png");
    tulipImage.resize(0, 300);

    windows = new Windows(new PVector(-width/4 - 20, 0), position);
    plants[0] = new Plant(width/2, height*3/4 + 60, 1, flowerImages, windows);
    plants[1] = new Plant(width/3, height*3/4 + 60, 1, flowerImages, windows);
    plants[2] = new Plant(width/3*2, height*3/4 + 60, 1, flowerImages, windows);

    glass = new Glass(new PVector(width*2/14, windowSillHeight), tulipImage);
    waterSystem = new WaterSystem(new PVector(position.x, windowSillHeight), width*3/4 + 150);

    wateringCanImage = loadImage("wateringCan.png");
    wateringCanImage.resize(0, 160);

    wateringCan = new WateringCan(new PVector(width*7/8 + wateringCanImage.height/2, windowSillHeight - wateringCanImage.height/2 - 60), waterSystem, wateringCanImage, windows);
  }

  void display() { //displays everything that is inside the room

    if (wateringCan.isOutside()) wateringCan.display(); //if the watering can is outside it will be displayed behind the background
    drawBackground();
    windows.display();

    for(Plant plant : plants){
      plant.display();
    }
    waterSystem.display();
    glass.display();
    if (!wateringCan.isOutside()) wateringCan.display(); //if the watering can is inside it will be displayed in front of everything
  }

  void update() { //updates everything
    for(Plant plant : plants){
      plant.update();
    }
    waterSystem.update(plants, glass);
    wateringCan.update();
    glass.update();
  }

  void clicked(float x, float y) { //manages if the user clicked
    windows.selectWindow(x, y);
    wateringCan.selectWateringCan(x, y);
  }

  void dragged(float x, float px, float y, float py) { //manages if the user dragged
    windows.moveWindow(x - px);
    wateringCan.moveWateringCan(x - px, y - py);
  }

  void released() { //manages if the user released
    windows.releaseWindow();
    wateringCan.releaseWateringCan();
  }

  void scroll(float scroll) {
    wateringCan.rotateWateringCanScroll(scroll);
  }

  void drawBackground() { //draws the background (the wall);
    pushMatrix();
    translate(position.x, position.y);
    rectMode(CENTER);

    //wall
    strokeWeight(width/8);
    stroke(195, 166, 142);
    fill(0, 0);
    rect(0, 0, width*7/8 + 100, height*7/8 + 135);

    //frame
    strokeWeight(20);
    stroke(255);
    fill(0, 0);
    rect(0, 0, width*3/4 + 80, height*3/4 + 40);

    //windowsill
    strokeWeight(20);
    stroke(191);
    rect(0, height*3/8 + 50, width*3/4 + 150, 20);    

    //reset strokeWeight
    strokeWeight(1);
    popMatrix();
  }
}


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
    if (hit) levelHeight -= 0.1; //increase the water level
    return hit;
  }

  boolean hit(PVector posIn) {
    return posIn.y >= pos.y + levelHeight && posIn.x >= pos.x && posIn.x <= pos.x + waterSize.x;
  }
}



/*  -- WateringCan Class --
 *  This Class displays and manages the watering can.
 *  It handles the interaction with the user.
 */

class WateringCan {
  static final float NOZZLE_WIDTH = 54.45;
  static final float MIN_ROTATION = 0;
  static final float MAX_ROTATION = -PI/3;

  //movement
  PVector velocity;
  float gravity;
  PVector position; 
  PVector startPosition;
  boolean isSelected;
  boolean isOutside;
  Windows windows;

  //display
  PImage wateringCanImage;

  //watering
  float angle;
  float rotationSpeed;
  boolean isWatering;
  WaterSystem waterParticleSystem;

  float windowSillHeight;
  float positionOffSetX;
  float positionOffSetY;
  PVector nozzlePosition;
  PVector nozzleDirection;

  WateringCan(PVector position, WaterSystem waterParticleSystem, PImage wateringCanImage, Windows windows) {
    this.position = position;
    this.waterParticleSystem = waterParticleSystem;
    this.wateringCanImage = wateringCanImage;
    this.windows = windows;

    //movement
    windowSillHeight = height*7/8 + 30;
    startPosition = position.copy();
    velocity = new PVector(0, 0);
    gravity = 0.1;
    isSelected = false;

    //watering
    isWatering = false;
    angle = 0;
    rotationSpeed = 0.025;

    positionOffSetX = -90;
    positionOffSetY = 60;

    nozzleDirection = PVector.fromAngle(radians(165)).setMag(20);
    nozzlePosition = new PVector(-60 + nozzleDirection.x, 160 + nozzleDirection.y);
  }

  void display() { //draws the watering can
    //adds particles to the watering can
    if (isWatering) {
      waterParticleSystem.addParticle(PVector.add(nozzlePosition, position), nozzleDirection.copy(), NOZZLE_WIDTH);
    }

    //watering can
    pushMatrix();
    translate(position.x, position.y);
    if (isOutside) scale(0.9);
    rotate(angle);   
    image(wateringCanImage, positionOffSetX, positionOffSetY);
    popMatrix();
  }

  void update() { //updates the watering can
    if ((!isSelected && !isOnWindowSill())) { //if the watering can is not selected and also not on the window sill gravity will be added
      velocity.y += gravity;
      if (position.y > height + wateringCanImage.height) {//once the watering can is outside the screen make it fall back in
        isOutside = false;
        position = new PVector(startPosition.x, -wateringCanImage.height);
      }
    }

    if (isOnWindowSill() && !isSelected) position.y = startPosition.y; //sets position to the height of the window sill

    if (isOnWindowSill() || isSelected) velocity.y = 0; //sets velocity to 0

    rotateWateringCan();

    position.add(velocity);
  }

  void selectWateringCan(float x, float y) { //selects the watering can
    if (isOverWateringCan(x, y)) isSelected = true;
  }

  void moveWateringCan(float deltaX, float deltaY) { //moves the watering can
    if (isSelected) {
      PVector deltaPosition = new PVector(deltaX, deltaY);
      position.add(deltaPosition);

      isOutside = isInsideWindow();
    }
  }

  void releaseWateringCan() { //releases the watering can
    isSelected = false;
  }

  void rotateWateringCan() { //rotates the watering can back if released
    if (!isSelected) {
      angle += rotationSpeed * 2;
      if (angle > MIN_ROTATION) angle = MIN_ROTATION;
    } 

    if (angle < MAX_ROTATION) angle = MAX_ROTATION;
    if (angle > MIN_ROTATION) angle = MIN_ROTATION;

    if (angle == MAX_ROTATION) isWatering = true;
    else isWatering = false;

    if (angle < MAX_ROTATION) angle = MAX_ROTATION;
    if (angle > MIN_ROTATION) angle = MIN_ROTATION;
  }

  void rotateWateringCanScroll(float scroll) {
    angle -= scroll * 0.1;
  }

  boolean isOnWindowSill() {//checks if the watering can is standing on the window sill
    //if the window is open and the watering can is placed inside the left window
    //the watering can will be plased outside so it is not on the window sill

    if (isOutside) return false;
    else {
      return  position.x - 9 > width/8 - 85 &&
        position.x - 119 < width*7/8 + 85 &&
        position.y >= startPosition.y &&
        position.y < startPosition.y + 20;
    }
  }

  boolean isOverWateringCan(float x, float y) { //checks if the mouse is on the watering can
    return (x > position.x - wateringCanImage.width/2 + positionOffSetX && 
      x < position.x + wateringCanImage.width/2 + positionOffSetX && 
      y > position.y - wateringCanImage.height/2 + positionOffSetY && 
      y < position.y + wateringCanImage.height/2 + positionOffSetY);
  }

  boolean isInsideWindow() { //checks if the watering can is inside the left window
    return position.x - wateringCanImage.width/2 + positionOffSetX > width/8 - 30 &&
      position.x + wateringCanImage.width/2 + positionOffSetX < windows.getPosWindowLeft() - 10 &&
      position.y + wateringCanImage.height/2 + positionOffSetY <  height*7/8 + 10 &&
      position.y - wateringCanImage.height/2 + positionOffSetY > height/8 - 10;
  }

  boolean isOutside() { //checks if the watering can is outside (the window)
    return isOutside;
  }
}


/*  -- WaterSegment Class --
 *  This Class displays, the water at the points and interact with the other segments through surface. 
 *  Adapted from topic 6 assignment 6.6, made by Ysbrand Burgstede, Frank Bosman.
 */

class WaterSegment {
  PVector pos;
  float heightOffset;
  float radius;
  float speed;
  float acceleration;
  static final float springConst = 0.01;
  static final float frictionConst = 0.01;
  int mass = 1;
  float force;
  Surface surface;

  WaterSegment(PVector pos, float radius, Surface surface) {
    this.pos = pos;
    this.radius = radius;
    this.surface = surface;
    heightOffset = 0; //the offset from the default water level
  }

  void display() { //draws the segment
    curveVertex(pos.x, pos.y + heightOffset + surface.levelHeight);
  }

  void updateForces(float forceLeft, float forceRight) { //only update the forces
    float springForce = -heightOffset * springConst;
    float friction =  -frictionConst * speed;  

    force = springForce + friction + forceLeft + forceRight; //the neto force on the segment

    acceleration = force/mass;
  }

  void updateMovement() { //update the speed and position
    speed += acceleration;
    heightOffset += speed;
  }

  void addForce(float force) {//add force to the segment
    acceleration = force/mass;

    speed += acceleration;
  }

  float distance(float x, float y, PVector posWater) { //calcs the distance between 
    return dist(x, y, pos.x+ posWater.x, pos.y + posWater.y + heightOffset + surface.levelHeight);
  }

  PVector getPos() {
    return new PVector(pos.x, pos.y + heightOffset + surface.levelHeight);
  }

  PVector distVect(PVector otherPos) { //the distance vector from this segment to the other
    PVector distVect = getPos().sub(otherPos);
    return distVect;
  }

  float getHeightOffset() { //return the offset from the default water levels, used in calculating the spring force
    return heightOffset;
  }

  float getSpringForce(float fromHeight) { //caluclates the spring force
    return (heightOffset - fromHeight) * springConst;
  }
}


/*  -- WaterSystem Class --
 *  This Class handels the particle system
 *  Adapted from Topic 4 Assignment 1 made by Marnix Lueb and Sterre Kuijper 
 */

class WaterSystem {
  ArrayList<Particle> particles;
  PVector windowSillPos;
  float windowSillWidth;

  WaterSystem(PVector windowSillPos, float windowSillWidth) {
    particles = new ArrayList<Particle>();

    this.windowSillPos = windowSillPos;
    this.windowSillWidth = windowSillWidth;
  }

  void display() {
    for (Particle particle : particles) {
      particle.display();
    }
  }

  void update(Plant[] plants, Glass glass) {
    for (int i = particles.size() - 1; i >= 0; i--) { //update the particles
      Particle particle = particles.get(i);
      particle.update();

      //test if the particle hit a flower pot, and hydrate that plant
      for(Plant plant : plants){
        if (plant.isInFlowerPot(particle.getPos())) {
          plant.hydrate();
          particle.kill();
        }
      }

      //test if the particle hits the surface
      if (glass.surface.hit(particle.getPos())) {
        if (glass.surface.addAreaForce(particle.getPos().x, particle.getPos().y, int(particle.radius*2), particle.getForceDown()/10)) particle.kill(); //check if it actually hit an segment of the surface and then removes itself.
      }

      //test if the particle hit the glass
      glass.collide(particle);

      if (particle.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle(PVector position, PVector direction, float nozzleWidth) {

    PVector offset = direction.copy().normalize().rotate(HALF_PI).setMag(map(randomGaussian()/2, -1.5, 1.5, -nozzleWidth/2, nozzleWidth/2)); //give the particles a random tangent offset
    offset.limit(nozzleWidth/2);
    direction.rotate(map(randomGaussian()/2, -1.5, 1.5, -PI/8, PI/8)); 

    particles.add(new Particle(new PVector(position.x + offset.x, position.y + offset.y), direction, windowSillPos, windowSillWidth));
  }
}



/*  -- Windows Class --
 *  This Class displays the windows and manages the left window.
 *  It handles the interaction with the left window.
 */

class Windows {

  PVector position;
  PVector positionLeftWindow;

  boolean isSelected;

  Windows(PVector positionLeftWindow, PVector position) {
    this.positionLeftWindow = positionLeftWindow;
    this.position = position;
    isSelected = false;
  }

  void display() {
    //drawing of all the windows
    pushMatrix();
    translate(position.x, position.y);

    //window left
    pushMatrix();
    translate(positionLeftWindow.x, positionLeftWindow.y);    

    //strokes over the window
    pushMatrix();
    translate(-positionLeftWindow.x, -positionLeftWindow.y);
    noStroke();
    fill(227, 246, 250, 63);
    //stroke 1
    beginShape();
    vertex(positionLeftWindow.x + 10 - width/8, 50 - (1 - (positionLeftWindow.x + 20)/(-width/4 - 20))*250);
    vertex(positionLeftWindow.x + 10 - width/8, 100 - (1 - (positionLeftWindow.x + 20)/(-width/4 - 20))*250);
    vertex(-width/8 - 10, -150);
    vertex(-width/8 - 10, -200);
    endShape();    
    //stroke 2
    beginShape();
    vertex(positionLeftWindow.x + 10 - width/8, 150 - (1 - (positionLeftWindow.x + 20)/(-width/4 - 20))*250);
    vertex(positionLeftWindow.x + 10 - width/8, 250 - (1 - (positionLeftWindow.x + 20)/(-width/4 - 20))*250);
    vertex(-width/8 - 10, 0);
    vertex(-width/8 - 10, -100);
    endShape();
    popMatrix();

    //glass with frame
    strokeWeight(20);
    stroke(223);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    //grey lines
    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //handle
    strokeWeight(7);
    stroke(63);
    line(-width/8, -50, -width/8, 50);
    popMatrix();

    //window center
    pushMatrix();
    translate(0, 0);

    //glass with frame
    strokeWeight(20);
    stroke(255);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //stroke over the window        
    noStroke();
    fill(227, 246, 250, 63);
    //stroke 1
    beginShape();
    vertex(-width/8 + 10, 50);
    vertex(-width/8 + 10, 100);
    vertex(width/8 - 10, -150);
    vertex(width/8 - 10, -200);
    endShape();
    //stroke 2
    beginShape();
    vertex(-width/8 + 10, 150);
    vertex(-width/8 + 10, 250);
    vertex(width/8 - 10, 0);
    vertex(width/8 - 10, -100);
    endShape();
    popMatrix();

    //window right
    pushMatrix();
    translate(width/4 + 20, 0);

    //glass with frame
    strokeWeight(20);
    stroke(255);
    fill(86, 193, 235, 63);
    rect(0, 0, width/4, height*3/4);

    //grey lines
    strokeWeight(1);
    stroke(191);
    fill(0, 0);
    rect(0, 0, width/4 + 15, height*3/4 + 15);

    //stroke over the window
    noStroke();
    fill(227, 246, 250, 63);
    //stroke 1
    beginShape();
    vertex(-width/8 + 10, 50);
    vertex(-width/8 + 10, 100);
    vertex(width/8 - 10, -150);
    vertex(width/8 - 10, -200);
    endShape();
    //stroke 2
    beginShape();
    vertex(-width/8 + 10, 150);
    vertex(-width/8 + 10, 250);
    vertex(width/8 - 10, 0);
    vertex(width/8 - 10, -100);
    endShape();
    popMatrix();

    popMatrix();
  }

  boolean windowIsOpen() { //checks if the left window is open
    return  positionLeftWindow.x == -40.0;
  }
  float getPosWindowLeft() { //gets the position of the left window
    return PVector.add(position, positionLeftWindow).x - width/8;
  }

  void selectWindow(float x, float y) { //user clicks on the window to select it
    if (isOverHandle(x, y)) isSelected = true;
  }

  void moveWindow(float delta) { //user dragges the window to move it left and right
    if (isSelected) {
      positionLeftWindow.x += delta;
      if (positionLeftWindow.x > -40) positionLeftWindow.x = -40;
      if (positionLeftWindow.x < -width/4 - 20) positionLeftWindow.x = -width/4 - 20;
    }
  }

  void releaseWindow() { //user releases the window
    isSelected = false;
  }

  boolean isOverHandle(float x, float y) { //checks if the user is over the handle
    return (x > position.x + positionLeftWindow.x - width/8 - 7 && 
      x < position.x + positionLeftWindow.x - width/8 + 7 && 
      y > position.y + positionLeftWindow.y - 55 && 
      y < position.y + positionLeftWindow.y + 55);
  }
}
