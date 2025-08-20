public class Set {
  public void run() {};
  public void reset() {};
}

public class Set0 extends Set {
  color COL;
  float iter;
  int h;
  int r;
  int WEIGHT;
  int count;

  Set0() { 
    reset();
  }
  
  private void drawGuy(float x, float y) {
    pushMatrix();
    noStroke();
    fill(COL);
    translate(x, y);
    ellipseMode(CENTER);
    ellipse(0, -h, h, h);
    ellipse(0, 0, h, h);
    rectMode(CENTER);
    rect(0, h*0.5, h, h);
    popMatrix();
  }
  
  private void drawArrow(float base) {
    float buffer = (2*PI / count);
    pushMatrix();
    noFill();
    stroke(COL);
    strokeWeight(13);
    arc(0, 0, r*2, r*2, 
      iter + base + buffer/5, 
      iter + base + buffer - buffer/5 );
    
    noStroke();
    fill(COL);
    rotate(base + iter - buffer/5);
    translate(r, -WEIGHT);
    rotate(PI/4);
    rect(0, WEIGHT, WEIGHT*3, WEIGHT);
    rotate(-PI/2);
    rect(0, WEIGHT, WEIGHT*3, WEIGHT);
    
    popMatrix();
  }
  
  public void reset() {
    count = ceil(random(5)) + 1;
    iter = 0;
    h = 30;
    r = width / 5;
    WEIGHT = 13;
    COL = currColor[floor(random(100)) % currColor.length];
  }
  
  public void run() {
    pushMatrix();
    fill(COL);
    noStroke();
    translate(width/2, height/2);
    for (int i = 0; i < count; i++) {
      float tmp1 = iter - i*(2*PI/count);
      drawGuy(cos(tmp1) * r, sin(tmp1) * r);
      float tmp2 = i * (2*PI / count);
      drawArrow(tmp2);
    }
    iter += 0.01;
    popMatrix();
  }
}

public class Set1 extends Set {
  int iter;
  int max;
  int seed;
  int speed;
  
  Set1() {
    reset();
  }
  
  public void reset() {
    iter = 1;
    max = floor(random(5)) + 3;
    seed = floor(random(100));
    speed = 30;
  }
  
  public void run() {
    rectMode(CORNER);
    int w = width / max;
    for (int i = 0; i < floor(iter / speed); i++) {
      fill(currColor[(i + seed) % currColor.length]);
      strokeWeight(15);
      stroke(base);
      rect(w * i, 0, w, height);
    }  
    iter++;
    
    if ((iter - speed) > max * speed)
      reset();
  }
}

public class Set2 extends Set {
  int rects;
  int[] widths;
  int[] speeds;
  int seed;
  
  int initSpeed;
  
  Set2() {
    reset();
  }
  
  public void reset() {
    initSpeed = 10 - rects;
    rects = floor(random(3)) + 2;
    widths = new int[rects];
    speeds = new int[rects - 1];
    seed = floor(random(100));
    Arrays.fill(widths, width / rects);
    for (int i = 0; i < rects - 1; i++) {
      int jitter = floor(random(width / rects) - (width / (rects*2)));
      widths[i] += jitter;
      widths[i+1] -= jitter;
      int tmp = floor(random(initSpeed)) + 5;
      if (random(1) < 0.5)
        speeds[i] = -tmp;
      else 
        speeds[i] = tmp;
    } 
  }
  
  public void run() {
    rectMode(CORNER);
    int pt = 0;
    for (int i = 0; i < rects; i++) {
      fill(currColor[(i + seed) % currColor.length]);
      strokeWeight(15);
      stroke(base);
      rect(pt, 0, widths[i], height);
      pt += widths[i];
    }  
    boolean reset = false;
    for (int i = 0; i < rects - 1; i++) {
      widths[i] += speeds[i];
      widths[i+1] -= speeds[i];
      if (widths[i] < 0 || widths[i] > width)
        reset = true;
    }
    if (reset)
      reset();
  }
}

public class Set3 extends Set {
  String str = "abcdefghijklmnoπrstuvwx¥z1234567890";
  int interval;
  int vert = floor(height * 3/4);
  int initSize = 30;
  float damping = 8;
  float[] smoothing;
  
  int start = 0;
  int startingLetter = 0;
  int scrollSpeed;
  
