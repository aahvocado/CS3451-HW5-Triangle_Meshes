//daniel xiao

import processing.opengl.*;

float time = 0;  // keep track of passing of time (for automatic rotation)
boolean rotate_flag = true;       // automatic rotation of model?

float[][] geometryT;
int[] vertexT;
int[] oppositesT;
color[] colorT;

String shadingType = "flat";//flat or smooth shading type
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
  //get color from a table
  int colorNum = getTriangle(a);
  fill(colorT[colorNum]);
  //draw vertices based on shading type
  if(shadingType == "flat"){
    PVector e1 = PVector.sub(pb, pa);
    PVector e2 = PVector.sub(pc, pa);
    PVector n = e1.cross(e2);
    normal (n.x, n.y, n.z);
    
    vertex (pa.x, pa.y, pa.z);
    vertex (pb.x, pb.y, pb.z);
    vertex (pc.x, pc.y, pc.z);
  }else if(shadingType == "smooth"){
    normal (pa.x, pa.y, pa.z);
    vertex (pa.x, pa.y, pa.z);
    
    normal (pb.x, pb.y, pb.z);
    vertex (pb.x, pb.y, pb.z);
    
    normal (pc.x, pc.y, pc.z);
    vertex (pc.x, pc.y, pc.z);
  }
  endShape(CLOSE);
}

//go through the process of triangulating the current mesh
void triangulatedDual(){
  ArrayList<float[]> newGeometryT = new ArrayList<float[]>();
  ArrayList newVertexT = new ArrayList();

  for(int i=0;i<vertexT.length;i++){
    ArrayList<PVector> centroidsList = new ArrayList<PVector>();
  }
  
  
//BLAHHHHH

//  for(int i=0;i<vertexT.length;i+=3){
//    //find the values of these vecters
//    PVector pa = getVector(getV(i));
//    PVector pb = getVector(getV(i+1));
//    PVector pc = getVector(getV(i+2));
//    //get centroid
//    PVector centroid = calculateCentroid(pa, pb, pc);
//    float[] newVertices = {centroid.x, centroid.y, centroid.z};
//
//    int vertexIndex = newGeometryT.size();//temp variable to track the vertex position
//    //see if we have already have a copy of this vertex
//    int searchIndex = newGeometryT.indexOf(newVertices);
//    if(searchIndex > -1){//found location
//      vertexIndex = searchIndex;
//    }else{//add a copy to the geometry table
//      //println("new triangulated vertex added to geometry table");
//      newGeometryT.add(newVertices);
//    }
//    newVertexT.add(vertexIndex);
//  }
//  
//  
//  //replace the current tables
////  vertexT = new int[newVertexT.size()];
////  for(int j=0;j<newVertexT.size();j++){
////    vertexT[j] = (Integer)newVertexT.get(j);
////  }
//  
//  geometryT = functionToConvertArrayListTo2DArray(newGeometryT);
//  
//  checkMesh();
//  println("triangulated dual complete");
}
//give it an arraylist containing size 3 arrays pls
float[][] functionToConvertArrayListTo2DArray(ArrayList a){
  float[][] r = new float[a.size()][3];
  for(int i = 0;i<a.size();i++){
    float[] array = (float[])a.get(i);
    if(array.length == 3){
      r[i][0] = array[0];
      r[i][1] = array[1];
      r[i][2] = array[2];
    }else{
      println("ERROR this isn't a length 3 array");
    }
  }
  return r;
}

//simply finds the median of all three points
PVector calculateCentroid(PVector a, PVector b, PVector c){
  return new PVector((a.x+b.x+c.x/3),(a.y+b.y+c.y/3),(a.z+b.z+c.z/3));
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
    
  checkMesh();
  println("done reading data");
}

//stuff to do at the end of a new mesh
void checkMesh(){
  //create opposite table
  createCorners(vertexT, oppositesT);
  //printArray(oppositesT);
  
  refreshColorTable();
}

//corrects the color table
void refreshColorTable(){
  //load color data
  if(colorType == "default"){
      initColor();
  }else if(colorType == "random"){
      changeColor();
  }else if(colorType == "white"){
      turnWhite();
  }
}

//creates the opposites table from v into o
void createCorners(int[] v, int[] o){
  for(int i = 0; i < v.length; i++){
    for(int j = 0; j < v.length; j++){
      int a = i;
      int b = j;

      if(getV(getNext(a)) == getV(getPrev(b)) && getV(getPrev(a)) == getV(getNext(b))){
        oppositesT[a] = b;
        oppositesT[b] = a;
      }
    }
  }
}


void create_sphere() {}
