
class Edge extends Label {
  public Edge(){
    super(0,0,0,0,"",0);
   this.source = null;
   this.dest = null;
    this.weight = 0;
  }
  public Edge(Vertex source, Vertex dest, int weight){
      super((int)(source.getX()+dest.getX())/2,//x
                       (int)(source.getY()+ dest.getY())/2, //y
                      64, 32,//w, h/rgb
                      String.valueOf(weight), 30);
   this.source = source;
   this.dest = dest;
   this.weight = weight;
   lr = 103;
   lg = 45;
   lb = 0;
   setRGB(130,120,0);
   setTextRGB(0,190,10);
   setFilled(false);      
    
  }
  public Edge(Edge other){
   super(other);
   this.source = other.source;
   this.dest = other.dest;
    this.weight = other.weight;
  }
  public int compareTo(Edge e){
    int val = weight -  e.weight;
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
 
  public void setWeight(int weight){
    this.weight = weight;
    setText(String.valueOf(weight));
  }
   public void setLineRGB(int r,int g,int b){
    this.lr = r;
    this.lg = g;
    this.lb = b;
  }
  public int getWeight(){
  return weight;
  }
  boolean hasVertices() {return (this.source != null && this.dest != null);}
  void draw(){
    if(hasVertices()){
      pushMatrix();
      //draw line from source to dest
      stroke(lr,lg,lb);
      strokeWeight(4);
      line(source.getX(),source.getY(),dest.getX(),dest.getY());
      setPosition((int)(source.getX()+dest.getX())/2,//x
                     (int)(source.getY()+ dest.getY())/2);
      super.draw();
      popMatrix();
    }
  }
  Vertex source,dest;
  int lr,lg,lb;
  int weight;
}