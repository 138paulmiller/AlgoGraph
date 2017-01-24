class Vertex extends Label {
  public Vertex(){
    super(0,0,0,0,"",0);
  }
  public Vertex (Vertex other){
   super(other);
    this.id = other.id;
  }
  public Vertex(int x, int y, char id){
    super(x,y,32,32, String.valueOf(id), 30);
    this.id = id;
    setTextRGB( 10, 20,0);
     setRGB( 0, 230,230);
  }
  public Vertex(int x, int y, int id){
    super(x,y,32,32, String.valueOf(id), 30);
    this.id = char(id);
    setTextRGB( 10, 20,0);
    setRGB( 0, 230,230);
  }
  
  public int getID(){
    return id;
  }
  
  public int compareTo(Vertex v){
     return id - v.getID() ;
  }
 
  public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.id == ((Vertex)o).getID());
  }
 
 
  char id;

}