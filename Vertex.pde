class Vertex implements Comparable<Vertex>{
  public Vertex(){
    this.button = new Button(0,0,0,0,"\0",0);
    this.id='\0';

  }
  public Vertex(float x, float y, char id){
    this.button = new Button(x,y,32,32,String.valueOf(id),30);
    this.id = id;
  }
  public Vertex(float x, float y, int id){
    this.button = new Button(x,y,32,32,String.valueOf(id),30);
    this.id = char(id);
  }
  public Vertex (Vertex other){
    this.button = new Button(other.button);
    this.id = other.id;

  }
  public int getID(){
    return id;
  }
  
  public int compareTo(Vertex v){
     return id - v.getID();
  }
 
  @Override public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.getButton().getX() == ((Vertex)o).getButton().getX() && 
                                       this.getButton().getY() == ((Vertex)o).getButton().getY() && 
                                       this.id == ((Vertex)o).getID());
  }
  
  public Button getButton(){
    return button;
  }
  void draw(){
    button.draw();
  }
  public Button button;
  char id;


}