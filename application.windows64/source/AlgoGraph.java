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
String currentGraphAction = "";
Vertex vertexSource, vertexDest, vertexStart,vertexEnd;
boolean vertexAdd, edgeSelection;
UIManager ui = new UIManager();
String edgeValueBuilder =null;
UndirectedGraph undirgraph = new UndirectedGraph();

Vertex selectedVertex = null, draggingVertex = null;
public void setup(){
  
  initDefaultGraph();
  ui.addMenu("vertex",72,32);
  ui.addMenu("graph",150,32);
  ui.addMenuButton("vertex", "BFS", new LabelInterface(){
                                          public void onClick(Label l){
                                            print("\nClicked : " +  l.getText());
                                            UndirectedGraph g = getBFS(undirgraph,selectedVertex);
                                            if(g != null){
                                              g.setDrawVertices(false);
                                              g.setHighlightEdges(true);
                                              ui.setGraph("BFS",g);
                                              currentGraphAction ="BFS";
                                            }
      
                                          }
                                    });
  ui.addMenuButton("vertex","DFS", new LabelInterface(){
                                          public void onClick(Label l){
                                            print("\nClicked : " +  l.getText());
                                            UndirectedGraph g = getDFS(undirgraph,selectedVertex);
                                            if(g != null)
                                              g.setHighlightEdges(true);
                                              ui.setGraph("DFS",g);
                                              currentGraphAction = "DFS";
                                            }
                                    });
    ui.addMenuButton("vertex","START", new LabelInterface(){
                                            public void onClick(Label l){
                                              print("\nClicked : " +  l.getText());
                                              if(vertexStart != null)
                                                vertexStart.setHighlight(false); //unhighlight old vertex selection
                                              vertexStart = selectedVertex;
                                              vertexStart.setHighlight(true);
                                              getDijkstra();
                                            }
                                      });
    ui.addMenuButton("vertex","END", new LabelInterface(){
                                            public void onClick(Label l){
                                              print("\nClicked : " + l.getText());
                                              if(vertexEnd != null)
                                                vertexEnd.setHighlight(false); //unhighlight old vertex selection
                                              vertexEnd = selectedVertex;
                                              vertexEnd.setHighlight(true);
                                              getDijkstra();
                                            }
                                      });
                              
   ui.addMenuButton("graph","ADD VERTEX", new LabelInterface(){
                                               public void onClick(Label l){
                                                  print("\nClicked : " + l.getText());
                                                  deselectAll();
                                                  vertexAdd = true;
                                                  print("To add vertex anywhere");
                                                }
                                          });
   ui.addMenuButton("graph","ADD EDGE", new LabelInterface(){
                                              public void onClick(Label l){
                                                print("\nClicked : " + l.getText());
                                                deselectAll();
                                                edgeSelection = true;
                                                print("To add edge, click on 2 Vertices");
                                              }
                                        });
                              
    ui.setLabelInterface("UNDIR",new LabelInterface(){
          public void onClick(Label l){
            if(l instanceof Vertex)
                print("\nClicked Vertex: " + l.getText());
            else if(l instanceof Button)
                print("\nClicked Button: " + l.getText());
            else if(l instanceof Edge)
                print("\nClicked Edge: " + l.getText());
            else
                print("\nClicked Label: " + l.getText());

            
          }
    });

}

