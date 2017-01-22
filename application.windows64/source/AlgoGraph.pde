import java.util.HashMap;
float red = 0, green =250,blue = 140;
float buttonWidth =250 , buttonHeight = 32;
String noneLabel ="NONE";
String bfsLabel = "BFS";
Vertex vertexSource, vertexDest;
boolean vertexAdd, edgeSelection;
Menu vertexMenu = new Menu(72,32);
Menu graphMenu = new Menu(150,32);

UndirectedGraph undirgraph = new UndirectedGraph();
Vertex selectedVertex = null, draggingVertex = null;
void setup(){
  size(1080, 720);
  initDefaultGraph();
  vertexMenu.addButton("BFS", new ButtonInterface(){
                                    public void onClick(){
                                      undirgraph = getBFS(undirgraph,selectedVertex);
                                      
                                    }
                              });
  vertexMenu.addButton("DFS", new ButtonInterface(){
                                    public void onClick(){
                                      undirgraph = getDFS(undirgraph,selectedVertex);
                                    }
                              });
  graphMenu.addButton("ADD VERTEX", new ButtonInterface(){
                            public void onClick(){
                              deselectAll();
                              vertexAdd = true;
                              print("To add vertex anywhere");
                            }
                      });
  graphMenu.addButton("ADD EDGE", new ButtonInterface(){
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
   Button vertexB = vertexMenu.getIntersectingButton(mouseX, mouseY);//get vertex button clicked
   Button graphB = graphMenu.getIntersectingButton(mouseX, mouseY);//get graph button clicked
  //if vertex right clicked
  if(mouseButton == RIGHT){ //right click vertex to show vertexMenu
   deselectAll();//default deselect o n riight click
    if(v != null){
        vertexMenu.setPosition(mouseX, mouseY);
        vertexMenu.open();
        graphMenu.hide();//hide other menus  
        selectedVertex = v;
      }else if(graphB == null){ //right click empty space
        graphMenu.setPosition(mouseX, mouseY);
        graphMenu.open();//open graph menu
         vertexMenu.hide();//hide other menus  
      }

  }
  //if button left clicked
  else if(mouseButton == LEFT){
      if(selectedVertex != null){
        if(vertexB != null){ //if vertexMenu button click action for vertex
          print("\nClicked Vertex Menu Button: "+  vertexB.getLabel().getText());
          vertexB.click();
          vertexMenu.hide();//hide menus  

        }
      }// end if ther is a selected vertex for vertex menu
      else if(graphB != null){
            print("\nClicked Graph Menu Button: "+  graphB.getLabel().getText());
            graphB.click();
            graphB.getLabel().setHighlight(true);

       }//end if graph button was clicked
       else if(v != null){ //if left vertex clicked
          if(edgeSelection){ //if selecting menu vertex
             if( vertexSource == null){
                vertexSource = v;
               print("\nSource: " + v.getLabel().getText());
               v.getLabel().setHighlight(true);
             }else{//if this is the second vertex clicked
               vertexDest = v;
               print("\nDest: " + v.getLabel().getText());   
               vertexSource.getLabel().setHighlight(false);
               undirgraph.addEdge(vertexSource,vertexDest, 1);
               vertexDest = vertexSource = null;
               edgeSelection = false;
               graphMenu.hide();//hide menus 
               

             }
          }
     }//end if vertex left click 
     else{ //sp;ace left click
      print("\nPos Clicked " + mouseX + " , " + mouseY);

       if(vertexAdd){ //if adding action, add verte
                           print("\nAdding:" + mouseX + " , " + mouseY);

              undirgraph.addVertex(new Vertex(mouseX, mouseY, char('A'+ undirgraph.getVertexSet().size())));// add vertex of id one beyond size
              vertexAdd = false;
              graphMenu.hide();//hide menus  
            }
       }

  }//if left
}
Vertex getIntersectingVertex(float x, float y){
  for(Vertex v : undirgraph.getVertexSet()){
      if(v.getLabel().intersects(x,y)){
         return v; //return vertex 
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
    draggingVertex.getLabel().setX(draggingVertex.getLabel().getX() + mouseX - pmouseX); //move by difference of previous mouse and current mouse
    draggingVertex.getLabel().setY(draggingVertex.getLabel().getY() + mouseY - pmouseY); //move by difference of previous mouse and current mouse
  }
}
void mouseReleased(){
  if(mouseButton == LEFT ){
    draggingVertex = null;
  }
}
void keyPressed(){
 if(keyCode == ' '){ //clear
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
    print(char(v.getID()) + "\n");
}