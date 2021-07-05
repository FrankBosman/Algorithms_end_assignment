class Bird {

  PImage birdImage;

  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxVelocity;
  float maxForce;

  Bird(PVector position, PImage birdImage) {
    acceleration = new PVector(0, 0);
    velocity = PVector.random2D().setMag(10);
    this.position = position;
    maxVelocity = 3;
    maxForce = 0.05;

    this.birdImage = birdImage;
  }
  
  void run(ArrayList<Bird> bird) {
    flock(bird);
    update();
    borders();
    display();
  }

  void display() {
    float theta = velocity.heading() + radians(180);
    int scale = 1;
    
    if(theta < HALF_PI) {
      scale *= -1;
    }
    
    pushMatrix();
    translate(position.x, position.y);
    scale(scale);
    rotate(theta);
    image(birdImage, 0, 0);
    popMatrix();
  }
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxVelocity);
    position.add(velocity);
    acceleration.mult(0);
  }
  
  void borders() {
    if (position.x < - birdImage.width) position.x = width + birdImage.width;
    if (position.y < - birdImage.height) position.y = height + birdImage.height;
    if (position.x > width + birdImage.width) position.x = -birdImage.width;
    if (position.y > height+ birdImage.height) position.y = -birdImage.height;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void flock(ArrayList<Bird> bird) {
    PVector sep = separate(bird);   // Separation
    PVector ali = align(bird);      // Alignment
    PVector coh = cohesion(bird);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(5);
    ali.mult(3);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum velocity
    desired.normalize();
    desired.mult(maxVelocity);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);  // Limit to maximum steering force
    return steer;
  }

  PVector separate (ArrayList<Bird> bird) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Bird other : bird) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxVelocity);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Bird> bird) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Bird other : bird) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxVelocity);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby bird, calculate steering vector towards that position
  PVector cohesion (ArrayList<Bird> bird) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Bird other : bird) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }
}
