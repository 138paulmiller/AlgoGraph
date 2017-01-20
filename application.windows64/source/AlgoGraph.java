import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.LinkedList; 
import java.util.Set; 
import java.util.LinkedList; 
import java.util.TreeSet; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AlgoGraph extends PApplet {


float red = 0, green =250,blue = 140;
float buttonWidth =250 , buttonHeight = 32;
String noneLabel ="NONE";
String bfsLabel = "BFS";
Menu menu = new Menu(72,32);
UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null;
public void setup(){
  
  initDefaultGraph();
  menu.addButton("BFS");
  menu.addButton("DFS");

}


public void draw(){
 background(0); 
 undirgraph.draw();
 menu.draw();
}
public void mouseClicked(){
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
public Vertex getIntersectingVertex(float x, float y){
  for(Vertex v : undirgraph.getVertexSet()){
      if(v.getButton().intersects(x,y)){
         return v; //return vertex 
      }
  }
  return null;
}
public void mousePressed(){
  if(mouseButton == LEFT){
    Vertex v = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
    if(v != null)
        selectedVertex = v;

  }
}
public void mouseDragged(){
  if(mouseButton == LEFT && selectedVertex != null){
    selectedVertex.getButton().setX(selectedVertex.getButton().getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    selectedVertex.getButton().setY(selectedVertex.getButton().getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
  }
}
public void mouseReleased(){
  if(mouseButton == LEFT ){
  }
}
public void keyPressed(){
 if(keyCode == ' '){ //clear
   initDefaultGraph();
 }
}
public void initDefaultGraph(){
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
public UndirectedGraph getBFS(UndirectedGraph graph, Vertex a){
    UndirectedGraph bfs = new UndirectedGraph();
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    Set<HashMap.Entry<Vertex,TreeSet<Edge>>> entrySet =graph.entrySet();
    for(HashMap.Entry<Vertex,TreeSet<Edge>> entry : entrySet)
      visitedMap.put(entry.getKey(), false);
    LinkedList<Vertex> q = new LinkedList<Vertex>();
    q.add(a); //visit a
    visitedMap.put(a, true);
    while(!q.isEmpty()){
      Vertex c = q.getLast();
      q.removeLast();
      for(Edge e: graph.getAdjacentEdges(c)){ //for each adjacent edge
       if(!visitedMap.get(e.getDest())){ //if dest is not visited
         visitedMap.put(e.getDest(), true); //mark vertex as visited
         q.addFirst(e.getDest());  //add to traversal queue
         bfs.addEdge(e.getSource(),e.getDest(),e.weight);   
        }
      }
    }
    return bfs;
  }
class Button{
  public Button(float x,float y, float w, float h,String text, int textSize){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.textSize = textSize;
    highlight = false;
    r = 0;
    g= 200; 
    b = 200;
  }
  public Button(Button other){
    this.x = other.x;
    this.y = other.y;
    this.w = other.w;
    this.h = other.h;
    this.text = other.text;
    this.r = other.r;
    this.b = other.b;
    this.g = other.g;
    this.highlight = other.highlight;

  }
  public boolean isHighlighted(){
    return highlight;
  }
    
  public void setHighlight(boolean isHighlighted){
    highlight= isHighlighted;
  }
  public void setRGB(float r,float g,float b){
     this.r = r;
     this.g = g;
     this.b = b;
  }
  public void draw(){
    pushMatrix();
    
    //render pos in eucledian space
    stroke(0,0,0);  //pen stroke color black to outline button
    if(highlight){
      fill(g,b,g);     //file  rect with swapped color to highlight
    }else{
      fill(r,g,b);
    }//file  rect with same color
    //offset to center
    rect(x,y,w,h);
    
    //render label on top
    textSize(textSize);
    fill(2, 2,0); //nearly black text 
    text(text, x+w*0.20f,y+h*0.80f);
    popMatrix();

  }
  public boolean intersects(float x, float y){
//Let P(x,y), and rectangle A(x1,y1),B(x2,y2),C(x3,y3),D(x4,y4)
//Calculate the sum of areas of \u25b3APD,\u25b3DPC,\u25b3CPB,\u25b3PBA\u25b3APD,\u25b3DPC,\u25b3CPB,\u25b3PBA.
  if(x < this.x || y < this.y){
    return false; 
  }else if(x > this.x+w || y > this.y+h){
    return false; 
  }
  return true;
 }
 public String getText(){
   return text;
 }
 public float getTextSize(){
   return textSize;
 }
 public float getX(){
   return x;
 }
 public float getY(){
   return y;
 }
 public float getW(){
   return w;
 }
 public float getH(){
   return h;
 }
 public void setX(float x ){
   this.x = x;
 }
 public void setY(float y){
   this.y = y;
 }
 public void setW(float w){
   this.w = w;
 }
 public void setH(float h){
   this.h = h;
 }
  float x,y,w,h,r,g,b;
  String text;
  float textSize;
  boolean highlight;
}

class Edge implements Comparable<Edge>{
  public Edge( ){
   this.source = null;
   this.dest = null;
    this.weight = 0;
  }
  public Edge(Vertex source, Vertex dest, int weight){
   this.source = source;
   this.dest = dest;
    this.weight = weight;
  }
  public Edge(Edge other){
   this.source = other.source;
   this.dest = other.dest;
    this.weight = other.weight;
  }
  public int compareTo(Edge e){
    return weight - e.weight;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Edge) && (this.source == ((Edge)o).source && 
                                    this.dest == ((Edge)o).dest && 
                                     this.weight == ((Edge)o).weight);
  }
  public Vertex getSource() {
      return source;
  }
  public Vertex getDest() {
      return dest;
  }
  public boolean hasVertices() {return (this.source != null && this.dest != null);}
  public void draw(){
    if(hasVertices()){
      pushMatrix();
      stroke(140, 50,0);  //color rgb
      strokeWeight(3);
      line(source.getButton().getX(),source.getButton().getY(),dest.getButton().getX(),dest.getButton().getY());
      textSize(source.getButton().getTextSize());
      fill(60,245, 0);     //file  rect with same color

      text(String.valueOf(weight), (source.getButton().getX()+dest.getButton().getX())/2.0f,( source.getButton().getY()+ dest.getButton().getY())/2.0f);
      popMatrix();
    }
  }
  Vertex source,dest;
  int weight;
}

class Menu{
  public Menu(float w, float h){
    buttons = new LinkedList<Button>();
     this.x=  0;
     this.y = 0;
     this.w = w;
     this.h = h;
     hide();
  }
  public void hide(){
     visible = false;
  }
  public void open(){
     visible = true;
  }
  public boolean isOpen(){
    return visible;
  }
  public void setPosition(float x,float y){
    this.x = x;
    this.y = y;
    int i = 0;
    for(Button b : buttons){ //update button position
       b.setX(x);
       b.setY(y+(h*i++));
     }
  }
  public void addButton(String label){
    int count = buttons.size();
    buttons.addLast(new Button(x,y+(h*count),w,h, label, 18));
    buttons.getLast().setRGB(red,green,blue);
  }
  public Button getIntersectingButton(float x, float y){
    for(Button b : buttons){
      if(b.intersects(x,y)){
         return b; //return vertex 
      }
    }
  return null;
  }
  public void draw(){
    if(isOpen()){
      for(Button b : buttons){
         b.draw();
       }
    }
    
  }
  float x,y, w,h;
  LinkedList<Button> buttons;
  boolean visible;
}



class UndirectedGraph{
  public UndirectedGraph(){
    edgeMap = new HashMap<Vertex,TreeSet<Edge>> ();
  }
  public void addVertex(Vertex a){
     if(!edgeMap.containsKey(a)){
       edgeMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addEdge(Vertex source,Vertex dest, int weight){
   Edge e = new Edge(source,dest,weight);
   Edge eComp = new Edge(dest, source,weight);
   addVertex(source);      
    addVertex(dest);//tries to add if not in
    if(!edgeMap.get(source).contains(e) && !edgeMap.get(dest).contains(e)){
      edgeMap.get(source).add(e);
      edgeMap.get(dest).add(eComp);

    }
  }
  
  public void draw(){
     
    for(HashMap.Entry<Vertex,TreeSet<Edge>> entry : edgeMap.entrySet()){
      TreeSet<Edge> adjacentEdges  = entry.getValue();
     for(Edge e : adjacentEdges){
       e.draw();
     }
    }
    for(Vertex v: getVertexSet())
      v.draw();
  }
  public Set<Vertex> getVertexSet(){
   return edgeMap.keySet(); 
  }
  public Set<HashMap.Entry<Vertex,TreeSet<Edge>>> entrySet(){
    return edgeMap.entrySet();
  }
  public TreeSet<Edge> getAdjacentEdges(Vertex v){
     TreeSet<Edge> set = edgeMap.get(v); 
     return set;
  }
  public void clear(){
     edgeMap.clear(); 
  }
  HashMap<Vertex,TreeSet<Edge>> edgeMap;
}
class Vertex implements Comparable<Vertex>{
  public Vertex(){
    this.button = new Button(0,0,0,0,"\0",0);
    this.id="\0";

  }
  public Vertex(float x, float y, String label){
    this.button = new Button(x,y,32,32,label,30);
    this.id = label;
  }
  public Vertex (Vertex other){
    this.button = new Button(other.button);
    this.id = other.id;

  }
  public String getID(){
    return id;
  }
  
  public int compareTo(Vertex v){
     return id.compareTo(v.getID());
  }
 
  @Override public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.getButton().getX() == ((Vertex)o).getButton().getX() && 
                                       this.getButton().getY() == ((Vertex)o).getButton().getY() && 
                                       this.id == ((Vertex)o).getID());
  }
  
  public Button getButton(){
    return button;
  }
  public void draw(){
    button.draw();
  }
  public Button button;
  String id;


}
  public void settings() {  size(1080, 720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AlgoGraph" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
