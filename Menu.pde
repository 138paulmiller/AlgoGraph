import java.util.LinkedList;
class Menu{
  public Menu(float w, float h){
    buttons = new LinkedList<Button>();
     this.x=  0;
     this.y = 0;
     this.w = w;
     this.h = h;
     hide();
  }
  void hide(){
     visible = false;
  }
  void open(){
     visible = true;
  }
  boolean isOpen(){
    return visible;
  }
  void setPosition(float x,float y){
    this.x = x;
    this.y = y;
    int i = 0;
    for(Button b : buttons){ //update button position
       b.setX(x);
       b.setY(y+(h*i++));
     }
  }
  void addButton(String label){
    int count = buttons.size();
    buttons.addLast(new Button(x,y+(h*count),w,h, label, 18));
    buttons.getLast().setRGB(red,green,blue);
  }
  Button getIntersectingButton(float x, float y){
    for(Button b : buttons){
      if(b.intersects(x,y)){
         return b; //return vertex 
      }
    }
  return null;
  }
  void draw(){
    if(isOpen()){
      for(Button b : buttons){
         b.draw();
       }
    }
    
  }
  float x,y, w,h;
  LinkedList<Button> buttons;
  boolean visible;
}