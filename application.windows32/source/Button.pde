interface ButtonInterface{
    void onClick();
  }
class Button{
  
  public Button(int x,int y, int w, int h,String text, int textSize){
    this.label = new Label( x,y, w, h, 0, 200,200, text,  textSize);
    actionInterface = null;
  }
  public Button(Button other){
    this.label = other.label;
    this.actionInterface = other.actionInterface;
  }
  public void setInterface(ButtonInterface actionInterface){
   this.actionInterface = actionInterface; 
  }
  public void draw(){
    label.draw();

  }
 public Label getLabel(){
   return label;
 }
 public void click(){
   if(actionInterface !=  null)
     actionInterface.onClick();
 }
 ButtonInterface actionInterface;
  Label label;
}