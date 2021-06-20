
/*  -- Flock Class --
 *  This Class displays the flower and manages the growing animation 
 *  Adopted from Topic 5 assignment 2 made by Marnix Lueb and Frank Bosman
 */

class Flock{
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
    PVector acceleration = new PVector(0,0);
    
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
    PVector avoidance = new PVector(0,0);
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
    PVector seperation = new PVector(0,0);
    PVector position = bird.getPos();
    if (nearbyBirds.size()>0) {
        for (Bird otherBird : nearbyBirds) {
            if (PVector.dist(position, otherBird.getPos()) <= bird.radius * 2 + otherBird.radius * 2) {//radius*8 is the seperation distance, that's when the birds almost hit eachother
                seperation.add(PVector.sub(position,otherBird.getPos()).normalize().setMag(1 / PVector.dist(position,otherBird.getPos())));
            }
        }
        seperation.mult(10);
    }
    return seperation;
  }
    
    
  //Cohesion
  PVector cohesion(ArrayList<Bird> nearbyBirds, PVector position) {
      PVector middle = new PVector(0,0);
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
      PVector direction = new PVector(0,0);
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
