// Sample code for starting the meshes project

import processing.opengl.*;

float time = 0;  // keep track of passing of time (for automatic rotation)
boolean rotate_flag = true;       // automatic rotation of model?

float[][] geometryT;
int[] vertexT;
int[] oppositesT;

boolean debug = true;

// initialize stuff
void setup() {
  size(400, 400, OPENGL);  // must use OPENGL here !!!
  noStroke();     // do not draw the edges of polygons
  if(debug) read_mesh ("tetra.ply");
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
  
  // THIS IS WHERE YOU SHOULD DRAW THE MESH
  
  beginShape();
  normal (0.0, 0.0, 1.0);
  vertex (-1.0, -1.0, 0.0);
  vertex ( 1.0, -1.0, 0.0);
  vertex ( 1.0,  1.0, 0.0);
  vertex (-1.0,  1.0, 0.0);
  endShape(CLOSE);
  
  popMatrix();
 
  // maybe step forward in time (for object rotation)
  if (rotate_flag )
    time += 0.02;
}




// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh(String filename){
  int i;
  String[] words;
  
  String lines[] = loadStrings(filename);
  
  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  println ("number of vertices = " + num_vertices);
  
  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  println ("number of faces = " + num_faces);
  
  vertexT = new int[num_faces*3];//create a new set of vertices in pvector form
  oppositesT = new int[num_faces*3];
  geometryT = new float[num_vertices][3];//hello

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
  
  println("done with that business");
  
  //create opposite table
  createCorners(vertexT, oppositesT);
  //printArray(oppositesT);
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

