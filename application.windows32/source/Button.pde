
class Button extends Label{
  
  public Button(int x,int y, int w, int h,String text, int textSize){
    super( x,y, w, h,  text,  textSize);
    setTextRGB( 10, 20,0);

  }
  public Button(Button other){
    super(other);
  }
}