import java.util.HashMap;
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
  public UndirectedGraph getGraph(String id){
    return graphs.get(id);
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