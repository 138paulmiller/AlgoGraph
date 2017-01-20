import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.HashMap; 
import java.util.HashMap; 
import java.util.LinkedList; 
import java.util.Set; 
import java.util.LinkedList; 
import java.util.TreeSet; 
import java.util.Collections; 

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
Menu vertexMenu = new Menu(72,32);
UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null;
public void setup(){
  
  initDefaultGraph();
  vertexMenu.addButton("BFS", new ButtonInterface(){
                                    public void onClick(){
                                      UndirectedGraph bfs = getBFS(undirgraph,selectedVertex);
                                      if(bfs != null){
                                        undirgraph = bfs;
                                      }
                                    }
                              });
  vertexMenu.addButton("DFS", new ButtonInterface(){
                                    public void onClick(){
                                      UndirectedGraph dfs = getDFS(undirgraph,selectedVertex);
                                      if(dfs != null){
                                        undirgraph = dfs;
                                      }
                                    }
                              });

}

public void draw(){
 background(0); 
 undirgraph.draw();
 vertexMenu.draw();
}
public void mouseClicked(){
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
        print("Clicked Button: "+  b.getLabel().getText());
        b.click();
        selectedVertex = null; //deselect vertex
    }
   vertexMenu.hide();//hide vertexMenu  
  }//if left
}
public Vertex getIntersectingVertex(float x, float y){
  for(Vertex v : undirgraph.getVertexSet()){
      if(v.getLabel().intersects(x,y)){
         return v; //return vertex 
      }
  }
  return null;
}
public void mousePressed(){
  Button b = vertexMenu.getIntersectingButton(mouseX,mouseY);
  if(mouseButton == LEFT && b == null ){
      vertexMenu.hide();
    selectedVertex = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
  }
}
public void mouseDragged(){
  if(mouseButton == LEFT && selectedVertex != null){
    selectedVertex.getLabel().setX(selectedVertex.getLabel().getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    selectedVertex.getLabel().setY(selectedVertex.getLabel().getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
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
    print(PApplet.parseChar(v.getID()) + "\n");
}

public UndirectedGraph getBFS(UndirectedGraph graph, Vertex a){
    UndirectedGraph bfs = new UndirectedGraph();
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    for(Vertex v : graph.getVertexSet())
      visitedMap.put(v, false);
    LinkedList<Vertex> q = new LinkedList<Vertex>(); //bfs
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
interface ButtonInterface{
    public void onClick();
  }
class Button{
  
  public Button(int x,int y, int w, int h,String text, int textSize){
    this.label = new Label( x,y, w, h, 0, 200,200, text,  textSize);
    actionInterface = null;
  }
  public Button(Button other){
    this.label = other.label;
    this.actionInterface = other.actionInterface;
  }
  public void setInterface(ButtonInterface actionInterface){
   this.actionInterface = actionInterface; 
  }
  public void draw(){
    label.draw();

  }
 public Label getLabel(){
   return label;
 }
 public void click(){
   if(actionInterface !=  null)
     actionInterface.onClick();
 }
 ButtonInterface actionInterface;
  Label label;
}

public UndirectedGraph getDFS(UndirectedGraph graph, Vertex a){
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    for(Vertex v : graph.getVertexSet())
      visitedMap.put(v, false);
    visitedMap.put(a, true); //mark vertex as visited
    return getSubGraphDFS(a, graph, visitedMap);
  }
  
  public UndirectedGraph getSubGraphDFS(Vertex root, UndirectedGraph graph, HashMap<Vertex, Boolean> visitedMap){
        UndirectedGraph bfs = new UndirectedGraph();

    for(Edge e: graph.getAdjacentEdges(root)){ //for each adjacent edge
       if(!visitedMap.get(e.getDest())){ //if dest is not visited
         visitedMap.put(e.getDest(), true); //mark vertex as visited
         bfs.addGraph(getSubGraphDFS(e.getDest(),graph, visitedMap)) ;  //add to traversal queue
         bfs.addEdge(e.getSource(),e.getDest(),e.weight);   
        }
      }
    return bfs;
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
    int val =  weight - e.weight;
    if( val == 0) //order by vertex if equal
      val = dest.compareTo(e.getDest());    
    return val;
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
      line(source.getLabel().getX(),source.getLabel().getY(),dest.getLabel().getX(),dest.getLabel().getY());
      textSize(source.getLabel().getTextSize());
      fill(60,245, 0);     //file  rect with same color

      text(String.valueOf(weight), (source.getLabel().getX()+dest.getLabel().getX())/2.0f,( source.getLabel().getY()+ dest.getLabel().getY())/2.0f);
      popMatrix();
    }
  }
  Vertex source,dest;
  int weight;
}
class Label{
  public Label(int x,int y, int w, int h, int r, int g, int b,  String text, int textSize){
    this.x= x;
    this.y= y;
    this.w= w;
    this.h= h;
    this.r= r;
    this.g= g;
    this.b= b;
    this.text =  text;
  this.textSize = textSize;
  highlight = false;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.getX() == ((Label)o).getX() && 
                                       this.text == ((Label)o).getText());
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
   public boolean isHighlighted(){
    return highlight;
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
  float x,y,w,h,r,g,b;
  String text;
  float textSize;
  boolean highlight;
}

class Menu{
  public Menu(int w, int h){
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
  public void setPosition(int x,int y){
    this.x = x;
    this.y = y;
    int i = 0;
    for(Button b : buttons){ //update button position
       b.getLabel().setX(x);
       b.getLabel().setY(y+(h*i++));
     }
  }
  public void addButton(String label, ButtonInterface buttonInterface){
    
    int count = buttons.size();
    Button b = new Button(x,y+(h*count),w,h, label, 18);
    b.setInterface(buttonInterface);
    buttons.addLast(b);
    buttons.getLast().getLabel().setRGB(red,green,blue);
  }
  public Button getIntersectingButton(float x, float y){
    for(Button b : buttons){
      if(b.getLabel().intersects(x,y)){
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
  int x,y, w,h;
  LinkedList<Button> buttons;
  boolean visible;
}





class UndirectedGraph{
  public UndirectedGraph(){
    edgeMap = new HashMap<Vertex,TreeSet<Edge>> ();
  }
  public UndirectedGraph(UndirectedGraph other){
    edgeMap = other.edgeMap;
  }
  public void addVertex(Vertex a){
     if(!edgeMap.containsKey(a)){
       edgeMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addGraph(UndirectedGraph graph){
    edgeMap.putAll(graph.edgeMap);
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
     for(Edge e :  entry.getValue()){
       e.draw();
     }
    }
    for(Vertex v: getVertexSet())
      v.draw();
  }
  public ArrayList<Vertex> getVertexSet(){
    ArrayList<Vertex> sortList=  new ArrayList(edgeMap.keySet());
    Collections.sort(sortList);
    return sortList;
  }
  
  public ArrayList<Edge> getAdjacentEdges(Vertex v){
     ArrayList<Edge> sortList = new ArrayList<Edge>(edgeMap.get(v)); 
     Collections.sort(sortList);
     return sortList;
  }
  public void clear(){
     edgeMap.clear(); 
  }
  HashMap<Vertex,TreeSet<Edge>> edgeMap;
}
class Vertex implements Comparable<Vertex>{
  public Vertex(){
   this.label = null;

  }
  public Vertex(int x, int y, char id){
    this.id = id;
    this.label = new Label(x,y,32,32,  0, 230,230, String.valueOf(this.id), 30);
  }
  public Vertex(int x, int y, int id){
       this.id = PApplet.parseChar(id);
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
  public void draw(){
    if(label != null)
      label.draw();
  }
  Label label;
  char id;


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
