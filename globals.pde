import processing.sound.*;
import java.util.Arrays;
import java.util.Vector;
import processing.video.*;
import javax.sound.sampled.*;
import java.util.Queue;
import java.awt.Color;
import java.util.ArrayList;


int audioindex = 0;
AudioIn input;
FFT fft;

State state;

int iter = 0;

color[] bases = {
                color(235, 232, 225), 
                color(38, 37, 37), 
                color(211, 222, 206),
                color(245, 206, 215),
                color(37, 37, 38),
                color(245, 245, 245),
              };

color base;

color[] pop = 
  { 
    #f24a5a,
    #cfb188,
    #a6a9a9,
    #f9fc10,
    #2bb3eb,
  };
  
color[] cream = 
  { 
    #FAFFD8,
    #556F7A,
    #798086,
    #ECFFB0,
    #7D1D3F,
  };
  
color[] cottage = 
  { 
    #0A0908,
    #DA4167,
    #F2F4F3,
    #A9927D,
    #5E503F,
  };
  
color[] manchuria = 
  { 
    #DC851F,
    #F24236,
    #2E86AB,
    #565554,
    #FFFAE2,
  };
  
color[] grays = 
  { 
    #bec1c4,
    #636363,
    #f5f5f5,
    #c5c7c9,
    #f2f4f5,
  };
  
color[] brick = 
  { 
    #ba6625,
    #242424,
    #f5f5f5,
    #eb7f7f,
    #cecfd6,
  };
  
color[] white = 
  { 
    #1a1a1a,
    #ffffff
  };
  
color[] colormind = 
  { 
    #DE6449,
    #791E94,
    #FFFFF2,
    #41D3BD,
    #407899,
  };
  
color[] pastel = 
  { 
    #087CA7,
    #ECDCB0,
    #C1D7AE,
    #6C464E,
    #968E85,
  };
  
color[][] colors = {pop, cream, cottage, manchuria, grays, brick, white, colormind, pastel};

color[] currColor;

PFont camera;

Movie movie;

PImage logo;
