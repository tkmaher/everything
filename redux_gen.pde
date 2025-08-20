

public class Set20 extends Set {
  
    public class Set20_helper {
      int x;
      int y;
      int h;
      int seed;
      float iter;
      
      Set20_helper() {
        x = floor(random(width / 2) + (width/4));
        y = floor(height * 7/8);
        h = floor(random(10) + 10);
        seed = floor(random(100));
        iter = random(100);
      }
      
      public void run() {
        pushMatrix();
        noStroke();
        translate(x,y);
        
        scale(1.0, (sin(iter) / 2) + 1);
        
        fill(currColor[seed % currColor.length]);
        
        ellipseMode(CORNER);
        ellipse(0, -h*2.5, h, h);
        ellipse(0, -h*1.5, h, h);
        rectMode(CORNER);
        rect(0, -h, h, h);
        
        iter += 0.2;
        
        popMatrix();
      }
    }
    
    float CENTER_X; 
    float CENTER_Y; 
    float C_RADIUS; 
    float TEXT_SIZE;
    int C_STROKE = 13; // stroke of circle, px
    float C_SIZE = 0.175; // fractional circle size
    
    boolean FILL;

    color BKGD;
    color FONT_COL;

    double EL_H = 0.085; // text element height in dec percent

    // L E T T E R S  S E T T I N G S
    String REDUX = "redux";
    int REDUX_LEN = REDUX.length(); // # of letters
    Vector<Letter> redux = new Vector();
    double[] letter_pos = new double[REDUX_LEN];
    double[] letter_angles = new double[REDUX_LEN];

    double VELOCITY = 0.00525; // init velocity base speed
    double INIT_DX = 0.0075; // init letter displacement
    int PROX_RANGE = 35; // px range considered proximal
    double rx_dist; // distance between the letter r and x
    
    // extra
    Vector<Set20_helper> people = new Vector();

    Set20() {
      reset();
    }

    public void run() {
      
      peopleUpdate();
      cutoutUpdate();
      
      for (int i = 0; i < REDUX_LEN; i++) {
          redux.get(i).update();
          redux.get(i).lettersUpdate();
      }
      proximity_logic(); // combining letters
    }
    
