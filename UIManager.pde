import java.util.HashMap;
class UIManager{
  public UIManager(){
  menus = new HashMap <String, Menu>();
  graph = null;

  }
  public void addMenu(String id, int w, int h){
   menus.put(id,new Menu(w,h));    
  }
  public void addMenuButton(String menuId, String buttonId, ActionInterface actionInterface){
   getMenu(menuId).addButton(buttonId, actionInterface);  
  }
 public void setGraph(UndirectedGraph graph){
    this.graph = graph; 
 }
  public void setVertexInterface(String id, ActionInterface actionInterface){
   Label l = graph.getVertex(id);
   l.setInterface(actionInterface);  
  }
  public void setEdgeInterface(String sourceId, String destId,  ActionInterface actionInterface){
   Vertex source = graph.getVertex(sourceId);
   Vertex dest = graph.getVertex(destId);
    Edge edge = graph.getEdge(source, dest);
    if(edge != null)
     edge.setInterface(actionInterface);  
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
    if( m != null)
      m.hide();   
  }
  public void hideAllMenus(){
   for(Menu m : menus.values())
     m.hide();
  }
  public void clear(){
    menus.clear();
    graph.clear();
    selectedLabel = selectedMenu = "";
  }
  public void draw(){
      graph.draw();
     for(Menu m : menus.values())
       m.draw();
      
  }
  public Label getIntersectingLabel(float x, float y){
    Label l = null;
     
     //check if point intersects any labels 
    Iterator it = graph.getVertexSet().iterator();
    while(l==null && it.hasNext()){
      Label t = (Label)it.next(); 
      if(t.intersects(x,y)){
        l = t;
      }
    }
    it = graph.getEdgeSet().iterator();
    while(l==null && it.hasNext()){
      Label t = (Label)it.next(); 
      if(t.intersects(x,y)){
        l = t;
      }
    }
    //check menu labels if intersecting label still not found
    it = menus.values().iterator();
    while(l==null && it.hasNext()){
      Button b = ((Menu)it.next()).getIntersectingButton(x,y); 
      if(b != null){
        l = b;
      }
    }
     return l; 
  }
  
 HashMap <String, Menu> menus;
 UndirectedGraph graph;

 String selectedMenu, selectedLabel;
}