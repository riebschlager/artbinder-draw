PImage src;
PGraphics guide, canvas;
PVector guideStart, guideEnd;
boolean isGuideOn = false;
float angle, distance;
ArrayList<Integer> colorList = new ArrayList<Integer>();

void setup() {
  size(displayHeight, displayHeight);

  src = loadImage("http://img.ffffound.com/static-data/assets/6/ae454cc89526e8a7a62923cc9898dea8d127c425_m.jpg");
  src.resize(width, height);

  guide = createGraphics(width, height);
  guide.beginDraw();
  guide.clear();
  guide.endDraw();

  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.clear();
  canvas.endDraw();
}

void draw() {
  background(255);

  for (float i = 0; i < TWO_PI; i+= TWO_PI / 6) {
    pushMatrix();
    translate(width/2, height/2);
    rotate(i);
    image(canvas, 0, 0);
    popMatrix();
  }

  if (isGuideOn) {
    image(guide, 0, 0);
  }
}

void pickAndPaint() {
  JSONArray images = loadJSONArray("http://api.artbinderviewer.com/api/search/ColorSearch?colors=" + hexString());
  int r = floor(random(10));
  JSONObject image = images.getJSONObject(r);
  PImage img = loadImage(image.getString("imgURL"));
  canvas.beginDraw();
  canvas.pushMatrix();
  canvas.translate(guideStart.x, guideStart.y);
  canvas.rotate(angle);
  canvas.image(img, 0, 0, -distance, -distance);
  canvas.popMatrix();
  canvas.endDraw();
}

String hexString() {
  String s = "";
  for (int i = 0; i < 5; i++) {
    int r = floor(random(colorList.size()));
    int c = colorList.get(r);
    s += hex(c, 6);
    if (i < 4) {
      s += ",";
    }
  }
  return s;
}

void keyPressed() {
  long unixTime = System.currentTimeMillis() / 1000L;
  canvas.save("output/" + unixTime + ".png");
}

void mousePressed() {
  isGuideOn = true;
  guideStart = new PVector(mouseX, mouseY);
  colorList.clear();
}

void mouseReleased() {
  isGuideOn = false;
  pickAndPaint();
}

void mouseDragged() {
  colorList.add(src.get(mouseX, mouseY));
  guideEnd = new PVector(mouseX, mouseY);
  angle = (float) Math.atan2(guideStart.y - guideEnd.y, guideStart.x - guideEnd.x);
  guide.beginDraw();
  guide.pushMatrix();
  guide.clear();
  guide.noFill();
  guide.stroke(255, 0, 0);
  guide.translate(guideStart.x, guideStart.y);
  guide.rotate(angle);
  distance = dist(guideStart.x, guideStart.y, guideEnd.x, guideEnd.y);
  guide.rect(0, 0, -distance, -distance);
  guide.popMatrix();
  guide.endDraw();
}