import java.util.HashMap;
float red = 0, green =23,blue = 230;
String noneLabel ="NONE";
String bfsLabel = "BFS";
String selectedButton = noneLabel;

HashMap<String,Button> buttons = new HashMap<String,Button>();
UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null;
void setup(){
  size(1080, 720);
  Vertex a = new Vertex(105,85,"A");
  Vertex b= new Vertex(45,350,"B");
  Vertex c = new Vertex(150,200,"C");
  Vertex d = new Vertex(700,534,"D");
  Vertex e = new Vertex(100,60,"E");
  Vertex f = new Vertex(540,94,"F");
  Vertex g = new Vertex(570,57,"G");
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
  buttons.put(bfsLabel,new Button(0,0,72, 32, bfsLabel));
  buttons.get(bfsLabel).setRGB(red,green,blue);
}


void draw(){
 background(0); 
 undirgraph.draw();
 for(Button b : buttons.values()){
     b.draw();
  }
}
void mouseClicked(){
  //if action perfom action
  boolean intersection = false;
  if(selectedButton != noneLabel){
    for(Vertex v : undirgraph.getVertexSet()){
      intersection =true;
      if(v.getButton().intersects(mouseX, mouseY)){
        if(selectedButton == bfsLabel){
          UndirectedGraph bfs = getBFS(undirgraph,v);
          if(bfs != null){
            undirgraph = bfs;
          }        
        } 
        break; //break from loop
      }
    }
    //if not action, de select
    if(buttons.containsKey(selectedButton)){
    buttons.get(selectedButton).setHighlight(false); //default unselect curretn button
    selectedButton = noneLabel;  
    }
  }
  
  if(!intersection){//if not vertex action, check for button click
    for(Button b : buttons.values()){
       if(b.intersects(mouseX, mouseY)){
        selectedButton = b.getText();
         print("Clicked Button: " + selectedButton);
         //to highlight swap rgb order
         if(buttons.containsKey(selectedButton))
            buttons.get(selectedButton).setHighlight(true);
       }
    }
  }
  
}
void mousePressed(){
  for(Vertex v : undirgraph.getVertexSet()){
    if(v.getButton().intersects(mouseX, mouseY)){
      selectedVertex = v;
    }
  }
}
void mouseDragged(){
  if(selectedVertex != null){
    selectedVertex.getButton().setX(selectedVertex.getButton().getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    selectedVertex.getButton().setY(selectedVertex.getButton().getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
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