PImage src;
ArrayList<PVector> points = new ArrayList<PVector>();
float segmentSize;

void setup() {
  size(displayHeight, displayHeight);

  src = loadImage("src.jpg");
  src.resize(width, height);

  segmentSize = width / 10;

  for (int x = 0; x < width; x += segmentSize) {
    for (int y = 0; y < height; y += segmentSize) {
      points.add(new PVector(x, y));
    }
  }
}

void draw() {
  if (points.size() > 0) {
    PVector p = points.get(0);
    int c = src.get((int) p.x, (int) p.y);
    String h = hex(c, 6);
    JSONArray images = loadJSONArray("http://api.artbinderviewer.com/api/search/ColorSearch?colors=" + h);
    int r = floor(random(5));
    JSONObject image = images.getJSONObject(r);
    PImage img = loadImage(image.getString("imgURL"));
    pushMatrix();
    translate(p.x, p.y);
    rotate(45);
    image(img, 0, 0, segmentSize, segmentSize);
    popMatrix();
    points.remove(0);
  } else {
    long unixTime = System.currentTimeMillis() / 1000L;
    save("output/" + unixTime + ".png");
    noLoop();
  }
}