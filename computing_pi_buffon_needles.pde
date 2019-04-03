int totNeedles = 0;
int touchingNeedles = 0;

int needlesPerFrame = 20;

int needleLength = 100; // pixels
int distLines = 2 * needleLength;

int itts = 0;

void setup(){
  fullScreen();
  frameRate(30);
}

void draw(){
  background(0);
  
  float noLines = (height/((float)distLines));
  int shownLines = ceil(noLines);
  int shift = (int)((noLines-floor(noLines))*distLines)/2; // divide by 2 Because we only want to shift top
  
  print("Must show " + noLines + " lines\n");
  
  int firstHeight = shift; // First line, can deduce all the other from this one
  
  itts++;
  
  stroke(255);
  fill(255);
  for(int i = 0; i < shownLines; i++){
    rect(0, shift + i*distLines, width, 2);    
  }
  
  // Needles are flat when angle = 0
  for(int i = 0; i < needlesPerFrame; i++){
    int x = (int)random(0, width);
    int y = (int)random(0, shownLines*distLines + ((itts%2 == 1)?distLines/2:0)); // This is required to achive "artificial infinite space" (sounds cooler than it is)
    float angle = random(0, PI);
    
    int needleHeight = (int)((needleLength/2.0)*abs(sin(angle)));
    int needleWidth  = (int)((needleLength/2.0)*abs(cos(angle)));
    int needleTop = y + needleHeight;
    int needleBot = y - needleHeight;
    
    if((needleTop+distLines-shift)%distLines < (needleBot+distLines-shift)%distLines ){ // Good exercice for the reader to try and understand ;)
      touchingNeedles++;
      totNeedles++;
      stroke(175, 238, 238);
    }
    else{
      totNeedles++;
      stroke(255, 255, 0);
    }
    
    line(x-needleWidth, y-needleHeight, x+needleWidth, y+needleHeight);
    
  }
  
  float pi = ((float)totNeedles)/((float)touchingNeedles);
  
  textAlign(CENTER, CENTER);
  textSize(30);
  text("π = " + nf(pi, 1, 10) + "\n" + "#Needles : " + totNeedles, width/2, height-50);  
  
}
