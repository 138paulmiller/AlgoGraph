import java.util.HashMap;
class UIManager{
  UIManager(){
  menus = new HashMap <String, Menu>();
  labels = new HashMap <String, Label>();
}
 HashMap <String, Menu> menus;
 HashMap <String, Label> labels;
 String selectedMenu, selectedLabel;
}