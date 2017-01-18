
class Edge implements Comparable<Edge>{
  public Edge( ){
   this.source = null;
   this.dest = null;
    this.weight = 0;
  }
  public Edge(Vertex source, Vertex dest, int weight){
   this.source = source;
   this.dest = dest;
    this.weight = weight;
  }
  public Edge(Edge other){
   this.source = other.source;
   this.dest = other.dest;
    this.weight = other.weight;
  }
  public int compareTo(Edge e){
    return weight - e.weight;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Edge) && (this.source == ((Edge)o).source && 
                                    this.dest == ((Edge)o).dest && 
                                     this.weight == ((Edge)o).weight);
  }
  public Vertex getSource() {
      return source;
  }
  public Vertex getDest() {
      return dest;
  }
  boolean hasVertices() {return (this.source != null && this.dest != null);}
  void draw(){
    if(hasVertices()){
      pushMatrix();
      stroke(140, 50,0);  //color rgb
      strokeWeight(3);
      line(this.source.x,this.source.y,this.dest.x,this.dest.y);
      textSize(this.source.textSize);
      fill(60,245, 0);     //file  rect with same color

      text(String.valueOf(weight), (this.source.x+this.dest.x)/2.0,(this.source.y+this.dest.y)/2.0);
      popMatrix();
    }
  }
  Vertex source,dest;
  int weight;
}