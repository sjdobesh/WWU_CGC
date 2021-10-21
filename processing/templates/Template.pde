//------------------------------------------------------------------------------
// Samuel Dobesh
// Pretty Processing Template
//------------------------------------------------------------------------------

PGraphics bg;
ArrayList<PVector> points;
float noise_scl = 0.007;
float noise_d   = 100;
float fade_str  = 20;

// main
//------------------------------------------------------------------------------

void setup() {
  size(800, 800);
  frameRate(60);
  background(0);
  bg = createGraphics(width, height);
  points = makePoints();
}

void draw() {
  background_fade();
  update_points(points);
  show_points(points);
}

//------------------------------------------------------------------------------

ArrayList<PVector> make_points() {
  ArrayList<PVector> points = new ArrayList<PVector>(0, 0);

  // do stuff

  return points;
}

ArrayList<PVector> update_points(points) {
  for (PVector p : points) {

    // do stuff

  }
  return points;
}

void show_points(ArrayList<PVector> points) {
  stroke(255);
  fill(255);
  strokeWeight(1);
  for (PVector p : points) {
    point(p.x, p.y);
  }
}

void background_fade() {
  bg.beginDraw();
  bg.background(0, fade_str);
  bg.endDraw();
  image(bg, 0, 0);
}

float noise(float x, float y, float z, float w) {
  return (float)SimplexNoise.noise((double)(x * noise_scl),
                                   (double)(y * noise_scl),
                                   (double)(noise_d * cos(z) * noise_scl),
                                   (double)(noise_d * sin(w) * noise_scl));
}
