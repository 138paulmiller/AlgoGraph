
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
   label = new Label((int)(source.getLabel().getX()+dest.getLabel().getX())/2,//x
                     (int)(source.getLabel().getY()+ dest.getLabel().getY())/2, //y
                    64, 32,//w, h/rgb
                    String.valueOf(weight), 30);
   label.setRGB(130,120,0);
   label.setTextRGB(0,190,10);
   label.setFilled(false);      
    
  }
  public Edge(Edge other){
   this.source = other.source;
   this.dest = other.dest;
    this.weight = other.weight;
    this.label = other.label;
  }
  public int compareTo(Edge e){
    int val =  weight - e.weight;
    if( val == 0) //order by vertex dest if equal
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
  public Label getLabel(){
    return label;
  }
  public void setWeight(int weight){
    this.weight = weight;
    this.label.setText(String.valueOf(weight));
  }
  public int getWeight(){
  return weight;
  }
  boolean hasVertices() {return (this.source != null && this.dest != null);}
  void draw(){
    if(hasVertices()){
      pushMatrix();
      //draw line from source to dest
      stroke(103,45,0);
      strokeWeight(4);
      line(source.getLabel().getX(),source.getLabel().getY(),dest.getLabel().getX(),dest.getLabel().getY());
      label.setPosition((int)(source.getLabel().getX()+dest.getLabel().getX())/2,//x
                     (int)(source.getLabel().getY()+ dest.getLabel().getY())/2);
      label.draw();
      popMatrix();
    }
  }
  Vertex source,dest;
  Label label;
  int weight;
}