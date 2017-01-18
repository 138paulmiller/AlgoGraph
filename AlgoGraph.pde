UndirectedGraph g = new UndirectedGraph();
Vertex selectedVertex = null;
void setup(){
  size(1080, 720);
  Vertex a = new Vertex(105,85,"A");
  Vertex b= new Vertex(45,350,"B");
  Vertex c = new Vertex(150,200,"C");
  Vertex d = new Vertex(700,534,"D");
  Vertex e = new Vertex(100,60,"E");
  Vertex f = new Vertex(500,54,"F");
  g.addEdge(a,b, 3.9);
  g.addEdge(d,b, 0.5);
  g.addEdge(a,c, 2.0);
  g.addEdge(a,d, 3.2);  
  g.addEdge(c,d, 5.7);
  g.addEdge(e,d, 1.4);
  g.addEdge(e,f, 2.2);

}


void draw(){
 background(0); 
 g.draw();
}
void mousePressed(){
  for(Vertex v : g.getVertexSet()){
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
    g = g.getBFS(); 
 }
}