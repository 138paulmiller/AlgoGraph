import java.util.HashMap;
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