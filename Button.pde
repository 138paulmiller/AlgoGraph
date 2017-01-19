class Button{
  public Button(float x,float y, float w, float h,String text){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
    this.textSize = h*0.75;
    highlight = false;
    r = 0;
    g= 200; 
    b = 200;
  }
  public Button(Button other){
    this.x = other.x;
    this.y = other.y;
    this.w = other.w;
    this.h = other.h;
    this.text = other.text;
    this.r = other.r;
    this.b = other.b;
    this.g = other.g;
    this.highlight = other.highlight;

  }
  public boolean isHighlighted(){
    return highlight;
  }
    
  public void setHighlight(boolean isHighlighted){
    highlight= isHighlighted;
  }
  public void setRGB(float r,float g,float b){
     this.r = r;
     this.g = g;
     this.b = b;
  }
  public void draw(){
    pushMatrix();
    
    //render pos in eucledian space
    stroke(r,g,b);  //pen stroke color color bgr
    if(highlight){
      stroke(g,b,g);     //file  rect with swapped color to highlight
      fill(g,b,g);     //file  rect with swapped color to highlight
    }else{
      stroke(r,g,b);
      fill(r,g,b);
    }//file  rect with same color
    rect(x,y,w,h);
    
    //render label on top
   textSize(textSize);
    fill(245, 230,240); //nearly white text 
    text(text, x+w*0.30,y+h*0.80);
        popMatrix();

  }
  public boolean intersects(float x, float y){
    //if vertex ellipse is within clickable range ( if abs(dist) between this(x,y) and (x,y) < radius then (x,y) in e       
    if(sqrt(pow(this.x-x,2) + pow(this.y-y,2))< sqrt(pow(w,2) + pow(h,2))){
      return true;
    }
      return false;  

 }
 public String getText(){
   return text;
 }
 public float getTextSize(){
   return textSize;
 }
 public float getX(){
   return x;
 }
 public float getY(){
   return y;
 }
 public float getW(){
   return w;
 }
 public float getH(){
   return h;
 }
 public void setX(float x ){
   this.x = x;
 }
 public void setY(float y){
   this.y = y;
 }
 public void setW(float w){
   this.w = w;
 }
 public void setH(float h){
   this.h = h;
 }
  float x,y,w,h,r,g,b;
  String text;
  float textSize;
  boolean highlight;
}