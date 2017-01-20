import java.util.HashMap;
float red = 0, green =250,blue = 140;
float buttonWidth =250 , buttonHeight = 32;
String noneLabel ="NONE";
String bfsLabel = "BFS";
Menu vertexMenu = new Menu(72,32);
UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null;
void setup(){
  size(1080, 720);
  initDefaultGraph();
  vertexMenu.addButton("BFS");
  vertexMenu.addButton("DFS");

}

void draw(){
 background(0); 
 undirgraph.draw();
 vertexMenu.draw();
}
void mouseClicked(){
  Vertex v = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
   Button b = vertexMenu.getIntersectingButton(mouseX, mouseY);//get vertex clicked
  
  //if vertex right clicked
  if(mouseButton == RIGHT && v != null){ //right click vertex to show vertexMenu
    vertexMenu.setPosition(mouseX, mouseY);
    vertexMenu.open();
    selectedVertex = v;
  }
  //if button left clicked
  else if(mouseButton == LEFT){
      if(b != null && selectedVertex != null ){ //if vertexMenu button click
        print("Clicked Button: "+  b.getText());
        processAlgorithm(b.getText());
      selectedVertex = null; //deselect vertex
    }
   vertexMenu.hide();//hide vertexMenu  
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
  Button b = vertexMenu.getIntersectingButton(mouseX,mouseY);
  if(mouseButton == LEFT && b == null ){
      vertexMenu.hide();
    selectedVertex = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
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
void processAlgorithm(String algorithmID){
 if(algorithmID == "BFS"){
    UndirectedGraph bfs = getBFS(undirgraph,selectedVertex);
    if(bfs != null){
      undirgraph = bfs;
    }
 }
 else if(algorithmID == "DFS"){
    UndirectedGraph dfs = getDFS(undirgraph,selectedVertex);
    if(dfs != null){
      undirgraph = dfs;
    }
  }
}
void initDefaultGraph(){
  undirgraph.clear();
 Vertex a = new Vertex(440,294,'A');
  Vertex b= new Vertex(45,450,'B');
  Vertex c = new Vertex(590,200,'C');
  Vertex d = new Vertex(800,534,'D');
  Vertex e = new Vertex(900,90,'E');
  Vertex f = new Vertex(105,85,'F');
  Vertex g = new Vertex(330,220,'G');
  undirgraph.addEdge(a,c, 1);
  undirgraph.addEdge(a,d, 1);
  undirgraph.addEdge(d,c, 1);
  undirgraph.addEdge(d,b, 1);  
  undirgraph.addEdge(d,e, 1); 
  undirgraph.addEdge(f,c, 1);
  undirgraph.addEdge(f,b, 1);  
  undirgraph.addEdge(f,e, 1); 
  undirgraph.addEdge(f,g, 1); 
  undirgraph.addEdge(g,e, 1); 
  undirgraph.addEdge(g,a, 1); 
  undirgraph.addEdge(g,b, 1); 
  for(Vertex v : undirgraph.getVertexSet())
    print(char(v.getID()) + "\n");
}