  Set3() {
    smoothing = new float[str.length()];
    Arrays.fill(smoothing, initSize);
    scrollSpeed = 1;
  }
  
  public void run() {
    interval = floor((width + initSize) / str.length());
    
    for (int i = 0; i < str.length(); i++) {
      int curr = (i + startingLetter) % str.length();
      float val = fft.spectrum[curr] * 10000;
      smoothing[curr] += (val - smoothing[curr]) / damping;
      textSize(smoothing[curr]);
      textFont(camera, smoothing[curr]);
      fill(0);
      text(str.charAt((i + startingLetter) % str.length()), (i * interval) - start, vert);
    }  
    start += scrollSpeed;
    if (abs(start) > interval) {
      start = 0;
      startingLetter++;
    }
  }
}

public class Set4 extends Set {
  
  int upperBound = 22;
  int lowerBound = 5;
  int squareSide;
  int h;
  int w;
  int xs;
  int iter;
  
  int scrollSpeed;
  
  boolean[] bools;
  
  Set4() {
    reset();
  }
  
  private void colors() {
    Arrays.fill(bools, false);
    for (int i = 0; i < bools.length; i++)
      if (random(1) < 0.1)
        bools[i] = true;
  }
  
  public void reset() {
    xs = ceil(random(upperBound) + lowerBound);
    iter = 1;
    scrollSpeed = 1;
    bools = new boolean[1000];
    colors();
    
  }
  
  public void run() {
    squareSide = ceil(width / xs);
    
    h = floor(squareSide * 0.8);
    w = floor(h / 6);
    for (int i = 0; i < ceil(height / squareSide) + 1; i++) {
      for (int j = 0; j < xs + 1; j++) {
        int curr = i * xs + j;
        if (curr > floor(iter / scrollSpeed))
          break;
        else if (j == xs && i == floor(height / squareSide))
          reset();
        if (bools[curr]) {
          
          fill(0);
          pushMatrix();
          noStroke();
          translate(j * squareSide + (squareSide / 2), i * squareSide + (squareSide / 2));
          rotate(radians(45));
          rectMode(CENTER);
          rect(0, 0, h, w);
          rotate(radians(90));
          rect(0, 0, h, w);
          popMatrix();
        }
      }
      
    }
    iter++;
    
  }
}

public class Set5 extends Set {
  String str = "REDUX!1@*%$&+";
  int interval;
  int iter;
  int typeSpeed;
  
  int yaxis;
  int slope;

  char currChar;
  
  Vector<Float> sizes = new Vector();
  
  Set5() {
    
    reset();
  }
  
  public void reset() {
    iter = 1;
    currChar = str.charAt(floor(random(str.length())));
    interval = 5;
    typeSpeed = 2;
    yaxis = floor(random(height)) - 50;
    slope = ceil(random(5));
    sizes.clear();
  }
  
  public void run() {
    
    int curr = 0;
    for (int i = 0; i < floor(iter / typeSpeed); i++) {
      float max = 0;
      for (int j = 0; j < fft.spectrum.length; j++)
        max = max(fft.spectrum[j], max);
      float sz;
      if (i >= sizes.size()) {
        sz = max(interval, max * 1000);
        sizes.add(sz);
      } else {
        sz = sizes.get(i);
      }
      textSize(sz);
      fill(0);
      textFont(camera, sz);
      text(currChar, curr, yaxis);
      curr += (int)sz;
      if (curr > width)
        reset();
    }  
    iter++;
  }
}

public class Set6 extends Set {
  String[] strArr = {"12345",
                  "REDUX",
                  "ABCDE",
                  "MUSIC",
                  "NOTHING",
                  "LMNOP",
                  "TIME"};
  String str;
  int iter;
  int typeSpeed;
  int sz;
  
  
  Vector<Float> sizes = new Vector();
  
  Set6() {
    reset();
  }
  
  public void reset() {
    typeSpeed = floor(random(30) + 10);
    iter = 1;

    sz = height / 2;;
    str = strArr[floor(random(strArr.length))];
  }
  
  public void run() {
    int curr = floor(iter / typeSpeed);
    if (curr > str.length() && curr % 5 == 0)
      curr = 0;
    else if (curr > str.length())
      curr = str.length();
    for (int i = 0; i < curr; i++) {
      pushMatrix();
      textFont(camera, sz);
      textSize(sz);
      fill(0);
      float angle1 = radians(270);
      translate(-200, 900);
      rotate(angle1);
      text(str.charAt(i), sz * (i % 2), floor(i / 2) * sz + sz);
      popMatrix();
    }  
    iter++;
  }
}

