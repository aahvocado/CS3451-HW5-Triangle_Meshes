// Sample code for starting the meshes project

import processing.opengl.*;

float time = 0;  // keep track of passing of time (for automatic rotation)
boolean rotate_flag = true;       // automatic rotation of model?

float[][] geometryT;
int[] vertexT;
int[] oppositesT;
color[] colorT;

String shadingType = "flat";//toggle shading type
String colorType = "default";//default, white, or random color

boolean debug = true;


// initialize stuff
void setup() {
  //reset();
  size(400, 400, OPENGL);  // must use OPENGL here !!!
  noStroke();     // do not draw the edges of polygons
  if(debug) read_mesh ("tetra.ply");
}

void reset(){
   geometryT = new float[0][0];
   vertexT = new int[0];
   oppositesT = new int[0];
   colorT = new color[0];
   
}

// Draw the scene
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(0);  // clear the screen to black
  
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  // place the camera in the scene (just like gluLookAt())
  camera (0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  
  scale (1.0, -1.0, 1.0);  // change to right-handed coordinate system
  
  // create an ambient light source
  ambientLight(102, 102, 102);
  
  // create two directional light sources
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, -0.7, -0.7, -1);
  directionalLight(152, 152, 152, 0, 0, -1);
  
  pushMatrix();

  fill(50, 50, 200);            // set polygon color to blue
  ambient (200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);
  
  rotate (time, 1.0, 0.0, 0.0);
  
  PVector a = null, b = null, c = null;//three points to draw for a triangle
  // THIS IS WHERE YOU SHOULD DRAW THE MESH
  if(geometryT != null){
    for(int i=0;i<vertexT.length;i+=3){//go by threes because that makes sense
      drawTriangle(i, i+1, i+2);
    }
  }else{//boring square
      beginShape();
      normal (1.0, 0.0, 0.0);
      vertex (-1.0, -1.0, 0.0);
      vertex ( 1.0, -1.0, 0.0);
      vertex ( 1.0,  1.0, 0.0);
      vertex (-1.0,  1.0, 0.0);
      endShape(CLOSE);
  }
  
  popMatrix();
 
  // maybe step forward in time (for object rotation)
  if (rotate_flag )
    time += 0.02;
}

//draw a shape with three vertices
void drawTriangle(int a, int b, int c){
  //get the three vertices from the vertex table
  PVector pa = getVector(getV(a));
  PVector pb = getVector(getV(b));
  PVector pc = getVector(getV(c));
  
  //draw the shape
  beginShape();
  int colorNum = getTriangle(a);
  fill(colorT[colorNum]);
  PVector n = calculateNormal(pa, pb, pc);
  normal (n.x, n.y, n.z);
  vertex (pa.x, pa.y, pa.z);
  vertex (pb.x, pb.y, pb.z);
  vertex (pc.x, pc.y, pc.z);
  endShape(CLOSE);
}

//finds the surface normal 
PVector calculateNormal(PVector a, PVector b, PVector c){
  PVector r = new PVector(0,0,0);
  if(shadingType == "flat"){//calculate normal by per face
    r = a.cross(b);
  }else{//calculate normal by per vertex
    
  }
  r.normalize();
  return r;
}


void triangulatedDual(){
}

//toggle between per-face and per-vertex normal shading
void toggleShading(){
  if(shadingType == "flat"){
    shadingType = "smooth";
  }else{
    shadingType = "flat";
  }
  println("shading: "+shadingType);
}
//inits color, just blue like originally for now
void initColor(){
  colorType = "default";
  colorT = new color[vertexT.length];
  for(int i = 0; i<colorT.length; i ++){
    colorT[i] = color(50,50,200);
  }
  println(colorType + " coloring ");

}
//change color to a random color
void changeColor(){
  colorType = "random";
  colorT = new color[vertexT.length];
  for(int i = 0; i<colorT.length; i ++){
    colorT[i] = color(random(255),random(255),random(255));
  }
  println(colorType + " coloring ");
}  

void turnWhite(){
  colorType = "white";
  colorT = new color[vertexT.length];
  for(int i = 0; i<colorT.length; i ++){
    colorT[i] = color(255,255,255);
  }
  println(colorType + " coloring ");

}

// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh(String filename){
  println("\n231reading new mesh");
  int i;
  String[] words;
  
  String lines[] = loadStrings(filename);
  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  println ("number of vertices = " + num_vertices);
  
  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  println ("number of faces = " + num_faces);
  
  //instantiate all these arrays with data
  vertexT = new int[num_faces*3];
  oppositesT = new int[num_faces*3];
  geometryT = new float[num_vertices][3];

  // read in the vertices
  for (i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    float x = float(words[0]);
    float y = float(words[1]);
    float z = float(words[2]);
    println ("vertex = " + x + " " + y + " " + z);
    
    //create vertex for geometry table
    geometryT[i][0] = x;
    geometryT[i][1] = y;
    geometryT[i][2] = z;
    
  }
  
  // read in the faces
  for (i = 0; i < num_faces; i++) {
    
    int j = i + num_vertices + 2;
    words = split (lines[j], " ");
    
    int nverts = int(words[0]);
    if (nverts != 3) {
      println ("error: this face is not a triangle.");
      exit();
    }
    
    int index1 = int(words[1]);
    int index2 = int(words[2]);
    int index3 = int(words[3]);
    println ("face = " + index1 + " " + index2 + " " + index3);
    
    //hope we did vertexT correct!
    vertexT[i*3+0] = index1;
    vertexT[i*3+1] = index2;
    vertexT[i*3+2] = index3;
  }
    
  //create opposite table
  createCorners(vertexT, oppositesT);
  //printArray(oppositesT);
  
  //load color data
  if(colorType == "default"){
      initColor();
  }else if(colorType == "random"){
      changeColor();
  }else if(colorType == "white"){
      turnWhite();
  }
  
  println("done reading data");
}

//creates the opposites table from v into o
void createCorners(int[] v, int[] o){
  for(int i = 0; i < v.length; i++){
    for(int j = 0; j < v.length; j++){
      int a = i;
      int b = j;
      
      /*println(a + " / " + b);
      println(getV(getNext(a)) + " and " + getV(getPrev(b)));
      println(getV(getPrev(a)) + " and " + getV(getNext(b)));
      println();*/
      
      if(getV(getNext(a)) == getV(getPrev(b)) && getV(getPrev(a)) == getV(getNext(b))){
        //println("match!");
        oppositesT[a] = b;
        oppositesT[b] = a;
      }
    }
  }
}


void create_sphere() {}
