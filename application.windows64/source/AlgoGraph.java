import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.HashMap; 
import java.util.HashMap; 
import java.util.LinkedList; 
import java.util.HashMap; 
import java.util.Set; 
import java.util.Iterator; 
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
Vertex vertexSource, vertexDest;
boolean vertexAdd, edgeSelection;
Menu vertexMenu = new Menu(72,32);
Menu graphMenu = new Menu(150,32);
String edgeValueBuilder =null;
UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null, draggingVertex = null;
public void setup(){
  
  initDefaultGraph();
  vertexMenu.addButton("BFS", new ActionInterface(){
                                    public void onClick(){
                                      undirgraph = getBFS(undirgraph,selectedVertex);
                                      
                                    }
                              });
  vertexMenu.addButton("DFS", new ActionInterface(){
                                    public void onClick(){
                                      undirgraph = getDFS(undirgraph,selectedVertex);
                                    }
                              });
  graphMenu.addButton("ADD VERTEX", new ActionInterface(){
                            public void onClick(){
                              deselectAll();
                              vertexAdd = true;
                              print("To add vertex anywhere");
                            }
                      });
  graphMenu.addButton("ADD EDGE", new ActionInterface(){
                                    public void onClick(){
                                      deselectAll();
                                      edgeSelection = true;
                                      print("To add edge, click on 2 Vertices");
                                    }
                              });

}

public void draw(){
 background(0); 
 undirgraph.draw();
 vertexMenu.draw();
 graphMenu.draw();
}
public void mouseClicked(){
  Vertex v = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
  Button vertexB = null, graphB = null;
  Edge e = null;
   if(v == null) vertexB = vertexMenu.getIntersectingButton(mouseX, mouseY);//get vertex button clicked
   if(vertexB == null)graphB = graphMenu.getIntersectingButton(mouseX, mouseY);//get graph button clicked
   if(graphB == null)e = getIntersectingEdge(mouseX, mouseY);
         
  //if vertex right clicked
  if(mouseButton == RIGHT){ //right click vertex to show vertexMenu
    deselectAll();//default deselect o n riight click
    //hide all menus by default
    graphMenu.hide();//hide other menus  
    vertexMenu.hide();
    if(v != null){
        vertexMenu.setPosition(mouseX, mouseY);
        vertexMenu.open();
        graphMenu.hide();//hide other menus  
        selectedVertex = v;
      }else if(e != null){//edge clicked   
       edgeValueBuilder = new String();
       print("\nSelected Edge : " + e.getLabel().getText());
       graphMenu.hide();//hide menus  
       vertexMenu.hide();//hide menus
     }
      else if(graphB == null){ //right click empty space
        graphMenu.setPosition(mouseX, mouseY);
        graphMenu.open();//open graph menu
         vertexMenu.hide();//hide other menus  
      }

  }
  //if button left clicked
  else if(mouseButton == LEFT){
    graphMenu.unhighlight();//hide other menus  
    vertexMenu.unhighlight();
      if(selectedVertex != null){
        if(vertexB != null){ //if vertexMenu button click action for vertex
          print("\nClicked Vertex Menu Button: "+  vertexB.getText());
          vertexB.click();
          vertexMenu.hide();//hide menus  

        }
      }// end if ther is a selected vertex for vertex menu
      else if(graphB != null){
            print("\nClicked Graph Menu Button: "+  graphB.getText());
            graphB.click();
            graphB.setHighlight(true);
       }//end if graph button was clicked
       else if(v != null){ //if left vertex clicked
          if(edgeSelection){ //if selecting menu vertex
             if( vertexSource == null){
                vertexSource = v;
               print("\nSource: " + v);
               v.setHighlight(true);
              
             }else{//if this is the second vertex clicked
               vertexDest = v;
               print("\nDest: " + v.getText());   
               vertexSource.setHighlight(false);
               undirgraph.addEdge(vertexSource,vertexDest, 1);
               vertexDest = vertexSource = null;
               edgeSelection = false;
               graphMenu.hide();
             }
          }
     }//end if vertex left click
     else if(e != null){ //edge left click
        print("\nClicked edge Value: " + e.getLabel().getText());   
     }
     else{ //sp;ace left click
      print("\nPos Clicked " + mouseX + " , " + mouseY);
       graphMenu.hide();//hide menus  
       vertexMenu.hide();//hide menus  

       if(vertexAdd){ //if adding action, add verte
          print("\nAdding:" + mouseX + " , " + mouseY);

          undirgraph.addVertex(new Vertex(mouseX, mouseY, PApplet.parseChar('A'+ undirgraph.getVertexSet().size())));// add vertex of id one beyond size
          vertexAdd = false;
       
       }
       deselectAll();       
     }

    }//if left
}
public Vertex getIntersectingVertex(float x, float y){
  for(Vertex v : undirgraph.getVertexSet()){
      if(v.intersects(x,y)){
         return v; //return vertex 
      }
  }
  return null;
}
public Edge getIntersectingEdge(float x, float y){
  for(Edge e : undirgraph.getEdgeSet()){
      if(e.getLabel().intersects(x,y)){
         return e; //return vertex 
      }
  }
  return null;
}
public void deselectAll(){
 selectedVertex = null; //deselect verteices
  vertexDest = vertexSource = null;
  vertexAdd = false;
  edgeSelection = false; 
  

}
public void mousePressed(){
  Button b = vertexMenu.getIntersectingButton(mouseX,mouseY);
  Button b2 = graphMenu.getIntersectingButton(mouseX,mouseY);
  if(mouseButton == LEFT && b == null && b2 == null){
    vertexMenu.hide();
      draggingVertex = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
  }else{
    draggingVertex = null;
  }
}
public void mouseDragged(){
  if(mouseButton == LEFT && draggingVertex != null){
    draggingVertex.setX(draggingVertex.getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    draggingVertex.setY(draggingVertex.getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
  }
}
public void mouseReleased(){
  if(mouseButton == LEFT ){
    draggingVertex = null;
  }
}
public void keyPressed(){
    if(keyCode >= '0' && keyCode <= '9' && edgeValueBuilder.length() <= 3) { //set value to current string edge builder value
     edgeValueBuilder += PApplet.parseChar(keyCode);
     print("\nEdgeValueBuilder: "+ edgeValueBuilder);
  }
 else if(keyCode == ' '){ //clear
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
  undirgraph.addEdge(a,b, 1);
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
  undirgraph.updateEdgeWeight(a,b,10); 

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
         bfs.addEdge(e.getSource(),e.getDest(),e.getWeight());   
        }
      }
    }
    if(bfs.getVertexSet().size() == graph.getVertexSet().size())
      return bfs;
    return graph; //failed to generate graph
  }

