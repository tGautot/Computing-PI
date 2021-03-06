///////////////////////////////////////////////////////
// Created by Tom Gautot on 04/02/2019 (dd/mm/yyy)
//
// Approximates values of PI for 3 different infinite integrals
// and animates the function going through the values
// (Doesn't work if you integrate over small intervals such as [-1; 1], is too imprecise)
////////////////////////////////////////////////////////

int HEIGHT = 500;
int WIDTH = 700;

int CODE = 1602; // Describes which function to use
// 1601: sin(x)/x
// 1602: 1/(1+x^2)
// 1603: e^(-x^2)

int BGN_NTGRL = -100000;
int END_NTGRL = -BGN_NTGRL;

float horizontalScale = 3*10/7.0; // Is the number of units on the x axis on the screen at any time
float verticalScale = 1.5; // Means that half the screen is 1.5 value for y

int centerX = 0;
int maxStepPerFrame = END_NTGRL; // Arbitrary
int sumOfSteps = 0;

float totalArea = 0;

void setup() {
  size(1000, 700, P3D);  // Size must be the first statement
  stroke(255);     // Set line drawing color to white
  frameRate(30);
  
  
  int BGN_NTGRL_PX = BGN_NTGRL * (int)((float)width/horizontalScale);
  int END_NTGRL_PX = END_NTGRL * (int)((float)width/horizontalScale);
  
  beginCamera();
  translate(width/2+END_NTGRL_PX, height/2);
  centerX=BGN_NTGRL_PX;
  endCamera();
  totalArea = getArea(BGN_NTGRL_PX, centerX); // first part of the area
  
}

void writePiValue(float pi){
  textSize(54);
  textAlign(CENTER, CENTER);
  text("π = " + nf(pi, 1, 10), centerX, 2*height/5);
}

public void drawXValue(int xPos, int xVal){
  textSize(12);
  textAlign(LEFT, TOP);
  text("" +  nf(xVal, 3, 0), xPos + 5, +3);
}

public float getFunctionValue(float x){
  // If using (INTGRAL, -INF, INF)[sin(x)/x dx] = PI
  if(CODE == 1601){
    if(abs(x) < 0.0000001) return 1.0; 
    return sin(x)/x;
  }
  
  //If using (INTGRAL, -INF, INF)[1/(1+x^2) dx] = PI
  if(CODE == 1602) return 1/(1+x*x);
  
  //If using (INTGRAL, -INF, INF)[1/(1+x^2) dx] = sqrt(PI)
  if(CODE == 1603) return exp(-x*x);
  
  return 0;
}

public float getArea(int startX, int endX){
  
  float vSpacing = ((float)width/horizontalScale); // Represents the amount of pixels in one unit length on the x axis
  
  float out = 0.0f;
  
  float y;
  for(int i = startX; i < endX; i++){
    y = getFunctionValue(i/vSpacing);
    
    out+=y/vSpacing; // 1 is the width (delta X), divide by vSpacing to have area in units, not pixels, (v and h may be swapped)
  }
  
  return out;
}

public void plotCustomFuntion(int startXPos, int endXPos){
  float vSpacing = ((float)width/horizontalScale); // Represents the amount of pixels in one unit length on the x axis
  float hSpacing = ((float)height/(verticalScale*2)); // Represents the amount of pixels in one unit length on the y axis
  int midX = (startXPos + endXPos)/2;
  float val;
  float last = getFunctionValue((startXPos-1)*vSpacing);
  float yVal, yLast = -last*hSpacing;
  
  
  for(int i = startXPos; i < endXPos; i++){
    val = getFunctionValue(i/vSpacing);
    yVal = -val*hSpacing;
    
    if(i <= midX){
      stroke(255, 255, 0);
      beginShape();
      vertex(i-1, 0);
      vertex(i-1, yLast);
      vertex(i, 0);
      vertex(i, yVal);
      endShape(CLOSE);
    }
    stroke(255);
    point(i, yVal);

    last = val;
    yLast = yVal;
  }
  
}

/*  Tried this function (which looks kinda like a sigmoid) but results weren't too great
//float speedFlatener = 0.00002;
public float speedFunction(int xPix){ 
  float vSpacing = ((float)width/horizontalScale);
  float x = xPix/vSpacing;
  return 1.0/(1.0+pow(PI, -speedFlatener*x*x));
  
}
*/

