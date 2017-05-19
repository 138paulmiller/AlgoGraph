import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.HashMap; 
import java.util.HashMap; 
import java.util.Set; 
import java.util.Iterator; 
import java.util.LinkedList; 
import java.util.TreeSet; 
import java.util.Collections; 
import java.util.LinkedList; 
import java.util.HashMap; 

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
String currentAction = "", currentSubGraph = "";
Vertex selectedVertex, otherSelectedVertex;
boolean vertexAdd, edgeSelection;
UIManager ui = new UIManager(); //ui manager contains a map to multiple different graphs that can be dynamically requested
String edgeValueBuilder ="";
Graph undirgraph = new Graph();
Vertex  draggingVertex = null;

public void setup(){
  
  initDefaultGraph();
  initUI();
}

public void addGraph(String id, Graph graph, boolean highlight){
  if(graph != null){
    print("Adding Graph : " + id + "\n");
    initInterface(graph);
    graph.setHighlightEdges(highlight); 
 }  
   ui.setGraph(id,graph);

}

public void onRightClick(int x, int  y){ //right click nothing 
    print("\nRight Clicked");
    ui.hideAllMenus();
    updateSelectedVertex(null);//unselect vertices
    otherSelectedVertex = null;
    edgeValueBuilder = "";
    currentAction = "";
    Menu m = ui.getMenu("graph");
    m.setPosition(x,y);
    m.open();
    
}
public void onLeftClick(int x, int  y){ //right click nothing
    print("\nLeft Clicked");
    if(currentAction == ""){ //if no current action hide menus
      ui.hideAllMenus();
      updateSelectedVertex(null);
      otherSelectedVertex = null;
      edgeValueBuilder = "";
      currentAction = "";
      
    }else if(currentAction == "addvertex"){
      Graph g =  ui.getGraph("UNDIR");
     if(g != null){
       Vertex v = new Vertex(x,y, PApplet.parseChar('A'+g.getVertexCount()+1));
       g.addVertex(v);
       ui.hideAllMenus();
       currentAction = "";
     }
    }
} 
public void updateSelectedVertex(Vertex v){
  if(selectedVertex != null) 
  selectedVertex.setHighlight(false); //un\highlight prev vertex sel
  selectedVertex = v;
  if(selectedVertex != null)
    selectedVertex.setHighlight(true);
}
public void draw(){
   background(0); 
 //undirgraph.draw();
   Graph g =  ui.getGraph("UNDIR");
  
  if(g != null)
  {
    if(edgeValueBuilder != ""){ //if adding value to edge, update
    //create expanding highlight box around current edge being update when building
      g.getEdge(selectedVertex , otherSelectedVertex).setWeight(Integer.parseInt(edgeValueBuilder));    
      g.getEdge(otherSelectedVertex, selectedVertex).setWeight(Integer.parseInt(edgeValueBuilder));    
      Label box = new Label((int)(selectedVertex.getX()+otherSelectedVertex.getX())/2,
                (int)(selectedVertex.getY()+otherSelectedVertex.getY())/2,
                (int)(selectedVertex.getW()+selectedVertex.getW()*edgeValueBuilder.length()/3), 
                (int)selectedVertex.getH(),  "",  1);
      box.setRGB(140, 226, 0);
      box.draw(); //box around edge
     }
     g.drawEdges(); //draw edges first

  }
  g = ui.getGraph(currentSubGraph);
  
  if(g != null)g.drawEdges();  //draw highlighted edges for graph of current action
  
  g = ui.getGraph("UNDIR");
  if(g != null)g.drawVertices(); //draw draw vertices of all edges
  
    ui.drawMenus();
  
}
public void mouseClicked(){
    Label l = ui.getIntersectingLabel(mouseX, mouseY);//get vertex clicked
    if(mouseButton == RIGHT){
      if(l != null){
        l.rightClick(mouseX, mouseY);
      }else{
       onRightClick(mouseX, mouseY); 
      }
    }
    else if(mouseButton == LEFT){
      if(l != null){
        l.leftClick(mouseX, mouseY);
      }else{
       onLeftClick(mouseX, mouseY); 
      }
    }
   
}
public void mouseDragged(){
  if(mouseButton == LEFT && draggingVertex != null){
    draggingVertex.setX(draggingVertex.getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    draggingVertex.setY(draggingVertex.getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
  }
}
public void mousePressed(){
  Label label = ui.getIntersectingLabel(mouseX, mouseY);
  if(mouseButton == LEFT){
    if(label instanceof Vertex){
      ui.hideMenu("vertex");
      draggingVertex = (Vertex)label;//get vertex clicked
    }
  }else{
    draggingVertex = null;
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
  }else if(keyCode == '\n'){ //terminate edgevalue
    edgeValueBuilder = "";
    updateSelectedVertex(null);
    otherSelectedVertex = null;
    currentSubGraph = "";
    
  }else if(keyCode == 8){ //backspace
    if(edgeValueBuilder.length() > 0)
      edgeValueBuilder= edgeValueBuilder.substring(0, edgeValueBuilder.length()-1); //remove last add value
      if(edgeValueBuilder.length() == 0)
        edgeValueBuilder = "0";
  }
   print("\nKEY:" + keyCode);

}
public void initInterface(Graph g){
  //Bring the callback from label clicks to here
   g.setLabelInterface( new LabelInterface(){
          public void onLeftClick(Label l, int x, int  y){
            print("\nCurrentAction: " + currentAction);
            if(l instanceof Vertex){
                print("\nLeft Clicked Vertex: " + l.getText());
                if(currentAction == ""){ //if no action
                  ui.hideAllMenus();
                  updateSelectedVertex((Vertex)l); //update as normal
                }else if(currentAction == "path"){ //left clicked vertex is selected as root
                  if(selectedVertex != null){
                    addGraph(currentAction,getShortestPath(undirgraph, selectedVertex,(Vertex)l),  true);                    
                    updateSelectedVertex(null);
                    currentAction = "";
                    currentSubGraph = "path";
                  }
                }else if(currentAction == "addedge"){
                  Graph g =  ui.getGraph("UNDIR");
                 if(g != null){
                   edgeValueBuilder = "0";
                   otherSelectedVertex = (Vertex)l;
                   g.addEdge(selectedVertex, otherSelectedVertex, 0);
                   currentAction = "";
                  }
                }
            }else if(l instanceof Button){
                  print("\nLeft Clicked Button: " + l.getText());
            }else if(l instanceof Edge){
                  print("\nLeft Clicked Edge: " + l.getText());
            }else{
                  print("\nLeft Clicked Label: " + l.getText());    
            }
          }
        public void onRightClick(Label l,int x, int  y){
          ui.hideAllMenus();
            if(l instanceof Vertex){
                updateSelectedVertex((Vertex)l);
                print("\nRight Clicked Vertex: " + l.getText());
                Menu m = ui.getMenu("vertex");
                m.setPosition(x,y);
                m.open();
            }else if(l instanceof Button){
                print("\nRight Clicked Button: " + l.getText());
            }else if(l instanceof Edge){
                print("\nRight Clicked Edge: " + l.getText());
            }else{
                print("\nRight Clicked Label: " + l.getText()); 
            }
          }
    });
 
}
public void initUI(){
  ui.addMenu("vertex",150,34);
  ui.addMenu("graph",150,34);
  ui.addMenuButton("vertex", "BFS", new LabelInterface(){
                                          public void onLeftClick(Label l, int x, int  y){
                                            print("\nLeft Clicked : " +  l.getText());
                                            l.setHighlight(true);
                                            if(selectedVertex != null){
                                              addGraph("bfs",getBFS(undirgraph, selectedVertex), true); 
                                              currentSubGraph = "bfs";
                                              updateSelectedVertex(null);
                                            } 
                                            ui.hideAllMenus();
                                          }
                                          public void onRightClick(Label l,int x, int  y){
                                            print("\nRight Clicked : " +  l.getText());
                                          }
                                    });
  ui.addMenuButton("vertex","DFS", new LabelInterface(){
                                  public void onLeftClick(Label l, int x, int  y){
                                    print("\nLeft Clicked : " +  l.getText());
                                    l.setHighlight(true);
                                    if(selectedVertex != null){
                                      currentSubGraph = "dfs";
                                      addGraph("dfs",getDFS(undirgraph, selectedVertex), true);
                                      updateSelectedVertex(null);
                                    } 
                                    ui.hideAllMenus();
                                  }
                                  public void onRightClick(Label l,int x, int  y){
                                    print("\nRight Clicked : " +  l.getText());
                                  }
                                });
    ui.addMenuButton("vertex","PATH", new LabelInterface(){
                                      public void onLeftClick(Label l, int x, int  y){
                                        print("\nLeft Clicked : " +  l.getText());
                                        l.setHighlight(true);
                                        currentAction = "path";
                                        addGraph("path",null,  false); //clear current path graph
                                      }
                                      public void onRightClick(Label l,int x, int  y){
                                        print("\nRight Clicked : " +  l.getText());
                                      }
                                    });
   
  ui.addMenuButton("vertex","ADD EDGE", new LabelInterface(){
                          public void onLeftClick(Label l, int x, int  y){
                            print("\nLeft Clicked : " +  l.getText());
                            l.setHighlight(true);
                            currentAction = "addedge";
                            
                          }
                          public void onRightClick(Label l,int x, int  y){
                            print("\nRight Clicked : " +  l.getText());
                          }
   });                 
   ui.addMenuButton("graph","ADD VERTEX", new LabelInterface(){
                                          public void onLeftClick(Label l, int x, int  y){
                                            print("\nON Left Clicked : " +  l.getText());
                                            l.setHighlight(true);
                                            currentAction = "addvertex";
                                          }
                                          public void onRightClick(Label l,int x, int  y){
                                            print("\nOn Right Clicked : " +  l.getText());
                                          }
                                        });
}
public void initDefaultGraph(){
  undirgraph.clear();
   //set interface callbacks interface 
   Vertex a = new Vertex(440,294,'A');
  Vertex b= new Vertex(45,450,'B');
  Vertex c = new Vertex(590,200,'C');
  Vertex d = new Vertex(800,534,'D');
  Vertex e = new Vertex(900,90,'E');
  Vertex f = new Vertex(105,85,'F');
  Vertex g = new Vertex(330,220,'G');
  undirgraph.addEdge(a,b, 14);
    //undirgraph.addEdge(b,a, 80);
  undirgraph.addEdge(a,c, 34);
  undirgraph.addEdge(a,d, 56);
  undirgraph.addEdge(d,c, 12);
  undirgraph.addEdge(d,b, 3);  
  undirgraph.addEdge(d,e, 66); 
  undirgraph.addEdge(f,c, 77);
  undirgraph.addEdge(f,b, 15);  
  undirgraph.addEdge(f,e, 45); 
  undirgraph.addEdge(f,g, 27); 
  undirgraph.addEdge(g,e, 98); 
  undirgraph.addEdge(g,a, 45); 
  undirgraph.addEdge(g,b, 11); 
  undirgraph.updateEdgeWeight(a,c,10); 
    print("\nVertices:\n");
  for(Vertex v : undirgraph.getVertexSet())
    print(" " + v.getText());
  print("\nEdges:\n");
  for(Edge edge : undirgraph.getEdgeSet())
    print("("+edge.getSource().getText() + " "  + edge.getDest().getText() + " :" + edge.getText() + ")" );
  addGraph("UNDIR",undirgraph,  false);     
}

public Graph getBFS(Graph graph, Vertex a){
    Graph bfs = new Graph();
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
    if(bfs.getVertexSet().size() == graph.getVertexSet().size()){
      return bfs;
    }
    return null; //failed to generate graph
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

public Graph getDFS(Graph graph, Vertex a){
    HashMap<Vertex, Boolean> visitedMap = new HashMap<Vertex, Boolean>();
    for(Vertex v : graph.getVertexSet())
      visitedMap.put(v, false);
    visitedMap.put(a, true); //mark vertex as visited
    Graph dfs= getSubGraphDFS(a, graph, visitedMap);
    if(dfs != null && dfs.getVertexSet().size() == graph.getVertexSet().size()){
      return dfs;
    }
    return null; //failed to generate graph
  }
  
  public Graph getSubGraphDFS(Vertex root, Graph graph, HashMap<Vertex, Boolean> visitedMap){
  
    Graph dfs = new Graph();
    
    for(Edge e: graph.getAdjacentEdges(root)){ //for each adjacent edge
       if(!visitedMap.get(e.getDest())){ //if dest is not visited
         visitedMap.put(e.getDest(), true); //mark vertex as visited
         dfs.addGraph(getSubGraphDFS(e.getDest(),graph, visitedMap)) ;  //add to traversal queue
         dfs.addEdge(e.getSource(),e.getDest(),e.getWeight());   
        }
      }
     return dfs;

  }
    
public HashMap<Vertex,Graph> getShortestPaths(Graph graph, Vertex initial){
  HashMap<Vertex,Graph>  paths = new HashMap<Vertex, Graph>();
  TreeSet<Vertex> q = new TreeSet<Vertex>();
  HashMap<Vertex, Integer> dist = new HashMap<Vertex, Integer>();;
  HashMap<Vertex, Edge> prev  = new HashMap<Vertex, Edge>(); //previous vertex for vertex's shortest path,
  for(Vertex v : graph.getVertexSet()){ //adds vertices in graphs given vertex order
    dist.put(v,Integer.MAX_VALUE-1);
    prev.put(v,null);
    q.add(v);
  }//for each vertex
  dist.put(initial, 0);
  print("\nInitializeded structures ");

  while(!q.isEmpty()){
    //fin min vertex, if equal the first vertex to have lowest is assigned as min
    Vertex min = null;
    for(Vertex v : q){
      if(min == null) min=v;
      int diff = dist.get(v) - dist.get(min);
        if(diff < 0)
          min = v; //assign new min
    }
    //u is min
    q.remove(min); //remove meaning visited
    for(Edge edge : graph.getAdjacentEdges(min)){
      int newDist = dist.get(min) + edge.getWeight(); //get distance from u to v
      if(newDist < dist.get(edge.getDest())){ //if new distance is smaller than current distance to v
          dist.put(edge.getDest(), newDist);
          prev.put(edge.getDest(),edge);
      }
    }//end for adjacent edges              
  }//end while q ! empty
  for(HashMap.Entry entry : dist.entrySet()){ //for each vertex
    print("\nVertex : " + ((Vertex)entry.getKey()).getText() + " Dist: " + dist.get((Vertex)entry.getKey()) + " - " );
    paths.put((Vertex)entry.getKey(), new Graph());
    Vertex a = (Vertex)entry.getKey();
    Edge e = prev.get(a);
    while(e != null){
      print("  " + e.getSource().getText());
      paths.get((Vertex)entry.getKey()).addEdge(e.getSource(), e.getDest(), e.getWeight());


      e = prev.get(e.getSource());
    }
  }
  return paths;
}

public Graph getShortestPath(Graph graph,Vertex start, Vertex end){
  Graph g = getShortestPaths(graph, start).get(end);
   return g;
}

class Edge extends Label {
  public Edge(){
    super(0,0,0,0,"",0);
   this.source = null;
   this.dest = null;
    this.weight = 0;
  }
  public Edge(Vertex source, Vertex dest, int weight){
      super((int)(source.getX()+dest.getX())/2,//x
                       (int)(source.getY()+ dest.getY())/2, //y
                      64, 32,//w, h/rgb
                      String.valueOf(weight), 30);
   this.source = source;
   this.dest = dest;
   this.weight = weight;
   lr = 103;
   lg = 45;
   lb = 0;
   setRGB(130,120,0);
   setTextRGB(0,190,10);
   setFilled(false);      
    
  }
  public Edge(Edge other){
   super(other);
   this.source = other.source;
   this.dest = other.dest;
    this.weight = other.weight;
  }
  public int compareTo(Edge e){
    int val = weight -  e.weight;
    if( val == 0) //order by vertex dest if equal
      val = dest.compareTo(e.getDest());    
    return val;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Edge) && (this.source == ((Edge)o).source && 
                                    this.dest == ((Edge)o).dest);
  }
  public Vertex getSource() {
      return source;
  }
  public Vertex getDest() {
      return dest;
  }
 
  public void setWeight(int weight){
    this.weight = weight;
    setText(String.valueOf(weight));
  }
   public void setLineRGB(int r,int g,int b){
    this.lr = r;
    this.lg = g;
    this.lb = b;
  }
  public int getWeight(){
  return weight;
  }
  public boolean hasVertices() {return (this.source != null && this.dest != null);}
  public void draw(){
    if(hasVertices()){
      pushMatrix();
      //draw line from source to dest
      if(highlight){
        stroke(lb,lg,lr);
        fill(lb,lg,lr);
      }else{
        stroke(lr,lg,lb);
        fill(lr,lg,lb);

      }strokeWeight(4);
      int mx = (int)(source.getX()+dest.getX())/2;
      int my = (int)(source.getY()+ dest.getY())/2;
      line(source.getX(),source.getY(),dest.getX(),dest.getY());
      setPosition(mx, my);
      super.draw();
      popMatrix();
    }
  }
  Vertex source,dest;
  int lr,lg,lb;
  int weight;
}






class Graph{
  public Graph(){
    vertexAdjacencyMap = new HashMap<Vertex,TreeSet<Edge>> ();
    drawVertices = drawEdges = true;
    directed = false; 
    weighted = true;
  }
  public Graph(Graph other){
    vertexAdjacencyMap = other.vertexAdjacencyMap;
    drawVertices = other.drawVertices;
    drawEdges = other.drawEdges;
    weighted = other.weighted;
    directed = other.directed;
    setLabelInterface(other.labelInterface);

  }
  public void addVertex(Vertex a){
     if(a != null && !vertexAdjacencyMap.containsKey(a)){
       if(labelInterface!= null)a.setInterface(labelInterface); 
       vertexAdjacencyMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addGraph(Graph graph){
    vertexAdjacencyMap.putAll(graph.vertexAdjacencyMap);
  }
  public void addEdge(Vertex source,Vertex dest, int weight){
   Edge e = getEdge(source, dest);
   Edge eComp = getEdge(dest, source);
   addVertex(source);      
    addVertex(dest);//tries to add if not in
    if(!directed){
      if((e != null && eComp != null)){
        //update
          e.setWeight(weight);
          eComp.setWeight(weight);
      }else{
        e =  new Edge(source,dest,weight);
        eComp =  new Edge(dest, source,weight);
        e.setInterface(labelInterface);
        eComp.setInterface(labelInterface);
        vertexAdjacencyMap.get(source).add(e);
        vertexAdjacencyMap.get(dest).add(eComp);
      }
    }
  }
  public void setDrawVertices(boolean drawVertices){
    this.drawVertices = drawVertices;
  }
  public void setDrawEdges(boolean drawEdges){
    this.drawEdges = drawEdges;
  }
  public void setWeighted(boolean isWeighted){
    this.weighted = isWeighted;
  }
  public void setDirected(boolean isDirected){
    this.directed = isDirected;
  }
  public void setHighlightEdges(boolean isHighlighted){
   for(Edge e:getEdgeSet())
     e.setHighlight(isHighlighted);
  }
  public void setHighlightVertices(boolean isHighlighted){
   for(Vertex v: getVertexSet())
     v.setHighlight(isHighlighted);
  }
  public Vertex getVertex(String id){
    for(Vertex v: getVertexSet()){
     if(String.valueOf(v.getID()) == id)
       return v;
    }
    return null;
  }
  public void drawEdges(){
     
    if(drawEdges)
       for(Edge e : getEdgeSet())
         e.draw();
  }
  public boolean isDrawVertices()
  {
    return drawVertices;
  }
  public boolean isDrawEdges()
  {
    return drawEdges;
  }
  public void drawVertices(){
    if(drawVertices)
      for(Vertex v: getVertexSet())
        v.draw();
  }
  public ArrayList<Vertex> getVertexSet(){
    ArrayList<Vertex> sortList=  new ArrayList(vertexAdjacencyMap.keySet());
    Collections.sort(sortList);
    return sortList;
  }
  public int getVertexCount(){
      return (new ArrayList(vertexAdjacencyMap.keySet())).size();

  }
  public Edge getEdge(Vertex source, Vertex dest){
    if(source == null || dest == null) return null;
    TreeSet<Edge> edgeSet = vertexAdjacencyMap.get(source);
    if(edgeSet == null) return null;
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
    TreeSet<Edge>sourceEdgeSet = vertexAdjacencyMap.get(source);
    TreeSet<Edge>destEdgeSet = vertexAdjacencyMap.get(dest);

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
     ArrayList<Edge> sortList = new ArrayList<Edge>(vertexAdjacencyMap.get(v)); 
     Collections.sort(sortList);
     return sortList;
  }
  public ArrayList<Edge> getEdgeSet(){
    ArrayList<Edge> sortList = new ArrayList<Edge>();
    for(Vertex v : getVertexSet())
     sortList.addAll(vertexAdjacencyMap.get(v)); 
   Collections.sort(sortList);
   return sortList;
  }
  public void clear(){
     vertexAdjacencyMap.clear(); 
  }
  public void setLabelInterface( LabelInterface labelInterface){
    if(labelInterface != null){
     this.labelInterface = labelInterface;
      for(Edge e: getEdgeSet())
        e.setInterface(labelInterface); 
      for(Vertex v: getVertexSet())
        v.setInterface(labelInterface); 
    }
 }
 public LabelInterface getInterface(){
   return labelInterface;
 }
  LabelInterface labelInterface;
  HashMap<Vertex,TreeSet<Edge>> vertexAdjacencyMap;
  boolean drawVertices, drawEdges;
  boolean directed, weighted;
}
interface LabelInterface{
    public void onLeftClick(Label l,int x, int  y);
    public void onRightClick(Label l,int x, int  y);
  }
public class Label implements Comparable<Label>{
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
    labelInterface = null;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Label) && ( this.text == ((Label)o).getText());
  }
  @Override public int compareTo(Label o) {
    if(o instanceof Vertex)
      return ((Vertex)this).compareTo(((Vertex)o));
    else if(o instanceof Button)
      return ((Button)this).compareTo(((Button)o));
    else if(o instanceof Edge)
      return ((Edge)this).compareTo(((Edge)o));
     else
       return -1;
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
    labelInterface = other.labelInterface;
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
   public void setInterface(LabelInterface labelInterface){
   this.labelInterface = labelInterface; 
  }
  public LabelInterface getInterface(){
    return labelInterface;
  }
  public void leftClick(int x, int  y){
    if(labelInterface !=  null)
       labelInterface.onLeftClick(this,x,y);
  }
  public void rightClick(int x, int  y){
    if(labelInterface !=  null)
       labelInterface.onRightClick(this,x,y);
    else
       print("\nLabel Interface NULL\n");
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
  LabelInterface labelInterface;

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
   // unhighlight();
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
  public void addButton(String label, LabelInterface labelInterface){
    
    int count = buttons.size();
    Button b = new Button(x,y+(h*count),w,h, label, 18);
    b.setInterface(labelInterface);
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
  public UIManager(){
  menus = new HashMap <String, Menu>();
  graphs = new HashMap <String, Graph>();

  }
  public void addMenu(String id, int w, int h){
   menus.put(id,new Menu(w,h));    
  }
  public void addMenuButton(String menuId, String buttonId, LabelInterface labelInterface){
   getMenu(menuId).addButton(buttonId, labelInterface);  
  }
 public void setGraph(String id, Graph graph){
    this.graphs.put(id,graph); 
 }  
  public Menu getMenu(String id){
    return menus.get(id); 
  }
  public void hideMenu(String id){
    Menu m=getMenu(id);
    if( m != null){
      m.hide(); 
      m.unhighlight();
    } 
  }
  public void hideAllMenus(){
   for(Menu m : menus.values()){
      m.hide(); 
      m.unhighlight();
    } 
  }
  public void clear(){
    
    menus.clear();
    for(Graph g : graphs.values())
      g.clear();
  }
  public Graph getGraph(String id){
    return graphs.get(id);
  }
  public void drawMenus(){
     for(Menu m : menus.values())
       m.draw();    
  }
  public Label getIntersectingLabel(float x, float y){
    Label l = null;
    
    //for all graphs
    Iterator itX =graphs.values().iterator();
    while(l == null && itX.hasNext()){    
      Graph g = (Graph)itX.next();
       //check if point intersects any labels 
       if(g != null){
        
        Iterator itY =g.getVertexSet().iterator();
        if(g.isDrawVertices()){
          while(l==null && itY.hasNext()){
            Vertex v = (Vertex)itY.next(); 
            if(v.intersects(x,y)){
              l = v;
            }
          }
        }
        if(g.isDrawEdges()){
          //check all edges
          itY = g.getEdgeSet().iterator();
          while(l==null && itY.hasNext()){
            Edge v = (Edge)itY.next(); 
            if(v.intersects(x,y)){
              l = v;
            }
          }
        //check menu labels if intersecting label still not found
        }
       }//end if g != null
    }//end while not found
   Iterator itZ = menus.values().iterator();
        while(l==null && itZ.hasNext()){
          Button b = ((Menu)itZ.next()).getIntersectingButton(x,y); 
          if(b != null){
            l = b;
          }
        }
     return l; 
 }
 
 HashMap <String, Menu> menus;
 HashMap <String, Graph> graphs; 

}
class Vertex extends Label {
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
     return id - v.getID() ;
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