    private void peopleUpdate() {
      pushMatrix();
      noStroke();
      smooth();
      ellipseMode(CENTER);
      fill(#000000, 120);
      ellipse(width/2, 7*height/8, width/2, 10);
      popMatrix();
      for (int i = 0; i < people.size(); i++)
        people.get(i).run();
    }

    // checks if two letters are within close range to each other
    public void proximity_logic() {
      pos_update(); // updating angular positions
      bookend(); // make sure x doesn't overtake r

      for (int i = REDUX_LEN - 1; i >= 0; i--) {
        // APPEND LETTERS
        if (is_adjacent(i)) {
          String new_contents = "";

          force_field(i);

          while (is_adjacent(i)) {
            new_contents = redux.get(i).getLetterReport() + new_contents;
            redux.get(i).isByNeighbor(true);
            redux.get(i).empty();
            i--;
          }

          redux.get(i).contentsUpdate(redux.get(i).getLetterReport() + new_contents);
        } else {
          remove_letters(i);
          redux.get(i).isByNeighbor(false);
        }
      }
    }

    // updates global array of angular positions
    public void pos_update() {
        for (int i = 0; i < REDUX_LEN; i++) {
            letter_pos[i] = redux.get(i).getLocation();
        }
    }

    public void remove_letters(int idx) {
        redux.get(idx).contentsUpdate(redux.get(idx).getLetterReport());
    }

    public boolean is_adjacent(int idx) {
        if (idx > 0) {
            return letter_pos[idx] < letter_pos[idx - 1] + PROX_RANGE;
        } else {
            return false;
        }
    }

    public void force_field(int idx) {
        redux.get(idx - 1).slow(); // the one overtaking needs to slow
        if (letter_pos[idx - 1] > letter_pos[idx]) {
            redux.get(idx).speed();
            redux.get(idx - 1).stop();
        }
    }

    // preventing x from overtaking r
    public void bookend() {
        rx_dist = 360 - (letter_pos[4] - letter_pos[0]); // angular distance between x and r

        // checks if x is within PROX_RANGE degrees (360 because it is a revolution ahead)
        if (rx_dist < 100) {
            redux.get(4).slow(); // slow x
            redux.get(0).speed(); // speed up r
        }
        // checks if x has completely overtaken r
        if (rx_dist < redux.get(0).getLetterBufferSize()) {
          redux.get(4).stop(); // stop x till it's no longer overtaken
      }
  }

  public void reset() {
    for (int i = 0; i < 100; i++)
      people.add(new Set20_helper());
    BKGD = base; //<>// //<>// //<>//

    if (random(1) < 0.3) {
      FONT_COL = #000000;
      FILL = true;
    } else {
      FONT_COL = currColor[floor(random(100)) % currColor.length];
      FILL = false;
    }
    
    redux.clear();
    ellipseMode(RADIUS);
    redux.add(new Letter(0, 0));
    redux.add(new Letter(1, 360 / 5));
    redux.add(new Letter(2, (360 / 5) * 2));
    redux.add(new Letter(3, (360 / 5) * 3));
    redux.add(new Letter(4, (360 / 5) * 4));

    for (int i = 0; i < REDUX_LEN; i++)
        letter_pos[i] = redux.get(i).angle;

    int DISP_W = width; 
    int DISP_H = height;
    double DISP_D = Math.sqrt(Math.pow(DISP_W, 2) + Math.pow(DISP_H, 2));

    CENTER_X = DISP_W / 2; // half display width
    CENTER_Y = DISP_H / 7 * 3; // half display height
    C_RADIUS = DISP_W * C_SIZE;
    TEXT_SIZE = (int)(DISP_D * EL_H);
    
    
  }
  
  
  float diff = (float)PI/10;
  
  private void cutoutUpdate() {
    for (int i = 0; i < REDUX_LEN; i++)
      letter_angles[i] = redux.get(i).angle;
    Arrays.sort(letter_angles);
    
    int upper;
    int curr;
    float skips;
      
    for (int i = 0; i < REDUX_LEN + 1; i++) {
      skips = 1;
      curr = i % REDUX_LEN;
      upper = (i + 1) % REDUX_LEN;
      while (redux.get(upper).contents.isEmpty()) {
        skips += 0.5;
        upper = (upper + 1) % REDUX_LEN;
      }
      
      pushMatrix();
      translate(0,0);
      scale(1.0);
      
      noFill();
      ellipseMode(RADIUS);
      float a1 = (float)(letter_angles[curr]);
      float a2 = (float)(letter_angles[upper]);
      if (a2 < a1)
        a2 += 2*PI;
            
      if (!redux.get(curr).contents.isEmpty()) {
        if (FILL) {
          noStroke();
          fill(currColor[i % currColor.length]);
          arc((int) CENTER_X, (int) CENTER_Y, 
         (C_RADIUS), 
         (C_RADIUS), 
         a1, 
         a2);
        }
        a1 += diff * skips;
        a2 -= diff;
        stroke(FONT_COL);
        strokeWeight(C_STROKE);
        arc((int) CENTER_X, (int) CENTER_Y, 
         (C_RADIUS), 
         (C_RADIUS), 
         a1, 
         a2);
      }
      popMatrix();
    }
  }
  
  class Letter {
    double noiseSeed;
    double angle;
    int chIndex;
    String letter;
    String contents;
    boolean adjacent;
    double angleDx;
    double xpos;
    double ypos;
    double letterBuffer;
    double chHeight;

    public Letter(int idx, double theta) {
        noiseSeed = random(100);
        angle = Math.toRadians(theta);
        chIndex = idx;

        textSizeUpdate();

        letter = String.valueOf(REDUX.charAt(chIndex));
        contents = letter;
        adjacent = false;
        angleDx = INIT_DX;

        xpos = 0;
        ypos = 0;
        letterBuffer = 0;
    }

    public void update() {
        xpos = Math.cos(angle) * C_RADIUS + CENTER_X;
        ypos = Math.sin(angle) * C_RADIUS + CENTER_Y;

        velocityUpdate();
    }

    void velocityUpdate() {
        noiseSeed += 0.01;
        angle += angleDx;
        angleDx = VELOCITY + VELOCITY * (noise(noiseSeed) - 0.5);
    }

    void textSizeUpdate() {
        chHeight = TEXT_SIZE * 0.75;
        if (contents != null && contents.contains("d"))
            chHeight = textAscent();
    }

    public void lettersUpdate() {
        textSizeUpdate();

        fill(FONT_COL);
        textFont(camera);
        textSize((float)TEXT_SIZE);
        float f = (TEXT_SIZE * 0.2);
        text(contents, (int) xpos - contents.length() * f, (int) ypos + f);
    }

    public double getLocation() {
        return Math.toDegrees(angle);
    }

    public double getLetterBufferSize() {
        return letterBuffer;
    }

    public String getLetterReport() {
        return letter;
    }

    public String getContentsReport() {
        return contents;
    }

    public void contentsUpdate(String inputContents) {
        contents = inputContents;
    }

    public void empty() {
        contents = "";
    }

    public void isByNeighbor(boolean nowByNeighbor) {
        adjacent = nowByNeighbor;
    }

    public void slow() {
        angleDx -= (VELOCITY / 12.0);
    }

    public void speed() {
        angleDx += (VELOCITY / 12.0);
    }

    public void stop() {
        angleDx -= (VELOCITY);
    }

    double noise(double seed) {
        // Implement noise function or use a library
        return Math.sin(seed); // Placeholder implementation
    }

    double textAscent() {
        // Implement text ascent calculation
        return TEXT_SIZE; // Placeholder implementation
    }

    double textWidth(String text) {
        return text.length() * TEXT_SIZE * 0.5; // Placeholder implementation
    }
  }
}