public class Set7 extends Set {
 
  public void run() {
    if (movie.available()) {
      movie.read();
      movie.speed(5);
      
      image(movie, width/2 - movie.width/2, height/2 - movie.height/2);
    }
  }
}

// concentric circles radiating outwards
public class Set8 extends Set {
  int iter;
  int circlespeed;
  int seed1;
  int seed2;
  int maxSize;
  int diff;
  boolean two;
    
  Set8() {
    reset(); 
  }
  
  public void reset() {
    if (random(1) < 0.5) {
      maxSize = 800;
      two = false;
    } else {
      maxSize = 600;
      two = true;
    }
    iter = 1; 
    circlespeed = floor(random(30) + 10);
    seed1 = floor(random(100));
    seed2 = floor(random(100));
    diff = 50;
  }
  
  public void run() {
    noStroke();
    int bound = floor(iter / circlespeed);
    
    for (int i = bound; i >= 0; i--) {
      ellipseMode(CENTER);
      fill(currColor[(seed1 + i) % currColor.length]);
      int diameter = diff*i + (seed1 % (i + 1) * 10);
      if (two) {
        ellipse(width/2 + width/4, height/2, diameter, diameter);
        fill(currColor[(seed2 + i) % currColor.length]);
        ellipse(width/4, height/2, diameter, diameter);
      } else {
        ellipse(width/2, height/2, diameter, diameter);
      }
    }
    
    
    iter++;
    if (floor(iter / circlespeed) * diff > maxSize)
      reset();
  }
}

public class Set9_helper {
  int max = 130;
  int w;
  float angle;
  int x;
  int y;
  
  Set9_helper() {
    w = floor(random(100) + 30);

    float dice = random(1);
    if (dice < 0.25) { // from top
      y = -max;
      x = floor(random(width) - max);
      angle = random(180) - 90;
    } else if (dice < 0.5) { // from left side
      y = floor(random(height) - max);
      x = -max;
      angle = random(180) + 180;
    } else if (dice < 0.75) { // from bottom
      x = floor(random(width) - max);
      y = height + max;
      angle = random(180) + 90;
    } else if (dice < 1.0) { // from right side
      x = width + max;
      y = floor(random(height) - max);
      angle = random(180);
    }
    angle = Math.round(angle / 45.0) * 45;
  }
}

public class Set9 extends Set {
  Vector<Set9_helper> v = new Vector();
  int iter;
  int rate;
  int bound;
  int h;
  int seed;
  
  Set9() {
    reset();
  }
  
  public void reset() {
    iter = 0;
    rate = 10;
    bound = 500;
    v.clear();
    h = (int)Math.hypot(width, height) * 3;
    seed = floor(random(100));
  }
  
  
  public void run() {
    
    
    noStroke();
    
    int top = floor(iter / rate);
    
    for (int i = 0; i < top; i++) {
      fill(currColor[(i+seed) % currColor.length]);
      
      if (v.size() <= top)
        v.add(new Set9_helper());
        
      pushMatrix();
      translate(v.get(i).x, v.get(i).y);
      rotate(radians(v.get(i).angle));
      int n;
      if (i == top - 1)
        n = (iter % rate) * floor(h / rate);
      else 
        n = h;
      rect(0, 0, v.get(i).w, n);
      popMatrix();
    }

    
    
    iter++;
    if (iter > bound)
      reset();
  }
}

public class Set10 extends Set {
  PImage[] imgs = new PImage[5];
  int iter;  
 
  Set10() {
    iter = 0;
    for (int i = 0; i < 5; i++) {
      String url = "tree" + Integer.toString(i) + ".png";
      imgs[i] = loadImage(url);
    }
  }
  
  public void run() {
    pushMatrix();
    noStroke();
    rectMode(CORNER);
    int index = floor(iter / 50) % 5;
    fill(#000000, 120);
    rect(width/2 + width/4 + 20, height/3 + 20, imgs[index].width, imgs[index].height);
    image(imgs[index], width/2 + width/4, height/3);
    iter++;
    popMatrix();
  }
}

public class Set11 extends Set {
  int iter;
  int speed;
  int x;
  int y;
  int w;
  int h;
  int offset;
  