class Button extends Label{
  
  public Button(int x,int y, int w, int h,String text, int textSize){
    super( x,y, w, h,  text,  textSize);
    setTextRGB( 10, 20,0);

  }
  public Button(Button other){
    super(other);
  }
}

public UndirectedGraph getDFS(UndirectedGraph graph, Vertex a){
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    for(Vertex v : graph.getVertexSet())
      visitedMap.put(v, false);
    visitedMap.put(a, true); //mark vertex as visited
    UndirectedGraph dfs= getSubGraphDFS(a, graph, visitedMap);
    if(dfs != null && dfs.getVertexSet().size() == graph.getVertexSet().size())
      return dfs;
    return graph; //failed to generate graph
  }
  
  public UndirectedGraph getSubGraphDFS(Vertex root, UndirectedGraph graph, HashMap<Vertex, Boolean> visitedMap){
  
    UndirectedGraph bfs = new UndirectedGraph();

    for(Edge e: graph.getAdjacentEdges(root)){ //for each adjacent edge
       if(!visitedMap.get(e.getDest())){ //if dest is not visited
         visitedMap.put(e.getDest(), true); //mark vertex as visited
         bfs.addGraph(getSubGraphDFS(e.getDest(),graph, visitedMap)) ;  //add to traversal queue
         bfs.addEdge(e.getSource(),e.getDest(),e.getWeight());   
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
   label = new Label((int)(source.getX()+dest.getX())/2,//x
                     (int)(source.getY()+ dest.getY())/2, //y
                    64, 32,//w, h/rgb
                    String.valueOf(weight), 30);
   label.setRGB(130,120,0);
   label.setTextRGB(0,190,10);
   label.setFilled(false);      
    
  }
  public Edge(Edge other){
   this.source = other.source;
   this.dest = other.dest;
    this.weight = other.weight;
    this.label = other.label;
  }
  public int compareTo(Edge e){
    int val =  weight - e.weight;
    if( val == 0) //order by vertex dest if equal
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
  public Label getLabel(){
    return label;
  }
  public void setWeight(int weight){
    this.weight = weight;
    this.label.setText(String.valueOf(weight));
  }
  public int getWeight(){
  return weight;
  }
  public boolean hasVertices() {return (this.source != null && this.dest != null);}
  public void draw(){
    if(hasVertices()){
      pushMatrix();
      //draw line from source to dest
      stroke(103,45,0);
      strokeWeight(4);
      line(source.getX(),source.getY(),dest.getX(),dest.getY());
      label.setPosition((int)(source.getX()+dest.getX())/2,//x
                     (int)(source.getY()+ dest.getY())/2);
      label.draw();
      popMatrix();
    }
  }
  Vertex source,dest;
  Label label;
  int weight;
}
interface ActionInterface{
    public void onClick();
  }
public class Label{
  public Label(int x,int y, int w, int h, String text, int textSize){
    this.x= x;
    this.y= y;
    this.w= w;
    this.h= h;
    this.text =  text;
    this.textSize = textSize;
    this.r = this.tr = 255;
    this.g = this.tg = 255;
    this.b = this.tb = 255;
    filled=  true;
    highlight = false;
    actionInterface = null;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.getX() == ((Label)o).getX() && 
                                       this.text == ((Label)o).getText());
  }
  public Label(Label other){
    this.x= other.x;
    this.y= other.y;
    this.w= other.w;
    this.h= other.h;
    this.text =  other.text;
    this.textSize = other.textSize;
    this.highlight = other.highlight;
    this.r = other.r;
    this.tr = other.tr;
    this.g = other.g;
    this.tg = other.tg;
    this.b = other.b;
    this.tb = other.tb;
    this.filled = other.filled;
    this.actionInterface = other.actionInterface;

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
   public void setText(String text){
     if(text != null)
     this.text= text;
   }
   public void setFilled(boolean isFilled){
      filled = isFilled; 
   }
   public void setPosition(int x, int y){
    setX(x); 
    setY(y); 
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
  public void setTextRGB(float tr,float tg,float tb){
     this.tr = tr;
     this.tg = tg;
     this.tb = tb;
  }
   public void setInterface(ActionInterface actionInterface){
   this.actionInterface = actionInterface; 
  }
  public void click(){
  if(actionInterface !=  null)
     actionInterface.onClick();
  }
  public void draw(){
    
     pushMatrix();
    //render pos in eucledian space
    if(filled){
      stroke(0,0,0);  //pen stroke color black to outline button
      if(highlight){
        fill(255,255,0);     //file  rect with yellow to highlight
      }else{
        fill(r,g,b);
      }
    }
    else{
      noStroke();  
      noFill();
    }    
   rect(x,y,w,h);  
       
    //render label on top
    textSize(textSize);
    fill(tr,tg,tb);
    text(text, x+w*0.20f,y+h*0.80f);
    popMatrix();
  }
  float x,y,w,h,r,g,b, t,tr,tb,tg;
  String text;
  float textSize;
  boolean highlight, filled;
  ActionInterface actionInterface;

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
    unhighlight();
  }
  public void unhighlight(){
     for(Button b : buttons)
         b.setHighlight(false);
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
       b.setX(x);
       b.setY(y+(h*i++));
     }
  }
  public void addButton(String label, ActionInterface actionInterface){
    
    int count = buttons.size();
    Button b = new Button(x,y+(h*count),w,h, label, 18);
    b.setInterface(actionInterface);
    buttons.addLast(b);
    buttons.getLast().setRGB(red,green,blue);
  }
  public Button getIntersectingButton(float x, float y){
    if(isOpen()){
      for(Button b : buttons){
        if(b.intersects(x,y)){
           return b; //return vertex 
        }
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

class UIManager{
  UIManager(){
  menus = new HashMap <String, Menu>();
  labels = new HashMap <String, Label>();
}
 HashMap <String, Menu> menus;
 HashMap <String, Label> labels;
 String selectedMenu, selectedLabel;
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
  public Edge getEdge(Vertex source, Vertex dest){
    TreeSet<Edge> edgeSet = edgeMap.get(source);
    boolean found = false;
    Edge e  = null;
    Iterator it = edgeSet.iterator();
    while(it.hasNext() && !found){
      e= (Edge)it.next();
      if(e.getSource() == source && e.getDest() == dest){
        found  =true;
      } 
    }
    if(found)
    return e;
    else  
    return null;
  }
  public void updateEdgeWeight(Vertex source, Vertex dest, int weight){
    TreeSet<Edge>sourceEdgeSet = edgeMap.get(source);
    TreeSet<Edge>destEdgeSet = edgeMap.get(dest);

    boolean found = false;
    Edge e = null;
    Iterator it = sourceEdgeSet.iterator();
    while(it.hasNext() && !found){
      e= (Edge)it.next();
      if(e.getDest() == dest){
          e.setWeight(weight);
          found = true;
      }
    }
    found = false;
    //update destinations edges
    it = destEdgeSet.iterator();
    while(it.hasNext() && !found){
      e= (Edge)it.next();
      if(e.getDest() == source){
          e.setWeight(weight);
          found = true;
      }
    }
  }
  public ArrayList<Edge> getAdjacentEdges(Vertex v){
     ArrayList<Edge> sortList = new ArrayList<Edge>(edgeMap.get(v)); 
     Collections.sort(sortList);
     return sortList;
  }
  public ArrayList<Edge> getEdgeSet(){
    ArrayList<Edge> sortList = new ArrayList<Edge>();
    for(Vertex v : getVertexSet())
     sortList.addAll(edgeMap.get(v)); 
   Collections.sort(sortList);
   return sortList;
  }
  public void clear(){
     edgeMap.clear(); 
  }
  HashMap<Vertex,TreeSet<Edge>> edgeMap;
}
class Vertex extends Label implements Comparable<Vertex>  {
  public Vertex(){
    super(0,0,0,0,"",0);
  }
  public Vertex (Vertex other){
   super(other);
    this.id = other.id;

  }
  public Vertex(int x, int y, char id){
    super(x,y,32,32, String.valueOf(id), 30);
    this.id = id;
    setTextRGB( 10, 20,0);
     setRGB( 0, 230,230);
  }
  public Vertex(int x, int y, int id){
    super(x,y,32,32, String.valueOf(id), 30);
    this.id = PApplet.parseChar(id);
    setTextRGB( 10, 20,0);
    setRGB( 0, 230,230);


   
  }
  
  public int getID(){
    return id;
  }
  
  public int compareTo(Vertex v){
     return id - v.getID();
  }
 
  public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.id == ((Vertex)o).getID());
  }
 
 
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
