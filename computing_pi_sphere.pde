///////////////////////////////////////////////////////
// Created by Tom Gautot on 04/02/2019 (dd/mm/yyy)
//
// Approximates value of PI by generating random points in a cube
// and checking whether or not the fit in the sphere inside the cube
////////////////////////////////////////////////////////


// Dimensions for the cube, not the window
int HEIGHT = 600;
int WIDTH = 600;
int DEPTH = 600;

int centerX = HEIGHT/2;
int centerY = WIDTH/2;
int centerZ = DEPTH/2;
int radius = WIDTH/2;

// Not 0 to avoid division by zero, does not impact result over big time (big dataset)
int pointIn = 1;
int pointOut = 1; 

int itts = 0;

ArrayList<Integer> valX, valY, valZ;
ArrayList<Boolean> pointInCircle;

void setup() {
  size(600, 700, P3D);
  stroke(255);
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

void draw() { 
  background(0);
  
  float pi = 6*(((float)pointIn)/((float)pointOut+pointIn));
  
  writePiValue(pi);
  
  beginCamera();
  rotateY(PI/240);
  endCamera();
  
  stroke(255, 255, 255);
  noFill();
  box(WIDTH, HEIGHT, DEPTH);
  
  for(int i = 0; i < 350; i++){
    
    // Generate random coordinates -> random point
    int newPointX = (int) random(0, HEIGHT);
    int newPointY = (int) random(0, WIDTH);
    int newPointZ = (int) random(0, DEPTH);
    
    float pointDist = distFromCenter(newPointX, newPointY, newPointZ);
    
    // Check if the point is in the sphere
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
  
  // Draw the stored points
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
  
  if(itts > 50){ // Avoid drawing too many points: delete all points saved and generate new ones (but keep the data)
    itts = 0;
    valX.clear();
    valY.clear();
    valZ.clear();
    pointInCircle.clear();
  }
  else{
    itts++;
  }
  
  
} 
