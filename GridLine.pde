public class GridLine implements IPoolable{
  private float y;
  private float blockSize;
  
  public GridLine(float blockSize, float position){
    y = position;
    this.blockSize = blockSize;
  }
  
  //add Player
  public void display(){
    /*
    for(int i = 0; i <= width/blockSize; i++){
      noFill();
      stroke(generateColor(y));
      rect(i* blockSize, y, blockSize, blockSize);
      noStroke();
    }
    */
    stroke(generateColor(y));
    line(0, y, width, y);
  }
    
  public void updatePosition(float posY){
    y+= posY/frameRate; 
  }
  
  private color generateColor(float y){
    float r = map(y, 0, height, 255, 45);
    float b = map(y, 0, height, 56, 226);
    float g = map(y, 0, height, 100, 230);
    return color(r, g, b);
  }
  
  public float getY(){
    return y; 
  }
  
  public void setY(float y){
    this.y = y; 
  }
}
