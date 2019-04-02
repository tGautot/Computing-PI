int HEIGHT = 600;
int WIDTH = 600;
int DEPTH = 600;

int centerX = HEIGHT/2;
int centerY = WIDTH/2;
int centerZ = DEPTH/2;
int radius = WIDTH/2;
int pointIn = 1;
int pointOut = 1;

int itts = 0;

ArrayList<Integer> valX, valY, valZ;
ArrayList<Boolean> pointInCircle;

// The statements in the setup() function 
// execute once when the program begins
void setup() {
  size(600, 700, P3D);  // Size must be the first statement
  stroke(255);     // Set line drawing color to white
  frameRate(30);
  valX = new ArrayList<Integer>();
  valY = new ArrayList<Integer>();
  valZ = new ArrayList<Integer>();
  pointInCircle = new ArrayList<Boolean>();

  beginCamera();
  translate(width/2, height/2, -WIDTH - WIDTH/4);
  rotateX(-PI/6);
  endCamera();
  

}

float distFromCenter(int x, int y, int z){
  int distX = x-centerX;
  int distY = y-centerY;
  int distZ = z-centerZ;
  
  return sqrt(distX*distX + distY*distY + distZ*distZ);
}

void writePiValue(float pi){
  
  textSize(54);
  textAlign(CENTER, CENTER);
  text("π = " + nf(pi, 1, 10), 0, 0, WIDTH/2);
  
}

// The statements in draw() are executed until the 
// program is stopped. Each statement is executed in 
// sequence and after the last line is read, the first 
// line is executed again.
void draw() { 
  background(0);   // Clear the screen with a black background
  
  //rotateZ((itts*PI/8)/20);
  
  
  float pi = 6*(((float)pointIn)/((float)pointOut+pointIn));
  
  writePiValue(pi);
  
  beginCamera();
  rotateY(PI/240);
  endCamera();
  
  stroke(255, 255, 255);
  noFill();
  box(WIDTH, HEIGHT, DEPTH);
  
  for(int i = 0; i < 350; i++){
    int newPointX = (int) random(0, HEIGHT);
    int newPointY = (int) random(0, WIDTH);
    int newPointZ = (int) random(0, DEPTH);
    
    float pointDist = distFromCenter(newPointX, newPointY, newPointZ);
    
    if(pointDist < radius){
      pointInCircle.add(true);
      pointIn++;
    } else {
      pointInCircle.add(false);  
      pointOut++;  
    }
    
    valX.add(newPointX);
    valY.add(newPointY);
    valZ.add(newPointZ);
  }
  
  int size = valX.size();
  
  for(int i = 0; i < size; i++){
    boolean in = pointInCircle.get(i);
    int x = valX.get(i);
    int y = valY.get(i);
    int z = valZ.get(i);
    
    if(in){
      stroke(255, 255, 0);
      point(x - WIDTH/2, y - HEIGHT/2, z - DEPTH/2);
      
    }
    else{
      stroke(255, 255, 255);
      point(x - WIDTH/2, y - HEIGHT/2, z - DEPTH/2);
    }
    
  }
  
  if(itts > 50){
    itts = 0;
    valX.clear();
    valY.clear();
    valZ.clear();
    pointInCircle.clear();
  }
  else{
    itts++;
  }
  
  //print("Current PI approximation : " + pi + " (" + (pointIn+pointOut) + " points)\n");
  
} 
