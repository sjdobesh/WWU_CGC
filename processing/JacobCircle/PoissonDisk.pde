// Poisson sampling source:

// http://thecodingtrain.com
// Poisson Disc Sampling: https://youtu.be/flQgnCUxHl
// Processing port by Max: https://github.com/TheLastDestroyer

// Converted to an object

public class PoissonDisk {

  int k;
  float r, w;
  int cols, rows;
  PVector[] grid;
  ArrayList<PVector> active;
  ArrayList<PVector> ordered;

  public PoissonDisk(float r, int k) {
    this.r = r;
    this.k = k;
    this.w = r / 1.41421356237;
    this.cols = floor(width / w);
    this.rows = floor(height / w);
    this.grid = new PVector[cols*rows];
    this.active = new ArrayList<PVector>();
    this.ordered = new ArrayList<PVector>();
    for (int i = 0; i < cols * rows; i++) {
      grid[i] = null;
    }

    // STEP 1
    float x = width / 2;
    float y = height / 2;
    int i = floor(x / w);
    int j = floor(y / w);
    PVector pos = new PVector(x, y);
    this.grid[i + j * cols] = pos;
    this.active.add(pos);
  }

  public ArrayList<PVector> sample(float container_r) {
    for (int total = 0; total < 25; total++) {
      if (active.size() > 0) {
        int randIndex = floor(random(active.size()));
        PVector pos = active.get(randIndex);
        boolean found = false;
        for (int n = 0; n < k; n++) {
          PVector sample = PVector.random2D();
          float m = random(r, 2 * r);
          sample.setMag(m);
          sample.add(pos);
          int col = floor(sample.x / w);
          int row = floor(sample.y / w);
          if (col > -1 && row > -1 && col < cols && row < rows && grid[col + row * cols] == null) {
            boolean ok = true;
            for (int i = -1; i <= 1; i++) {
              for (int j = -1; j <= 1; j++) {
                int index = (col + i) + (row + j) * cols;
                PVector neighbor = grid[index];
                if (neighbor != null) {
                  float d = PVector.dist(sample, neighbor);
                  if (d < r) {
                    ok = false;
                  }
                }
                float container = PVector.dist(sample, new PVector(width/2, height/2));
                if (container > container_r * width / 2) {
                  ok = false;
                }
              }
            }
            if (ok) {
              found = true;
              this.grid[col + row * cols] = sample;
              this.active.add(sample);
              this.ordered.add(sample);
              break;
            }
          }
        }
      }
    }
    return this.ordered;
  }

  public ArrayList<PVector> fill_disk(float r_scl, int tolerance) {

    boolean full    = false;
    int error_count = 0;
    int last_size;

    while (!full) {
      last_size = ordered.size();
      this.sample(r_scl);
      if (this.ordered.size() == last_size) {
        error_count++;
      }
      else {
        error_count = 0;
      }
      if (error_count > tolerance)
      {
        full = true;
      }
    }
    this.ordered.add(new PVector(width/2, height/2));
    return this.ordered;
  }
}
