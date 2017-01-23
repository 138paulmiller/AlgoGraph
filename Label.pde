interface ActionInterface{
    void onClick();
  }
public class Label{
  public Label(int x,int y, int w, int h, String text, int textSize){
    this.x= x;
    this.y= y;
    this.w= w;
    this.h= h;
    this.text =  text;
    this.textSize = textSize;
    this.r = this.tr = 255;
    this.g = this.tg = 255;
    this.b = this.tb = 255;
    filled=  true;
    highlight = false;
    actionInterface = null;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.getX() == ((Label)o).getX() && 
                                       this.text == ((Label)o).getText());
  }
  public Label(Label other){
    this.x= other.x;
    this.y= other.y;
    this.w= other.w;
    this.h= other.h;
    this.text =  other.text;
    this.textSize = other.textSize;
    this.highlight = other.highlight;
    this.r = other.r;
    this.tr = other.tr;
    this.g = other.g;
    this.tg = other.tg;
    this.b = other.b;
    this.tb = other.tb;
    this.filled = other.filled;
    this.actionInterface = other.actionInterface;

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
   public void setText(String text){
     if(text != null)
     this.text= text;
   }
   public void setFilled(boolean isFilled){
      filled = isFilled; 
   }
   public void setPosition(int x, int y){
    setX(x); 
    setY(y); 
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
   public boolean isHighlighted(){
    return highlight;
  }
    public boolean intersects(float x, float y){
//Let P(x,y), and rectangle A(x1,y1),B(x2,y2),C(x3,y3),D(x4,y4)
//Calculate the sum of areas of △APD,△DPC,△CPB,△PBA△APD,△DPC,△CPB,△PBA.
  if(x < this.x || y < this.y){
    return false; 
  }else if(x > this.x+w || y > this.y+h){
    return false; 
  }
  return true;
 }
  public void setHighlight(boolean isHighlighted){
    highlight= isHighlighted;
  }
  public void setRGB(float r,float g,float b){
     this.r = r;
     this.g = g;
     this.b = b;
  }
  public void setTextRGB(float tr,float tg,float tb){
     this.tr = tr;
     this.tg = tg;
     this.tb = tb;
  }
   public void setInterface(ActionInterface actionInterface){
   this.actionInterface = actionInterface; 
  }
  public void click(){
  if(actionInterface !=  null)
     actionInterface.onClick();
  }
  public void draw(){
    
     pushMatrix();
    //render pos in eucledian space
    if(filled){
      stroke(0,0,0);  //pen stroke color black to outline button
      if(highlight){
        fill(255,255,0);     //file  rect with yellow to highlight
      }else{
        fill(r,g,b);
      }
    }
    else{
      noStroke();  
      noFill();
    }    
   rect(x,y,w,h);  
       
    //render label on top
    textSize(textSize);
    fill(tr,tg,tb);
    text(text, x+w*0.20,y+h*0.80);
    popMatrix();
  }
  float x,y,w,h,r,g,b, t,tr,tb,tg;
  String text;
  float textSize;
  boolean highlight, filled;
  ActionInterface actionInterface;

}