import java.util.HashMap;
float red = 0, green =250,blue = 140;
float buttonWidth =250 , buttonHeight = 32;
String currentAction = "", currentSubGraph = "";
Vertex selectedVertex, otherSelectedVertex;
boolean vertexAdd, edgeSelection;
UIManager ui = new UIManager(); //ui manager contains a map to multiple different graphs that can be dynamically requested
String edgeValueBuilder ="";
Graph undirgraph = new Graph();
Vertex  draggingVertex = null;

void setup(){
  size(1080, 720);
  initDefaultGraph();
  initUI();
}

void addGraph(String id, Graph graph, boolean highlight){
  if(graph != null){
    print("Adding Graph : " + id + "\n");
    initInterface(graph);
    graph.setHighlightEdges(highlight); 
 }  
   ui.setGraph(id,graph);

}

void onRightClick(int x, int  y){ //right click nothing 
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
void onLeftClick(int x, int  y){ //right click nothing
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
       Vertex v = new Vertex(x,y, char('A'+g.getVertexCount()+1));
       g.addVertex(v);
       ui.hideAllMenus();
       currentAction = "";
     }
    }
} 
void updateSelectedVertex(Vertex v){
  if(selectedVertex != null) 
  selectedVertex.setHighlight(false); //un\highlight prev vertex sel
  selectedVertex = v;
  if(selectedVertex != null)
    selectedVertex.setHighlight(true);
}
void draw(){
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
void mouseClicked(){
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
void mouseDragged(){
  if(mouseButton == LEFT && draggingVertex != null){
    draggingVertex.setX(draggingVertex.getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    draggingVertex.setY(draggingVertex.getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
  }
}
void mousePressed(){
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
void mouseReleased(){
  if(mouseButton == LEFT ){
    draggingVertex = null;
  }
}
void keyPressed(){
   if(keyCode >= '0' && keyCode <= '9' && edgeValueBuilder.length() <= 3) { //set value to current string edge builder value
     edgeValueBuilder += char(keyCode);
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
void initInterface(Graph g){
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
void initUI(){
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
void initDefaultGraph(){
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