  Set11() {
    reset();
  }
  
  public void reset() {
    iter = 0;
    speed = 10;
    x = 4;
    y = 3;
    offset = 20;
  }
  
  public void run() {
    w = floor(width * 1.1 / x);
    h = floor(height * 1.25 / y);
    for (int i = 0; i < x; i++) {
      for (int j = 0; j < y; j++) {
        if (i*y + j >= floor(iter / speed))
          break;
        noStroke();
        fill(color(0, 126, 255, 102));
        rect((x-i-1) * w + (w/4) + offset, (y-j-1) * h + (h/4) + offset, w / 2, h / 3);
        fill(color(0, 126, 255, 255));
        rect((x-i-1) * w + (w/4), (y-j-1) * h + (h/4), w / 2, h / 3);
      }
    }
    iter++;
    if (floor(iter / speed) > x*y)
      reset();
  }
}

//for random images
public class Set12_helper {
  int iter;
  int bound;
  int index;
  int x;
  int y;
  String[] urls = {"lightning.jpg", "r.png", "animals.png", "ball.png", "sunrise.jpg", "sunset.jpg", "bollard.jpg", "wand.jpeg"};
  PImage[] imgs = new PImage[urls.length];
  boolean hidden;
  
  int size;
  
  Set12_helper() {
    reset();
    for (int i = 0; i < imgs.length; i++) {
      imgs[i] = loadImage(urls[i]);
      imgs[i].resize(size, size * (imgs[i].width / imgs[i].height));
    }
  }
  
  public void reset() {
    size = width / (floor(random(7)) + 5);
    iter = 0;
    bound = floor(random(width/3) + width/5);
    index = floor(random(imgs.length));
    x = floor(random(width));
    y = floor(random(height));
    hidden = false;
  }
  
  public void run() {
    if (!hidden && imgs[index] != null) {
      pushMatrix();
      noStroke();
      rectMode(CORNER);
      fill(#000000, 120);
      rect(x + 20, y + 20, imgs[index].width, imgs[index].height);
      image(imgs[index], x, y);
      popMatrix();
    }
    if (iter % floor(bound / 5) == 0 || iter % floor(bound / 6) == 0)
      hidden = !hidden;
    iter++;
    if (iter > bound)
      reset();
  }
}

public class Set12 extends Set {
  Vector<Set12_helper> imgs = new Vector<>();
  int count;
  
  Set12() {
    count = ceil(random(5));
    for (int i = 0; i < count; i++) {
      imgs.add(new Set12_helper());
    }
  }
  
  
  public void run() {
    for (int i = 0; i < count; i++)
      imgs.get(i).run();
  }
}

public class Set13 extends Set {
  int bands;
  int interval;
  int initSize = 30;
  float damping = 8;
  float[] smoothing;
  
  int iter;
  int speed;
  int bound;
  
  int offset;
  
  Set13() {
    reset();
  }
  
  public void reset() {
    interval = floor(random(40) + 10);
    bands = 256;
    smoothing = new float[bands];
    Arrays.fill(smoothing, initSize);   
    iter = 1;
    bound = 10000;
    offset = floor(random(width / 2));
  }
  
  
  public void run() {
    
    for (int i = 0; i < bands; i++) {
      float val = fft.spectrum[i] * 10000;
      smoothing[i] += (val - smoothing[i]) / damping;
      stroke(0);
      strokeWeight(1);
      ellipseMode(CENTER);
      fill(base);
      for (int j = 0; j < floor(smoothing[i] / interval); j++)
        ellipse(offset + i*interval, height - (j*interval) + initSize, initSize - 5, initSize - 5);
      iter++;
      if (iter > bound) {
        speed = speed * -1;
        iter = 1;
      }
    }  
  }
}

public class Set14 extends Set {
  String str = "reduxrad.io";
  int[] xs;
  int[] ys;
  boolean[] flip;
  int iter;
  int bound = 64;
  int speed = 3;
  
  Set14() {
    reset();
  }
  
  public void reset() {
    xs = new int[bound];
    ys = new int[bound];
    flip = new boolean[bound];
    Arrays.fill(flip, false);
    iter = 0;
  }
  
