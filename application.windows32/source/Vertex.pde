class Vertex implements Comparable<Vertex>{
  public Vertex(){
   this.label = null;

  }
  public Vertex(int x, int y, char id){
    this.id = id;
    this.label = new Label(x,y,32,32,  0, 230,230, String.valueOf(this.id), 30);
  }
  public Vertex(int x, int y, int id){
       this.id = char(id);
    this.label = new Label(x,y,32,32,  0, 230,230, String.valueOf(this.id), 30);
   
  }
  public Vertex (Vertex other){
    this.label = getLabel();

    this.id = other.id;

  }
  public int getID(){
    return id;
  }
  
  public int compareTo(Vertex v){
     return id - v.getID();
  }
 
  @Override public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.getLabel() == ((Vertex)o).getLabel() && 
                                       this.id == ((Vertex)o).getID());
  }
  public Label getLabel(){
    return label;
  }
  void draw(){
    if(label != null)
      label.draw();
  }
  Label label;
  char id;


}