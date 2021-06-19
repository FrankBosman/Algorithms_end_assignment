class ParticleSystem {

  ArrayList<Particle> particles;  

  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }

  void update() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle(PVector position) {
    particles.add(new Particle(new PVector(position.x, position.y)));
  }
}