  public void run() {
    int index = floor(iter/speed);
    if (index >= bound) {
      reset();
      return;
    }
    fill(0, 120);
    textSize(30);
    textFont(camera, 30);
    for (int i = 0; i < index; i++) {
      pushMatrix();
      translate(xs[i], ys[i]);
      if (flip[i])
        scale(-1.0, 1.0);
      text(str, 0, 0);
      popMatrix();
    }
    xs[index] = floor(random(width));
    ys[index] = floor(random(height));
    if (random(1) < 0.1)
      flip[index] = true;
    iter++;

  }
}

public class Set15 extends Set {
  int iter;
  int barcount;
  int damping;
  int[] widths;
  int[] coords;
  int[] heights;
  boolean invert;
  
  Set15() {
    reset();
  }
  
  public void reset() {
    iter = 0;
    damping = 10;
    barcount = floor(random(20)) + 3;
    widths = new int[barcount];
    coords = new int[barcount];
    heights = new int[barcount];
    
    for (int i = 0; i < barcount; i++) {
      widths[i] = floor(random(width/15));
      coords[i] = floor(random(width));
    }
    if (random(1) < 0.5) {
      Arrays.fill(heights, height);
      invert = true;
    } else {
      Arrays.fill(heights, 0);
      invert = false;
    }
  }
  
  public void run() {
    int lower = 0;
    int upper = 2;
    float max = 0;
    
    pushMatrix();
    noStroke();
    translate(0,0);
    for (int i = 0; i < barcount; i++) {
      for (int j = lower; j < upper; j++)
        max = max(fft.spectrum[i], max);
      lower = upper;
      upper *= 2;
      if (invert)
        heights[i] -= abs(floor((max * 10000 - heights[i]) / damping));
      else
        heights[i] += abs(floor((max * 10000 - heights[i]) / damping));
      max = 0;
      fill(0);
      rect(coords[i], 0, widths[i], heights[i]);
    }
    popMatrix();
    iter++;
    if (floor(random(100)) == 0)
      reset();
  }
}

// random diagonal stripes
// why flickering?
public class Set16 extends Set {
  int iter;
  int max;
  int seed;
  int speed;
  boolean invert;
  int w;
  
  Set16() {
    reset();
  }
  
  public void reset() {
    iter = 1;
    speed = 30;
    if (random(1) < 0.5) {
      invert = !invert;
    } else {
      max = floor(random(5)) + 3;
      seed = floor(random(100));
      invert = false;
    }
  }
  
  private void render(int curr, int i) {
    rectMode(CORNER);
    fill(currColor[(i + seed) % currColor.length]);
    strokeWeight(15);
    stroke(base);
    rect(w * i, -1 * i * w, w, height*3);
  }
  
  public void run() {
    pushMatrix();
    w = floor((float)Math.hypot(width, height) / max);
    translate(0, -w);
    rotate(radians(45));
    int curr = floor(iter / speed);
    rectMode(CORNER);
    if (!invert)
      for (int i = 0; i < curr; i++)
        render(curr, i);
    else 
     for (int i = max - curr - 1; i >= 0; i--)
        render(curr, i);    
    strokeWeight(15);
    stroke(base);
    if (!invert) {
      fill(currColor[(curr + seed) % currColor.length]);
      rect(w * curr, -1 * curr * w, w, (iter % speed) * floor(height*3 / speed));
    } else {
      fill(currColor[Math.floorMod(max - curr + seed, currColor.length)]);
      rect(w * (max - curr), -1 * (curr + 2) * w, w, (height*3 - (iter % speed) * floor(height*3 / speed)));
    }
    popMatrix();
    iter++;
    if (curr > (max+1))
      reset();
  }
}

public class Set17 extends Set {
  boolean filter[];
  float angle;
  int damping = 6;
  int w;
  int h;
  float span;
  int petals;
  int seed;
  
  Set17() {
    reset();
  }
  
  public void reset() {
    angle = 0;
    w = floor(random(6)) + 3;
    petals = floor(random(5) + 3);
    seed = floor(random(100));
    span = width / w;
    h = ceil(height / span);
    filter = new boolean[h * w + h/2];
    if (random(1) < 0.5)
      for (int i = 0; i < h * w + h/2; i++)
        if (random(1) < 0.4)
          filter[i] = false;
        else
          filter[i] = true;
    else
      Arrays.fill(filter, false);
  }
  
