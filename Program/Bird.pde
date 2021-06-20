// Bird class, this class is the bird, and is controlled by the flock
class Bird{

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
        currentFrame = int(random(0,birdAnimation.length));
        animationTimer = 0;
        
        //give the bird a random speed vector
        speed = PVector.random2D().setMag(speedLimit);
        radius = int(random(10,20));
   }
    
    void display() {
        pushMatrix();
        translate(position.x,position.y);
        
        //rotate the image to the direction he's flying
        if(speed.x <= 0) {
            scale(1, -1);
            rotate(-speed.heading());
        } else rotate(speed.heading());

        //draws the bird at the current frame of it's animation
        image(birdAnimation[currentFrame], 0, 0, radius*2, radius*2);

        //loop one frame further.
        animationTimer += 1/frameRate;
        if(animationTimer >= ANIMATION_SPEED){
            currentFrame++;
            if(currentFrame >= birdAnimation.length) currentFrame = 0;
            animationTimer = 0;
        }

        popMatrix();
    }

    void updateSpeed(PVector acceleration){
        speed.add(acceleration.mult(1/frameRate * SPEED_FACTOR));        //adds the acceleration to the speed
        speed.limit(speedLimit);  //limits the speed of the bird
        position.add(speed.copy().mult(1/frameRate * SPEED_FACTOR));
    }

    PVector getPos(){
        return position.copy();
    }

    PVector getSpeed(){
        return speed.copy();
    }    
}