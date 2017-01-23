import java.util.HashMap;
float red = 0, green =250,blue = 140;
float buttonWidth =250 , buttonHeight = 32;
String noneLabel ="NONE";
String bfsLabel = "BFS";
Vertex vertexSource, vertexDest;
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
  ui.addMenuButton("vertex", "BFS", new ActionInterface(){
                                    public void onClick(){
                                      undirgraph = getBFS(undirgraph,selectedVertex);
                                      
                                    }
                              });
  ui.addMenuButton("vertex","DFS", new ActionInterface(){
                                    public void onClick(){
                                      undirgraph = getDFS(undirgraph,selectedVertex);
                                    }
                              });
                              
   ui.addMenuButton("graph","ADD VERTEX", new ActionInterface(){
                            public void onClick(){
                              deselectAll();
                              vertexAdd = true;
                              print("To add vertex anywhere");
                            }
                      });
   ui.addMenuButton("graph","ADD EDGE", new ActionInterface(){
                                    public void onClick(){
                                      deselectAll();
                                      edgeSelection = true;
                                      print("To add edge, click on 2 Vertices");
                                    }
                              });

}

void draw(){
 background(0); 
 undirgraph.draw();
 ui.draw();
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
    ui.getMenu("graph").hide();//hide other menus  
    ui.getMenu("vertex").hide();
    if(v != null){
        ui.getMenu("vertex").setPosition(mouseX, mouseY);
        ui.getMenu("vertex").open();
        ui.getMenu("graph").hide();//hide other menus  
        selectedVertex = v;
      }else if(e != null){//edge clicked   
       edgeValueBuilder = new String();
       print("\nSelected Edge : " + e.getText());
       ui.getMenu("graph").hide();//hide menus  
       ui.getMenu("vertex").hide();//hide menus
     }
      else if(graphB == null){ //right click empty space
        ui.getMenu("graph").setPosition(mouseX, mouseY);
        ui.getMenu("graph").open();//open graph menu
         ui.getMenu("vertex").hide();//hide other menus  
      }

  }
  //if button left clicked
  else if(mouseButton == LEFT){
    ui.getMenu("graph").unhighlight();//hide other menus  
    ui.getMenu("vertex").unhighlight();
      if(selectedVertex != null){
        if(vertexB != null){ //if ui.getMenu("vertex") button click action for vertex
          print("\nClicked Vertex Menu Button: "+  vertexB.getText());
          vertexB.click();
          ui.getMenu("vertex").hide();//hide menus  

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
               Edge edge = undirgraph.getEdge(vertexSource, vertexDest);
               ui.addLabel(String.valueOf(edge.getWeight()),edge);
               vertexDest = vertexSource = null;
               edgeSelection = false;
               ui.getMenu("graph").hide();
             }
          }
     }//end if vertex left click
     else if(e != null){ //edge left click
        print("\nClicked edge Value: " + e.getText());   
     }
     else{ //sp;ace left click
      print("\nPos Clicked " + mouseX + " , " + mouseY);
       ui.getMenu("graph").hide();//hide menus  
       ui.getMenu("vertex").hide();//hide menus  

       if(vertexAdd){ //if adding action, add verte
          print("\nAdding:" + mouseX + " , " + mouseY);
          Vertex newV = new Vertex(mouseX, mouseY, char('A'+ undirgraph.getVertexSet().size()));
          undirgraph.addVertex(newV);// add vertex of id one beyond size
          ui.addLabel(String.valueOf(newV.getID()),newV);
          vertexAdd = false;
       
       }
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
      print("Label type Vertex pressed");
      ui.getMenu("vertex").hide();
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

void initDefaultGraph(){
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

  for(Vertex v : undirgraph.getVertexSet()){
    ui.addLabel(String.valueOf(v.getID()),v);
  }
}