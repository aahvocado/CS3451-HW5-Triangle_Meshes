

//gets the coordinates from the geometry table
PVector getVector(int v){
  return new PVector(geometryT[v][0], geometryT[v][1], geometryT[v][2]);
}

//c.t gets the triangle index from a corner
int getTriangle(int c){
  return floor(c/3);
}

//c.o opposite
int getOpposite(int c){
  return oppositesT[c];
}

//c.n next corner
int getNext(int c){
  return 3*getTriangle(c) + (c+1)%3;
}

//c.p previous corner
int getPrev(int c){
  return getNext(getNext(c));
}

//c.v v[c] reference to vertex in geometry table
int getV(int c){
  return vertexT[c];
}

//c.r right
int getRight(int c){
  return getOpposite(getNext(c));
}

//c.l left
int getLeft(int c){
  return getOpposite(getPrev(c));
}

//c.s swing
int getSwing(int c){
  return getNext(getOpposite(getNext(c)));
}

//c.u unswing
int getUnswing(int c){
  return getPrev(getOpposite(getPrev(c)));
}

