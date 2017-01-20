import java.util.HashMap;
float red = 0, green =250,blue = 140;
float buttonWidth =250 , buttonHeight = 32;
String noneLabel ="NONE";
String bfsLabel = "BFS";
Menu menu = new Menu(72,32);
UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null;
void setup(){
  size(1080, 720);
  initDefaultGraph();
  menu.addButton("BFS");
  menu.addButton("DFS");

}


void draw(){
 background(0); 
 undirgraph.draw();
 menu.draw();
}
void mouseClicked(){
  Vertex v = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
   Button b = menu.getIntersectingButton(mouseX, mouseY);//get vertex clicked
  
  //if vertex right clicked
  if(mouseButton == RIGHT && v != null){ //right click vertex to show menu
    menu.setPosition(mouseX, mouseY);
    menu.open();
    selectedVertex = v;
  }
  //if button left clicked
  else if(mouseButton == LEFT){
      if(b != null && selectedVertex != null ){ //if menu button click
        print("Clicked Button: "+  b.getText());
        if(b.getText() == "BFS"){
          UndirectedGraph bfs = getBFS(undirgraph,selectedVertex);
          if(bfs != null){
            undirgraph = bfs;
          }
        }
      selectedVertex = null; //deselect vertex
    }
   menu.hide();//hide menu  
  }//if left
}
Vertex getIntersectingVertex(float x, float y){
  for(Vertex v : undirgraph.getVertexSet()){
      if(v.getButton().intersects(x,y)){
         return v; //return vertex 
      }
  }
  return null;
}
void mousePressed(){
  if(mouseButton == LEFT){
    Vertex v = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
    if(v != null)
        selectedVertex = v;

  }
}
void mouseDragged(){
  if(mouseButton == LEFT && selectedVertex != null){
    selectedVertex.getButton().setX(selectedVertex.getButton().getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    selectedVertex.getButton().setY(selectedVertex.getButton().getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
  }
}
void mouseReleased(){
  if(mouseButton == LEFT ){
  }
}
void keyPressed(){
 if(keyCode == ' '){ //clear
   initDefaultGraph();
 }
}
void initDefaultGraph(){
  undirgraph.clear();
 Vertex a = new Vertex(440,294,"A");
  Vertex b= new Vertex(45,450,"B");
  Vertex c = new Vertex(590,200,"C");
  Vertex d = new Vertex(800,534,"D");
  Vertex e = new Vertex(900,90,"E");
  Vertex f = new Vertex(105,85,"F");
  Vertex g = new Vertex(330,220,"G");
  undirgraph.addEdge(a,c, 10);
  undirgraph.addEdge(a,d, 7);
  undirgraph.addEdge(d,c, 9);
  undirgraph.addEdge(d,b, 32);  
  undirgraph.addEdge(d,e, 23); 
  undirgraph.addEdge(f,c, 93);
  undirgraph.addEdge(f,b, 38);  
  undirgraph.addEdge(f,e, 43); 
  undirgraph.addEdge(f,g, 7); 
  undirgraph.addEdge(g,e, 17); 
  undirgraph.addEdge(g,a, 2); 
  undirgraph.addEdge(g,b, 45);  
}