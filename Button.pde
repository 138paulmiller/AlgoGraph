class Button{
  public Button(int x,int y, int w, int h,String text, int textSize){
    this.label = new Label( x,y, w, h, 0, 200,200, text,  textSize);
  }
  public Button(Button other){
    this.label = other.label;
  }
  
  public void draw(){
    label.draw();

  }
 public Label getLabel(){
   return label;
 }
 
  Label label;
}