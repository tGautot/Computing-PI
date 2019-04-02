///////////////////////////////////////////////////////
// Created by Tom Gautot on 04/02/2019 (dd/mm/yyy)
//
// Approximates value of PI by generating random points in a square
// and checking whether or not the fit in the circle inside the square
////////////////////////////////////////////////////////

// Dimensions for the square, not the window
int HEIGHT = 1000;
int WIDTH = 1000;

int centerX = HEIGHT/2;
int centerY = WIDTH/2;
int radius = WIDTH/2;
int pointIn = 0;
int pointOut = 0;

int itts = 0;

ArrayList<Integer> valX, valY;
ArrayList<Boolean> pointInCircle;

void setup() {
  size(1000, 1100);
  stroke(255);
  frameRate(30);
  valX = new ArrayList<Integer>();
  valY = new ArrayList<Integer>();
  pointInCircle = new ArrayList<Boolean>();
}

float distFromCenter(int x, int y){
  int distX = x-centerX;
  int distY = y-centerY;
  
  return sqrt(distX*distX + distY*distY);
}

void draw() { 
  background(0);
  stroke(255, 255, 255);
  noFill();
  arc(centerX, centerY, 2*radius, 2*radius, 0, 2*PI);
  rect(0, 0, HEIGHT, WIDTH);
  
  for(int i = 0; i < 200; i++){
    // Generate random coordinates -> random point
    int newPointX = (int) random(0, HEIGHT);
    int newPointY = (int) random(0, WIDTH);
    
    float pointDist = distFromCenter(newPointX, newPointY);
    
    // Check if the point is in the circle
    if(pointDist < radius){
      pointInCircle.add(true);
      pointIn++;
    } else {
      pointInCircle.add(false);  
      pointOut++;  
    }
    
    valX.add(newPointX);
    valY.add(newPointY);
  }
  
  int size = valX.size();
  
  // Draw the stored points
  for(int i = 0; i < size; i++){
    boolean in = pointInCircle.get(i);
    int x = valX.get(i);
    int y = valY.get(i);
    
    if(in){
      stroke(255, 255, 0);
      point(x, y);
      
    }
    else{
      stroke(255, 255, 255);
      point(x, y);
    }
    
  }
  
  if(itts > 100){ // Avoid drawing too many points, delete them (but keep the data)
    itts = 0;
    valX.clear();
    valY.clear();
    pointInCircle.clear();
  }
  else{
    itts++;
  }
  
  float pi = 4*(((float)pointIn)/((float)pointOut+pointIn));
  
  textSize(54);
  textAlign(CENTER, CENTER);
  text("π = " + nf(pi, 1, 10), WIDTH/2, HEIGHT + 50);
  
} 
