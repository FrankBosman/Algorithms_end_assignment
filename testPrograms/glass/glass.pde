
GlassWater glass;

void setup() {
  size(500, 500);
  rectMode(CENTER);
  glass = new GlassWater(new PVector(width/2, height/2));  
}

void draw() {
  background(255);
  glass.display();
  
}
