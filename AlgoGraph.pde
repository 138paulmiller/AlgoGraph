import java.util.HashMap;
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
void setup(){
  size(1080, 720);
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

void draw(){
 background(0); 
 undirgraph.draw();
 vertexMenu.draw();
 graphMenu.draw();
}
void mouseClicked(){
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

          undirgraph.addVertex(new Vertex(mouseX, mouseY, char('A'+ undirgraph.getVertexSet().size())));// add vertex of id one beyond size
          vertexAdd = false;
       
       }
       deselectAll();       
     }

    }//if left
}
Vertex getIntersectingVertex(float x, float y){
  for(Vertex v : undirgraph.getVertexSet()){
      if(v.intersects(x,y)){
         return v; //return vertex 
      }
  }
  return null;
}
Edge getIntersectingEdge(float x, float y){
  for(Edge e : undirgraph.getEdgeSet()){
      if(e.getLabel().intersects(x,y)){
         return e; //return vertex 
      }
  }
  return null;
}
void deselectAll(){
 selectedVertex = null; //deselect verteices
  vertexDest = vertexSource = null;
  vertexAdd = false;
  edgeSelection = false; 
  

}
void mousePressed(){
  Button b = vertexMenu.getIntersectingButton(mouseX,mouseY);
  Button b2 = graphMenu.getIntersectingButton(mouseX,mouseY);
  if(mouseButton == LEFT && b == null && b2 == null){
    vertexMenu.hide();
      draggingVertex = getIntersectingVertex(mouseX, mouseY);//get vertex clicked
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

  for(Vertex v : undirgraph.getVertexSet())
    print(char(v.getID()) + "\n");
}