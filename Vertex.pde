class Vertex implements Comparable<Vertex>{
  public Vertex(){
    this.label = '\0';
    this.x = 0.0;
    this.y = 0.0;
    this.neighborSet = new LinkedList<Vertex>();
  }
  public Vertex(float x, float y, char label){
    this.label = label;
    this.x = x;
    this.y = y;
    this.neighborSet = new LinkedList<Vertex>();
  }
  public Vertex (Vertex other){
    this.label  = other.label;
    this.x  = other.x;
    this.y  = other.y;
    this.neighborSet = other.neighborSet;
  }
  
  public void addNeighbor(Vertex v){
    if(!neighborSet.contains(v))
      neighborSet.add(v);
      
  }
  public int compareTo(Vertex v){
     return ((Vertex) v).label - label;
  }
  public LinkedList<Vertex> getNeighbors(){
    return neighborSet;
      
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.x == ((Vertex)o).x && 
                                       this.y == ((Vertex)o).y && 
                                       this.label == ((Vertex)o).label);
  }
  public boolean intersects(float x, float y){
    //if vertex ellipse is within clickable range ( if abs(dist) between this(x,y) and (x,y) < radius then (x,y) in e       
    if(sqrt(pow(this.x-x,2) + pow(this.y-y,2))< radius){
      return true;
    }
      return false;  

 }
  void draw(){
    pushMatrix();
    
    //render pos in eucledian space
    stroke(0,130, 240);  //pen stroke color color bgr
    fill(0,130, 240);     //file  rect with same color
    ellipse(x,y,radius,radius);
    
    //render label on top
    textSize(textSize);
    fill(245, 230,240); //nearly white text 
    text(label, x-radius*0.30,y+radius*0.30);
    popMatrix();
  }
  public char label;
  public float x,y;
  public float radius = 32;
  public float textSize = 32*.85;
  LinkedList<Vertex> neighborSet;

}