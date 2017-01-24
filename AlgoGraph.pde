import java.util.HashMap;
float red = 0, green =250,blue = 140;
float buttonWidth =250 , buttonHeight = 32;
String currentGraphAction = "";
Vertex vertexSource, vertexDest, vertexStart,vertexEnd;
boolean vertexAdd, edgeSelection;
UIManager ui = new UIManager();
String edgeValueBuilder =null;
UndirectedGraph undirgraph = new UndirectedGraph();

Vertex selectedVertex = null, draggingVertex = null;
void setup(){
  size(1080, 720);
  initDefaultGraph();
  ui.addMenu("vertex",72,32);
  ui.addMenu("graph",150,32);
  ui.addMenuButton("vertex", "BFS", new LabelInterface(){
                                          public void onClick(Label l){
                                            print("\nClicked : " +  l.getText());
                                            UndirectedGraph g = getBFS(undirgraph,selectedVertex);
                                            if(g != null){
                                              //g.setDrawVertices(false);
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

void draw(){
 background(0); 
 //undirgraph.draw();
 UndirectedGraph g =  ui.getGraph("UNDIR");
 if(g != null)g.drawEdges(); //draw edges first
  g = ui.getGraph(currentGraphAction);
  if(g != null)g.drawEdges();  //draw highlighted edges for graph of current action
  g = ui.getGraph("UNDIR");
  if(g != null)g.drawVertices(); //draw draw vertices of all edges

  ui.drawMenus();

}
void mouseClicked(){
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
          Vertex newV = new Vertex(mouseX, mouseY, char('A'+ undirgraph.getVertexSet().size()));
          undirgraph.addVertex(newV);// add vertex of id one beyond size
          vertexAdd = false;
       }else{
       }
       ui.hideAllMenus();
       deselectAll();       
     }

    }//if left
}

void deselectAll(){
 selectedVertex = null; //deselect verteices
  vertexDest = vertexSource = null;
  vertexAdd = false;
  edgeSelection = false; 
  
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
void mouseDragged(){
  if(mouseButton == LEFT && draggingVertex != null){
    draggingVertex.setX(draggingVertex.getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    draggingVertex.setY(draggingVertex.getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
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
 else if(keyCode == ' '){ //clear
   initDefaultGraph();
 }
}
void getDijkstra(){
  if(vertexStart  != null && vertexEnd != null){
 print("\nGenerating Graph of shortest path from : " + vertexStart.getText() + " -> " + vertexEnd.getText());
      UndirectedGraph g  = getShortestPath(undirgraph,vertexStart,vertexEnd);   
      if(g != null){
        //g.setDrawVertices(false);
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