  public void run() {
    
    
    float max = 0;
    for (int i = 0; i < fft.spectrum.length; i++)
      max = max(fft.spectrum[i] * 1000, max);
    angle += (max / 50) + 0.1;
    
    float span = width / w;
    int h = ceil(height / span);
    
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < (w + ((i + 1) % 2)); j++) {
        if (i*w + j < filter.length)
          if (filter[i*w + j]) continue;
        pushMatrix();
        noStroke();

        translate(0,0);
        translate(j * span + ((span/2) * (i % 2)), i * span + (span/2));
        rotate(radians(angle));
        
        ellipseMode(CORNER);
        fill(currColor[seed % currColor.length]);
        for (int p = 0; p < petals; p++) {
          rotate(radians(360 / petals));
          ellipse(span / 10, -span / (petals * 2), span / 3, span / petals);
        }
        ellipseMode(CENTER);
        fill(currColor[(seed + 1) % currColor.length]);
        ellipse(0, 0, span / 5, span / 5);
        popMatrix();
      }
    }
  }
}

public class Set18_helper {
  int seed;
  int x;
  int y;
  int h_max;
  int h;
  int damping = 30;
  boolean shrinking;
  int shrink;
  
  Set18_helper() {
    x = floor(random(width));
    y = floor(random(height));
    h_max = floor(random(10) + 10);
    h = 0;
    shrinking = false;
    shrink = 255;
    seed = floor(random(100));
  }
  
  public int interpCenter() {
    shrinking = true;
    int newX = floor((max(width, x) - min(width, x) - x) / damping);
    int newY = (max(height, y) - min(height, y) - y) / damping;
    x += newX;
    y += newY;
    if (newX + newY == 0)
      return 1;
    return 0;
  }
  
  public void run() {
    pushMatrix();
    noStroke();
    translate(x,y);
    
    fill(0, 0, 0, 120);
    ellipseMode(CENTER);
    ellipse(0, h, h*1.5, h/2);
    
    if (shrinking)
      h = max(0, h - 1);
    else
      h = min(h_max, h+1);
    fill(currColor[seed % currColor.length]);
    
    ellipse(0, -h, h, h);
    ellipse(0, 0, h, h);
    rectMode(CENTER);
    rect(0, h*0.5, h, h);
    
    popMatrix();
  }
}

public class Set18 extends Set {
  Vector<Set18_helper> vec = new Vector();
  int count;
  int iter;
  int speed;
  
  Set18() {
    reset();
  }
  
  public void reset() {
    vec.clear();
    count = floor(random(100)) + 25;
    iter = 0;
    speed = 2;
  }
  
  public void run() {
    boolean addNew = true;
    int bound = floor(iter / speed);
    if (bound > count) {
      addNew = false;
      bound = count;
    }
    if (bound > vec.size() && addNew)
      vec.add(new Set18_helper());

    int accumulator = 0;
    for (int i = 0; i < bound; i++) {
      if (!addNew && floor(iter / speed) > count + 30)
        accumulator += vec.get(i).interpCenter();
      vec.get(i).run();
    }
    
    iter++;
    if (accumulator == count)
      reset();
  }
  
}

public class Set19 extends Set {
  int iter;
  int speed;
  int count;
  int span;
  int h;
  int seed;
  
  Set19() {
    reset();
  }
  
  public void reset() {
    count = ceil(random(10));
    span = height / count;
    speed = floor(random(150) + 50);
    iter = 0;
    seed = floor(random(100));
  }
  
  public void run() {
    int curr = floor(iter / speed);
    
    int w = -span;
    int x = width + h;
    if (curr % 2 == 1) {
      w = width + span;
      x = -h;
    }
    
    h = span / 8;
    
    if (curr % 2 == 1)
      x = (iter % speed) * (w/speed);
    else
      x = x - ((iter % speed) * ((width + span)/speed));
    pushMatrix();
    noStroke();
    float factor = sin((float)iter/10)/2 + 1;
    translate(x, curr * span + span/2);
    scale(1.0, factor);
    
    fill(0, 0, 0, 120);
    ellipseMode(CENTER);
    ellipse(h/2, 0, h*1.5, h/2);
    
    fill(currColor[(seed + curr) % currColor.length]);
    ellipseMode(CORNER);
    ellipse(0, -h*2.5, h, h);
    ellipse(0,-h*1.5,h,h);
    rectMode(CORNER);
    rect(0,-h,h,h);
    popMatrix();

    iter++;
    if (curr > count)
      reset();
  }
}
  
