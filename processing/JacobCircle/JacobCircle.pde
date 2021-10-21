PGraphics bg;
PoissonDisk disk_sampler;
ArrayList<PVector> points;
float r           = 10;
int k             = 20;
int max_error     = 50;
float r_scl       = 0.8;
float yoff        = 0;
float zoff        = 0;
float woff        = 0;
float noise_scale = 0.007;
float fade_str    = 20;
float n_loop_r    = 100;
float strength    = 10;
// recording
boolean recording = false;
int frames        = 720;
int framecount    = 0;

void setup() {
  size(800, 800);
  frameRate(60);
  background(0);
  strokeWeight(1.5);
  stroke(255);
  noFill();
  bg = createGraphics(width, height);

  disk_sampler = new PoissonDisk(r, k);
  points = disk_sampler.fill_disk(r_scl, max_error);
  points.add(new PVector(width/2, height/2));
}

void draw() {
  background_fade();
  show_points(displace_points(strength));
  make_circle();
  update_offsets();
  display_text();
  framecount++;
  if (recording && framecount > frames) {
    saveFrame("imgsqnc/frame####.png");
    if (framecount == frames * 2) {
      noLoop();
    }
  }
}

// variable controls
void keyPressed() {
  if (key == CODED) {
    textSize(30);
    if (keyCode == UP) {
      strength++;
      fill(0, 255, 0);
      text("++", (width / 20) * 6, height/20);
    }
    else if (keyCode == DOWN) {
      strength--;
      fill(255, 0, 0);
      text("--", (width / 20) * 6, height/20);
    }
    if (keyCode == RIGHT) {
      noise_scale += 0.00005;
      fill(0, 255, 0);
      text("++", (width / 20) * 6, 2 * height/20);
    }
    else if (keyCode == LEFT) {
      noise_scale -= 0.00005;
      fill(255, 0, 0);
      text("--", (width / 20) * 6, 2 * height/20);
    }
  }
}

void display_text() {
  textSize(24);
  fill(255);
  text("Strength - U/D : ", width/20, height/20);
  text("Scale       - L/R : ", width/20, 2*height/20);
}

void background_fade() {
  bg.beginDraw();
  bg.background(0, fade_str);
  bg.endDraw();
  image(bg, 0, 0);
}
void update_offsets() {
  yoff += 0.0;
  zoff += PI/(frames/2);
  woff += PI/(frames/2);
}

ArrayList<PVector> displace_points(float strength) {
  float noise_sample, factor1, factor2;
  float s, a, m, c, w; // for sombrero map
  PVector v_disp;
  ArrayList<PVector> displaced_points = new ArrayList<PVector>();
  for (PVector p : points) {
    noise_sample = noise(p.x, p.y + yoff, zoff, woff);
    // sphere
    factor1 = 1 - (pow(1/(r_scl * width/2), 2) * pow(p.x - width/2, 2))
                - (pow(1/(r_scl * height/2), 2) * pow(p.y - height/2, 2));
    // sombrero
    w = 1 / (r_scl - 0.1);
    c = 0.22;
    a = 0.01125 * w;
    m = 4.5  * w;
    s = 0.5;
    factor2 = c + (s * (sin(sqrt(pow(a * p.x - m, 2)
                               + pow(a * p.y - m, 2)))
                          / sqrt(pow(a * p.x - m, 2)
                               + pow(a * p.y - m, 2))));

    // swirly displacement
    // v_disp = PVector.fromAngle(map(noise_sample, -1, 1, 0, 2*PI));
    // v_disp.mult(strength * factor1 * factor2);

    // vertical displacement
    // noise_sample = map(noise_sample, -1, 1, 0, 1);
    // v_disp = new PVector(0, -noise_sample);
    // v_disp.mult(strength * factor1 * factor2);

    // center
    // noise_sample = map(noise_sample, -1, 1, 0, 1);
    // // v_disp = PVector.sub(new PVector(width/2, height/2), p);
    // v_disp = PVector.sub(p, new PVector(width/2, height/2));
    // v_disp.mult(strength * factor1 * factor2 * noise_sample * 0.1);

    // dot
    v_disp = PVector.fromAngle(map(noise_sample, -1, 1, 0, 2*PI));
    v_disp.mult(strength * factor1 * factor2);
    v_disp.mult(0.01 * v_disp.dot(PVector.sub(p, new PVector(width/2, height/2))));

    displaced_points.add(new PVector(p.x + v_disp.x, p.y + v_disp.y));
  }
  return displaced_points;
}

void show_points(ArrayList<PVector> displaced_points) {
  stroke(255);
  fill(255);
  strokeWeight(r * 0.2);
  for (int i = 0; i < displaced_points.size(); i++) {
    point(displaced_points.get(i).x, displaced_points.get(i).y);
  }
}

void make_circle() {
  noFill();
  strokeWeight(1);
  ellipse(width/2, height/2, width * r_scl, height * r_scl);
}

// override built in noise function
float noise(float x, float y, float z, float w) {
  return (float)SimplexNoise.noise((double)(x * noise_scale),
                                   (double)(y * noise_scale),
                                   (double)(n_loop_r * cos(z) * noise_scale),
                                   (double)(n_loop_r * sin(w) * noise_scale));
}
