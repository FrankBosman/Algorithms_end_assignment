
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
