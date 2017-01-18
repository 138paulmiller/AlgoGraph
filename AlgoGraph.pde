UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null;
void setup(){
  size(1080, 720);
  Vertex a = new Vertex(105,85,'A');
  Vertex b= new Vertex(45,350,'B');
  Vertex c = new Vertex(150,200,'C');
  Vertex d = new Vertex(700,534,'D');
  Vertex e = new Vertex(100,60,'E');
  Vertex f = new Vertex(540,94,'F');
  Vertex g = new Vertex(570,57,'G');
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


void draw(){
 background(0); 
 undirgraph.draw();
}
void mouseClicked(){
  for(Vertex v : undirgraph.getVertexSet()){
    if(v.intersects(mouseX, mouseY)){
      UndirectedGraph bfs = getBFS(undirgraph,v);
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