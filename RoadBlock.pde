public class RoadBlock implements IDisplayable, IPoolable{
  PImage texture;
  PVector position;
  PVector size;
  
  public RoadBlock(){
    texture = loadImage("road.png");
  }
  
  public RoadBlock(PImage texture, PVector position, PVector size){
     this.size = size;
     this.position = position;
     this.texture = texture;
  }
  
  public void display(){
    image(texture, position.x, position.y, size.x, size.y);
  }  
  
  public void updatePosition(float currentSpeed){
    this.position.y += currentSpeed/frameRate;
  }

  
  public PVector getSize(){
    return this.size;
  }
  
  public PVector getPosition(){
    return this.position; 
  }
  
  public void setSize(PVector size){
    this.size = size; 
  }
  
  public void setPosition(PVector pos){
    this.position = pos;
  }
}
