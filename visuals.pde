

void setupaudio() {
  //print(Sound.list());
  fft = new FFT(this, 512);
    
  if (input != null)
    input.stop();
  input = new AudioIn(this, audioindex); 
  input.start();
  fft.input(input);
}

void setup() {
  frameRate(60);
  fullScreen(P3D);
  hint(DISABLE_OPTIMIZED_STROKE);
  setupaudio();
  
  camera = createFont("ABCCameraPlainUnlicensedTrial-Medium", width/2); 
  
  movie = new Movie(this, "fireworks.mov");
  movie.loop();
  
  logo = loadImage("logo.png");
  logo.resize(width/20, width/20 * (logo.height/logo.width));
  
  state = new State();
}

public class State {
  int thresh;
  int iter = 0;
  int count;
  Vector<Set> sets = new Vector();
  int[] curr;
  float angle = 0.0;
  
  float prevdb = 0;
  int smoothing = 20;
  
  State() {
    base = bases[floor(random(bases.length))];
    currColor = colors[floor(random(colors.length))];
    
    sets.add(new Set0());
    sets.add(new Set1());
    sets.add(new Set2());
    sets.add(new Set3());
    sets.add(new Set4());
    sets.add(new Set5());
    sets.add(new Set6());
    sets.add(new Set7());
    sets.add(new Set8());
    sets.add(new Set9());
    sets.add(new Set10());
    sets.add(new Set11());
    sets.add(new Set12());
    sets.add(new Set13());
    sets.add(new Set14());
    sets.add(new Set15());
    sets.add(new Set16());
    sets.add(new Set17());
    sets.add(new Set18());
    sets.add(new Set19());
    sets.add(new Set20());
    sets.add(new Set21());
    sets.add(new Set22());
    reset();

  }
  
  private void reset() {
    count = ceil(random(5));
    curr = new int[count];
    
    if (random(1) < 0.3)
      currColor = colors[floor(random(colors.length))];
    if (random(1) < 0.3)
      base = bases[floor(random(bases.length))];
    
    
    thresh = floor(random(1000) + 500);
    iter = 0;
    
    boolean[] chosen = new boolean[sets.size()];
    Arrays.fill(chosen, false);
    Arrays.fill(curr, -1);
    for (int i = 0; i < count; i++) {
      int n = floor(random(sets.size()));
      while (chosen[n] == true)
        n = (n+1) % sets.size();

      chosen[n] = true;
      curr[i] = n;
      sets.get(n).reset();

      if (n == 2 || n == 16) {
        chosen[1] = true;
        if (n == 2)
          chosen[16] = true;
        else
          chosen[2] = true;
      } else if (n == 1) {
        chosen[2] = true;
        chosen[16] = true;
      }
      
      if (n == 20)
        chosen[0] = true;
      else if (n == 0)
        chosen[20] = true;
      
    }
    print("\n");
  }
  
  public void run() {
    for (int i = 0; i < count; i++)
      if (curr[i] != -1) 
        sets.get(curr[i]).run(); 
                        //<>//
    if (iter > thresh)
      if (random(100) < 1)
        reset();
    
    iter++;
  }
  
  public void drawlogo() {
    pushMatrix();
    translate(logo.width + 30, height - logo.height - 40 + 20*sin(2*angle), logo.width/2); 
    rotateY(angle);
    translate(-logo.width / 2, -logo.height / 2); 
    image(logo, 0, 0);
    angle += 0.04;
    popMatrix();
  } 
  
  public void displayLevel() {
    
    fft.analyze();
    float max = 0;
    for (int i = 0; i < fft.spectrum.length; i++)
      max = max(max, fft.spectrum[i]);
    
    prevdb += (max * 100 - prevdb) / smoothing;
    
    pushMatrix();
    translate(0, 10, 0);
    textSize(10);
    textFont(camera, 10);
    fill(0);
    stroke(255);
    text("Level: " + String.format("%.2f", prevdb), 0, 0); 
    text("Input: " + audioindex, 0, 10); 
    popMatrix();
  }
  
}

void draw() {
  background(base);
  
  state.run();
  state.drawlogo();
  state.displayLevel();
  
  /*if (iter % 10000 == 0) {
    setupaudio();
    print(iter + ": setupaudio called");
  }
  iter++;*/
}