public void draw(){
 background(0); 
 //undirgraph.draw();
  ui.draw("UNDIR");
  ui.draw(currentGraphAction);
  ui.drawMenus();

}
public void mouseClicked(){
  Label l = ui.getIntersectingLabel(mouseX, mouseY);//get vertex clicked
  Vertex v= null;
  Button vertexB = null, graphB = null;
  Edge e = null;
   if(l != null) {
     if(l instanceof Vertex) 
       v = (Vertex)l;
     else if( l instanceof Edge)
     e = (Edge)l;
       else{
         vertexB = ui.getMenu("vertex").getIntersectingButton(mouseX, mouseY);//get vertex button clicked
         if(vertexB == null) graphB = ui.getMenu("graph").getIntersectingButton(mouseX, mouseY);//get graph button clicked
       }
   }     
  //if vertex right clicked
  if(mouseButton == RIGHT){ //right click vertex to show ui.getMenu("vertex")
    deselectAll();//default deselect o n riight click
    //hide all menus by default
    ui.hideAllMenus();
    if(v != null){
        ui.getMenu("vertex").setPosition(mouseX, mouseY);
        ui.openMenu("vertex");
        selectedVertex = v;
      }else if(e != null){//edge clicked   
       edgeValueBuilder = new String();
       print("\nSelected Edge : " + e.getText());
     }
      else if(graphB == null){ //right click empty space
        ui.getMenu("graph").setPosition(mouseX, mouseY);
         ui.openMenu("graph");//open graph menu
      }
  }
  //if button left clicked
  else if(mouseButton == LEFT){
    
        if(vertexB != null){ //if ui.getMenu("vertex") button click action for vertex
          print("\nClicked Vertex Menu Button: "+  vertexB.getText());
          
          vertexB.setHighlight(true);
          vertexB.click();
          ui.hideMenu("vertex");//hide menus  
        }
      // end if ther is a selected vertex for vertex menu
      else if(graphB != null){
            print("\nClicked Graph Menu Button: "+  graphB.getText());
            graphB.click();
            ui.hideAllMenus();
            ui.openMenu("graph");
            graphB.setHighlight(true);
       }//end if graph button was clicked
       else if(v != null){ //if left vertex clicked
         v.click();
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
               ui.hideMenu("graph");
             }
          }
     }//end if vertex left click
     else if(e != null){ //edge left click
            ui.hideAllMenus();
           print("\nEdge Clicked " + e.getText());

     }
     else{ //sp;ace left click
      print("\nPos Clicked " + mouseX + " , " + mouseY);
       if(vertexSource != null){
         vertexSource.setHighlight(false);
         vertexSource = null;
       }
       else if(vertexAdd){ //if adding action, add verte
          print("\nAdding:" + mouseX + " , " + mouseY);
          Vertex newV = new Vertex(mouseX, mouseY, PApplet.parseChar('A'+ undirgraph.getVertexSet().size()));
          undirgraph.addVertex(newV);// add vertex of id one beyond size
          vertexAdd = false;
       }else{
       }
       ui.hideAllMenus();
       deselectAll();       
     }

    }//if left
}

