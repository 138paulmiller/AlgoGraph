import java.util.HashMap;
float red = 0, green =250,blue = 140;
float buttonWidth =250 , buttonHeight = 32;
String currentAction = "";
Vertex selectedVertex;
boolean vertexAdd, edgeSelection;
UIManager ui = new UIManager();
String edgeValueBuilder =null;
UndirectedGraph undirgraph = new UndirectedGraph();

Vertex  draggingVertex = null;
void setup(){
  size(1080, 720);
  initDefaultGraph();
  ui.addMenu("vertex",72,32);
  ui.addMenu("graph",150,32);
  ui.addMenuButton("vertex", "BFS", new LabelInterface(){
                                          public void onLeftClick(Label l, int x, int  y){
                                            print("\nLeft Clicked : " +  l.getText());
                                            l.setHighlight(true);
                                            if(selectedVertex != null){
                                              currentAction ="bfs";
                                              addGraph("bfs",getBFS(undirgraph, selectedVertex));                                      updateSelectedVertex(null);
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
                                      currentAction ="dfs";
                                      addGraph("dfs",getDFS(undirgraph, selectedVertex));
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
                                        addGraph("path",null); //clear current path graph
                                      }
                                      public void onRightClick(Label l,int x, int  y){
                                        print("\nRight Clicked : " +  l.getText());
                                      }
                                    });
   
                              
   ui.addMenuButton("graph","ADD VERTEX", new LabelInterface(){
                                          public void onLeftClick(Label l, int x, int  y){
                                            print("\nLeft Clicked : " +  l.getText());
                                            l.setHighlight(true);
                                          }
                                          public void onRightClick(Label l,int x, int  y){
                                            print("\nRight Clicked : " +  l.getText());
                                          }
                                        });
   ui.addMenuButton("graph","ADD EDGE", new LabelInterface(){
                                        public void onLeftClick(Label l, int x, int  y){
                                          print("\nLeft Clicked : " +  l.getText());
                                          l.setHighlight(true);
                                        }
                                        public void onRightClick(Label l,int x, int  y){
                                          print("\nRight Clicked : " +  l.getText());
                                        }
                                      });
                              
    ui.setLabelInterface("UNDIR",new LabelInterface(){
          public void onLeftClick(Label l, int x, int  y){
            print("\nCurrentAction: " + currentAction);
            if(l instanceof Vertex){
                print("\nLeft Clicked Vertex: " + l.getText());
                if(currentAction == ""){ //if no action
                  ui.hideAllMenus();
                  updateSelectedVertex((Vertex)l); //update as normal
                }else if(currentAction == "path"){ //left clicked vertex is selected as root
                  if(selectedVertex != null){
                    addGraph(currentAction,getShortestPath(undirgraph, selectedVertex,(Vertex)l));                    
                    updateSelectedVertex(null);
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

void addGraph(String id, UndirectedGraph graph){
  if(graph != null){
    graph.setDrawVertices(false);
    graph.setHighlightEdges(true);
 }  
 ui.setGraph(id,graph);

}

void onRightClick(int x, int  y){ //right click nothing 
    print("\nRight Clicked");
    ui.hideAllMenus();
    updateSelectedVertex(null);//unselect vertices
    Menu m = ui.getMenu("graph");
    m.setPosition(x,y);
    m.open();
    currentAction = "";
}
void onLeftClick(int x, int  y){ //right click nothing
    print("\nLeft Clicked");
    if(currentAction == ""){ //if no current action hide menus
      ui.hideAllMenus();
      updateSelectedVertex(null);
      currentAction = "";
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
 UndirectedGraph g =  ui.getGraph("UNDIR");
 if(g != null)g.drawEdges(); //draw edges first
  g = ui.getGraph(currentAction);
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
     print("\nEdgeValueBuilder: "+ edgeValueBuilder);
  }
}

void initDefaultGraph(){
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