public class Set21 extends Set {
  int iter;
  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  
  int cursorx;
  int cursory;
  
  boolean closed;
  
  Set21() {
    reset();
  }
  
  public void reset() {
    closed = false;
    iter = 0;
    perspective(fov, float(width)/float(height), 
            cameraZ/10.0, cameraZ*10.0);
    cursorx = width + width/2;
    cursory = height + height/2;
  }
  
  public void run() {
    iter++;
    pushMatrix();
    translate(0,0,20);
    rectMode(CORNER);
    fill(0);
    noStroke();
    if (closed) {
      fill(0);
      rect(-width/2 - iter * 10, -height/2,width*2,height*2);
      popMatrix();
      return;
    }
    rect(-10*width, -10*height, 30*width, 10*height);
    rect(-10*width, -10*height, 10*width, 30*height);
    rect(-10*width, height, 30*width, 10*height);
    rect(width, -10*height, 10*width, 30*height);
    fill(200);
    rect(0, -50, width, 45);
    fill(#e04848);
    rect(5, -45, 40, 35);
    fill(#ffc936);
    rect(50, -45, 40, 35);
    fill(#56d65a);
    rect(95, -45, 40, 35);
    
    if (iter > 200) {
      if (cursorx > 20)
        cursorx -= (width + width/2 - 20) / 100;
      else
        cursorx = 20;
      if (cursory > -20)
         cursory -= (height + height/2 + 20) / 100;
      else {
        cursory = -20;
        if (iter > 350) {
          fill(#ffb0b0);
          rect(5, -45, 40, 35);
          if (iter > 360) {
            closed = true;
            perspective(fov, float(width)/float(height), 
                cameraZ/10.0, cameraZ*10.0);
            popMatrix();
            iter = 0;
            return;
          }
        }
      }
    }
    translate(cursorx, cursory);
    fill(255);
    strokeWeight(1);
    stroke(0);
    triangle(0, 0, 0, 50, 30, 40);
    
    popMatrix();
    
    if (iter > 50)
      perspective(fov + min((iter-50)*0.01, 1), float(width)/float(height), 
            cameraZ/10.0, cameraZ*10.0);
  }

}

public class Set22_helper {
  int x;
  int y;
  
  Set22_helper(int x_in, int y_in) {
    x = x_in;
    y = y_in;
  }
  
  public void set(int x_in, int y_in) {
    x = x_in;
    y = y_in;
  }
}


// Bouncing dvd logo
public class Set22 extends Set {
  color col;
  int iter;
  int count = 50;
  Set22_helper arr[] = new Set22_helper[count];
  int dx;
  int dy;
  int h;
  int seed;
  int interval;
  int balls;
  
  Set22() {
    reset();
  }
  
  public void reset() {
    if (random(1) < 0.5)
      dx = 4;
    else 
      dx = -4;
    if (random(1) < 0.5)
      dy = 4;
    else 
      dy = -4;
    seed = floor(random(100));
    h = floor(random(width / 20) + width/30);
    col = currColor[seed % currColor.length];
    iter = 0;
    int x = floor(random(width - 2*h)) + h;
    int y = floor(random(height - 2*h)) + h;
    for (int i = 0; i < count; i++)
      arr[i] = new Set22_helper(x, y);
    balls = ceil(random(5));
  }
  
  public void run() {
    pushMatrix();
    
    noStroke();      
    ellipseMode(CENTER);
    if (arr[iter].x - h/2 < 0 || arr[iter].x + h/2 > width)
      dx *= -1;
    if (arr[iter].y - h/2 < 0 || arr[iter].y + h/2 > height)
      dy *= -1;
      
    arr[(iter + 1) % count].set(arr[iter].x + dx, arr[iter].y + dy);
    iter = (iter + 1) % count;
    
    strokeWeight(10);
    for (int i = 0; i < balls; i++) {
      int offset = ((iter - ((count / balls) * i)) + count) % count;
      
      fill(col, 255/(i+1));
      ellipse(arr[offset].x, arr[offset].y, h, h);
    } 
       
    popMatrix();
    
  }
}
