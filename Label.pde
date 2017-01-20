class Label{
  public Label(int x,int y, int w, int h, int r, int g, int b,  String text, int textSize){
    this.x= x;
    this.y= y;
    this.w= w;
    this.h= h;
    this.r= r;
    this.g= g;
    this.b= b;
    this.text =  text;
  this.textSize = textSize;
  highlight = false;
  }
  @Override public boolean equals(Object o) {
      return (o instanceof Vertex) && (this.getX() == ((Label)o).getX() && 
                                       this.text == ((Label)o).getText());
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
  public void draw(){
   pushMatrix();
    
    //render pos in eucledian space
    stroke(0,0,0);  //pen stroke color black to outline button
    if(highlight){
      fill(g,b,g);     //file  rect with swapped color to highlight
    }else{
      fill(r,g,b);
    }//file  rect with same color
    //offset to center
    rect(x,y,w,h);
    
    //render label on top
    textSize(textSize);
    fill(2, 2,0); //nearly black text 
    text(text, x+w*0.20,y+h*0.80);
    popMatrix();
  }
  float x,y,w,h,r,g,b;
  String text;
  float textSize;
  boolean highlight;
}