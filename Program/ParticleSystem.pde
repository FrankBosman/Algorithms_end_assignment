
/*  -- ParticleSystem Class --
 *  This Class handels the particle system
 *  Adapted from Topic 4 Assignment 1 made by Marnix Lueb and Sterre Kuijper 
 */

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector windowStillPos;
  float windowStillWidth;
  Plant plant;
  Glass glass;

  ParticleSystem(PVector windowStillPos, float windowStillWidth, Plant plant, Glass glass) {
    particles = new ArrayList<Particle>();

    this.windowStillPos = windowStillPos;
    this.windowStillWidth = windowStillWidth;
    this.plant = plant;
    this.glass = glass;
  }

  void display() {
    for (Particle particle : particles) {
      particle.display();
    }
  }

  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) { //update the particles
      Particle particle = particles.get(i);
      particle.update();

      //test if the particle hit the flower pot
      if (plant.isInFlowerPot(particle.getPos())) {
        plant.hydrate();
        particle.kill();
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

    particles.add(new Particle(new PVector(position.x + offset.x, position.y + offset.y), direction, windowStillPos, windowStillWidth));
  }
}