public void deselectAll(){
 selectedVertex = null; //deselect verteices
  vertexDest = vertexSource = null;
  vertexAdd = false;
  edgeSelection = false; 
  
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
public void getDijkstra(){
  if(vertexStart  != null && vertexEnd != null){
 print("\nGenerating Graph of shortest path from : " + vertexStart.getText() + " -> " + vertexEnd.getText());
      UndirectedGraph g  = getShortestPath(undirgraph,vertexStart,vertexEnd);   
      if(g != null){
        g.setDrawVertices(false);
        g.setHighlightEdges(true);
        ui.setGraph("DIJK",g);
        currentGraphAction = "DIJK";
        vertexStart.setHighlight(false);
        vertexEnd.setHighlight(false);
        vertexStart = null;
        vertexEnd = null;
      }    
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
  undirgraph.addEdge(a,b, 14);
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
  ui.setGraph("UNDIR",undirgraph);
}
interface ActionInterface{
 public void onLabelClicked(Label label  );
}
public class ActionHandler{
 
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
    
public HashMap<Vertex,UndirectedGraph> getShortestPaths(UndirectedGraph graph, Vertex initial){
  HashMap<Vertex,UndirectedGraph>  paths = new HashMap<Vertex, UndirectedGraph>();
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
    paths.put((Vertex)entry.getKey(), new UndirectedGraph());
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

public UndirectedGraph getShortestPath(UndirectedGraph graph,Vertex start, Vertex end){
  return getShortestPaths(graph, start).get(end);
 
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
                                    this.dest == ((Edge)o).dest && 
                                     this.weight == ((Edge)o).weight);
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
      if(highlight)
        stroke(lb,lg,lr);

      else
        stroke(lr,lg,lb);
      strokeWeight(4);
      line(source.getX(),source.getY(),dest.getX(),dest.getY());
      setPosition((int)(source.getX()+dest.getX())/2,//x
                     (int)(source.getY()+ dest.getY())/2);
      super.draw();
      popMatrix();
    }
  }
  Vertex source,dest;
  int lr,lg,lb;
  int weight;
}
interface LabelInterface{
    public void onClick(Label l);
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
    this.labelInterface = other.labelInterface;

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
  public void click(){
  if(labelInterface !=  null)
     labelInterface.onClick(this);
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
  graphs = new HashMap <String, UndirectedGraph>();

  }
  public void addMenu(String id, int w, int h){
   menus.put(id,new Menu(w,h));    
  }
  public void addMenuButton(String menuId, String buttonId, LabelInterface labelInterface){
   getMenu(menuId).addButton(buttonId, labelInterface);  
  }
 public void setGraph(String id, UndirectedGraph graph){
    this.graphs.put(id,graph); 
 }
  public void setLabelInterface(String graphId,LabelInterface labelInterface){
    UndirectedGraph g = graphs.get(graphId);
    if(g != null){
      for(Edge e: g.getEdgeSet())
           e.setInterface(labelInterface);  
  
      for(Vertex v: g.getVertexSet())
       v.setInterface(labelInterface);  
    }
  }
  
  
  public Menu getMenu(String id){
    return menus.get(id); 
  }
  public void openMenu(String id){
    Menu m=getMenu(id);
    if( m != null)
      m.open();   
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
    for(UndirectedGraph g : graphs.values())
      g.clear();
  }
  public void draw(String id){
    UndirectedGraph g = graphs.get(id);
    if(g != null)g.draw();
  }
  public void drawMenus(){
     for(Menu m : menus.values())
       m.draw();    
  }
  public Label getIntersectingLabel(float x, float y){
    Label l = null;
    Iterator itX =graphs.values().iterator();
    while(l == null && itX.hasNext()){    
    if(g != null){
      UndirectedGraph g = (UndirectedGraph)itX.next();
       //check if point intersects any labels 
        Iterator itY =g.getVertexSet().iterator();
        while(l==null && itY.hasNext()){
          Vertex v = (Vertex)itY.next(); 
          if(v.intersects(x,y)){
            l = v;
          }
        }
        itY = g.getEdgeSet().iterator();
        while(l==null && itY.hasNext()){
          Edge v = (Edge)itY.next(); 
          if(v.intersects(x,y)){
            l = v;
          }
        }
        //check menu labels if intersecting label still not found
        itY = menus.values().iterator();
        while(l==null && itY.hasNext()){
          Button b = ((Menu)itY.next()).getIntersectingButton(x,y); 
          if(b != null){
            l = b;
          }
        }
      }
    }//end while not found
     return l; 

  }
  
 HashMap <String, Menu> menus;
 HashMap <String, UndirectedGraph>  graphs;
}






class UndirectedGraph{
  public UndirectedGraph(){
    edgeMap = new HashMap<Vertex,TreeSet<Edge>> ();
    drawVertices = drawEdges = true;
  }
  public UndirectedGraph(UndirectedGraph other){
    edgeMap = other.edgeMap;
    drawVertices = other.drawVertices;
        drawEdges = other.drawEdges;

    
  }
  public void addVertex(Vertex a){
     if(a != null && !edgeMap.containsKey(a)){
       edgeMap.put(a, new TreeSet<Edge>());
     }
  }
  public void addGraph(UndirectedGraph graph){
    edgeMap.putAll(graph.edgeMap);
  }
  public void addEdge(Vertex source,Vertex dest, int weight){
    if(source == null && dest == null) return;
   Edge e = new Edge(source,dest,weight);
   Edge eComp = new Edge(dest, source,weight);
   addVertex(source);      
    addVertex(dest);//tries to add if not in
    if(!edgeMap.get(source).contains(e) && !edgeMap.get(dest).contains(e)){
      edgeMap.get(source).add(e);
      edgeMap.get(dest).add(eComp);

    }
  }
  public void setDrawVertices(boolean drawVertices){
    this.drawVertices = drawVertices;
  }
  public void setDrawEdges(boolean drawEdges){
    this.drawEdges = drawEdges;
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
  public void draw(){
     
    if(drawEdges)
       for(Edge e : getEdgeSet())
         e.draw();

    if(drawVertices)
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
  boolean drawVertices, drawEdges;
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
