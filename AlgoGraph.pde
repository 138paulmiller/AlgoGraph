UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null;
void setup(){
  size(1080, 720);
  Vertex a = new Vertex(105,85,'A');
  Vertex b= new Vertex(45,350,'B');
  Vertex c = new Vertex(150,200,'C');
  Vertex d = new Vertex(700,534,'D');
  Vertex e = new Vertex(100,60,'E');
  Vertex f = new Vertex(500,54,'F');
  Vertex g = new Vertex(500,54,'G');
  undirgraph.addEdge(a,b, 31);
  undirgraph.addEdge(d,b, 52);
  undirgraph.addEdge(a,c, 20);
  undirgraph.addEdge(a,d, 32);  
  undirgraph.addEdge(c,d, 57);
  undirgraph.addEdge(e,d, 43);
  undirgraph.addEdge(e,f, 22);
  undirgraph.addEdge(c,f, 84);
  undirgraph.addEdge(b,f, 22);
  undirgraph.addEdge(a,g, 30);
  undirgraph.addEdge(f,g, 37);
  undirgraph.addEdge(b,g, 29);  

}


void draw(){
 background(0); 
 undirgraph.draw();
}
void mouseClicked(){
  for(Vertex v : undirgraph.getVertexSet()){
    if(v.intersects(mouseX, mouseY)){
      UndirectedGraph bfs = undirgraph.getBFS(v);
      if(bfs != null){
        undirgraph = bfs;
      }
    }
  }
}
void mousePressed(){
  for(Vertex v : undirgraph.getVertexSet()){
    if(v.intersects(mouseX, mouseY)){
      selectedVertex = v;
    }
  }
}
void mouseDragged(){
  if(selectedVertex != null){
    selectedVertex.x += mouseX - pmouseX; //move by difference of previous mouse and current mouse
    selectedVertex.y += mouseY - pmouseY; //move by difference of previous mouse and current mouse
  }
}
void mouseReleased(){
  if(selectedVertex != null){
    selectedVertex = null;
  }
}
void keyPressed(){
 if(keyCode == ' '){
    
 }
}