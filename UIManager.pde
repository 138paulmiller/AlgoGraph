import java.util.HashMap;
class UIManager{
  public UIManager(){
  menus = new HashMap <String, Menu>();
  vertices = new HashMap <String, Vertex>();
    edges = new HashMap <String, Edge>();

  }
  public void addMenu(String id, int w, int h){
   menus.put(id,new Menu(w,h));    
  }
  public void addMenuButton(String menuId, String buttonId, ActionInterface actionInterface){
   getMenu(menuId).addButton(buttonId, actionInterface);  
  }
  public void addLabel(String id, Label l){
    if(l != null)
    if(l instanceof Vertex)
       vertices.put(id, (Vertex)l);  
    else if(l instanceof Edge)
       edges.put(id, (Edge)l); 
  }
  public void setLabelInterface(String id, ActionInterface actionInterface){
   Label l = vertices.get(id);
   if(l== null)
     l = edges.get(id);
   if(l != null)
     l.setInterface(actionInterface);  
  }
  public Menu getMenu(String id){
    return menus.get(id); 
  }
  public void draw(){
    for(Edge e : edges.values())
       e.draw();
    for(Vertex v : vertices.values())
       v.draw();
     for(Menu m : menus.values())
       m.draw();
      
  }
  public Label getIntersectingLabel(float x, float y){
    Label l = null;
     
     //check if point intersects any labels 
    Iterator it = vertices.values().iterator();
    while(l==null && it.hasNext()){
      Label t = (Label)it.next(); 
      if(t.intersects(x,y)){
        l = t;
      }
    }
    it = edges.values().iterator();
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
 HashMap <String, Edge> edges;
  HashMap <String, Vertex> vertices;

 String selectedMenu, selectedLabel;
}