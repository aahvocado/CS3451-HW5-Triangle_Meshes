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

//c.l left

//c.s swing

//c.u unswing


