class Flock {

  ArrayList<Bird> bird;

  Flock() {
    bird = new ArrayList<Bird>();
  }

  void run() {
    for (Bird b : bird) {
      b.run(bird);
    }
  }

  void addBird(Bird b) {
    bird.add(b);
  }
}