public int getStep(){ // Go fast when far from (0,0), go slower when close to it
  float vSpacing = ((float)width/horizontalScale);
  
  int END_NTGRL_PX = END_NTGRL * (int)((float)width/horizontalScale);
  
  if(abs(centerX - END_NTGRL_PX) < maxStepPerFrame) return -abs(centerX-END_NTGRL_PX);
  
  int xPix = centerX;
  int xVal = xPix/(int)vSpacing;
  if(xPix < 0) xPix = -xPix;
  
  //Note the values are arbitrary
  
  if(xPix <= maxStepPerFrame || abs(xVal) < 10){
    if(xPix < 1000) return -20;
    else return -2*xPix/100;
  }
  return -maxStepPerFrame;
}

float computePiFromArea(){
  if(CODE == 1603) return totalArea*totalArea;
  else return totalArea;
}

void draw() { 
  background(0);   // Clear the screen with a black background
  
  float pi = computePiFromArea();
  writePiValue(pi); // We write pi in the beginning or it will look blurry (because we write the small numbers on the x axis)
  
  int BGN_NTGRL_PX = BGN_NTGRL * (int)((float)width/horizontalScale); // Represents the amount of pixels needed to cover the integration interval 
  int END_NTGRL_PX = END_NTGRL * (int)((float)width/horizontalScale); 
 
 
  //Move camera along the x axis, speed depending on the position
  int stepForFrame = getStep();
  totalArea += getArea(centerX, centerX - stepForFrame); // Add the area below the part of the function we just passed
 
  beginCamera();
  translate(stepForFrame, 0);
  centerX-=stepForFrame;
  sumOfSteps+=stepForFrame;
  endCamera();
 
  
  stroke(255);
  fill(255);
  rect(BGN_NTGRL_PX-width, -1, 2*END_NTGRL_PX + 5*width, 2); // Main x axis
  rect(-1, -height, 2, 2*height); // Main y axis
  
  
  //  SMALL HORIZONTAL LINES
  float spacing = ((float)height/2.0)/verticalScale;
  int k = 1;
  boolean first = true;
  for(int i = 1; i <= 2*((int)verticalScale); i++){
    
    if(i > verticalScale && first){
      first = false;
      k = 1;
    }
    
    int lineHeight = (int)(spacing*k); 
    //print("Line at height " + lineHeight + "\n");
    
    if(i <= verticalScale){
      rect(centerX-3*width/2,  lineHeight, 2*width, 0); //Line above X axis (Dunno why these X values work)
    } else {
      rect(centerX-3*width/2, -lineHeight, 2*width, 0); //Line below X axis (Dunno why these X values work)
    }
    k++;
  }
  
  
  
  //   SMALL VERTICAL LINES
  spacing = ((float)width)/horizontalScale;
  int shift = sumOfSteps%((int)spacing);
  k = 1;
  first = true;
  int linePos, xVal;
  for(int i = 1; i <= 2*((int)horizontalScale); i++){
    
    xVal = centerX/((int)spacing); // Value of the middle line
    
    if(i > horizontalScale && first){
      first = false;
      k = 1;
      
      int midLinePos = centerX + shift;
      rect(midLinePos, -height, 0, 2*height); // The line in the middle
      
      drawXValue(midLinePos, xVal); // Draw the small number nex to some multiple of unit value (there may be problems here, with xVal)
      
    }
    
    int lineDist = (int)(spacing*k); 
    //print("Line at dist " + lineDist + "\n");
    
    //print("Mid val is " + xVal + "\n");    
    if(i <= horizontalScale){
      linePos = centerX + lineDist + shift; //Line to the right of the center of the camera
      xVal+=k;
    } else {
      linePos = centerX - lineDist + shift; //Line to the left of the center of the camera
      xVal-=k;    
    }
    
    drawXValue(linePos, xVal); // Draw the small number nex to some multiple of unit value (there may be problems here, with xVal)
    rect(linePos, -height, 0, 2*height); 
    
    k++;
  }
  
  plotCustomFuntion(centerX-width/2, centerX+width/2);
  
  
  if(centerX > END_NTGRL_PX) noLoop(); // Stop
  
  
} 
