
class Edge implements Comparable<Edge>{
  public Edge( ){
    this.a = null;
    this.b = null;
    this.weight = 0;
  }
  public Edge(Vertex a, Vertex b, int weight){
    this.a = a;
    this.b = b;
    this.weight = weight;
  }
  public Edge(Edge other){
    this.a = other.a;
    this.b = other.b;
    this.weight = other.weight;
  }
  public int compareTo(Edge e){
    return ((Edge)e).weight - weight;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Edge) && (this.a == ((Edge)o).a && 
                                     this.b == ((Edge)o).b && 
                                     this.weight == ((Edge)o).weight);
  }
  boolean hasVertices() {return (a != null && b != null);}
  void draw(){
    if(hasVertices()){
      pushMatrix();
      stroke(140, 50,0);  //color rgb
      strokeWeight(3);
      line(a.x,a.y,b.x,b.y);
      textSize(a.textSize);
      fill(60,245, 0);     //file  rect with same color

      text(String.valueOf(weight), (a.x+b.x)/2.0,(a.y+b.y)/2.0);
      popMatrix();
    }
  }
  Vertex a,b;
  int weight;
}