
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
    int val =  weight - e.weight;
    if( val == 0) //order by vertex if equal
      val = dest.compareTo(e.getDest());    
    return val;
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
      line(source.getButton().getX(),source.getButton().getY(),dest.getButton().getX(),dest.getButton().getY());
      textSize(source.getButton().getTextSize());
      fill(60,245, 0);     //file  rect with same color

      text(String.valueOf(weight), (source.getButton().getX()+dest.getButton().getX())/2.0,( source.getButton().getY()+ dest.getButton().getY())/2.0);
      popMatrix();
    }
  }
  Vertex source,dest;
  int weight;
}