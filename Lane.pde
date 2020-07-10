public class Lane{
  private PVector position;
  private ArrayList<Obstacle> obstacles;
  private float minDistance = 100;
  
  public Lane(PVector position){
    this.position = position;
    this.obstacles = new ArrayList<Obstacle>();
  }
  
  //main function
  public void update(){
    for(int i = 0; i < obstacles.size(); i++){
      Obstacle o = obstacles.get(i);
      o.updatePosition();
      if(o.getPosition().y > height + o.getSize().y/2)
        despawn(o);
    }
    
    for(int i = 0; i < obstacles.size(); i++){
      Obstacle o = obstacles.get(i);
      o.collisionHandler();
      o.display();
    }
  }
  
  private void despawn(Obstacle obstacle){
    obstacles.remove(obstacle); 
  }
  
  public void setupObstacle(Obstacle obstacle){
    obstacle.setPosition(new PVector(position.x, -obstacle.getSize().y, 0));
    obstacles.add(obstacle);
  }
  
  public PVector getPosition(){
    return position; 
  }
  
  public float getMinDistance(){
    return this.minDistance; 
  }
  
  public void reset(){
    obstacles.clear();
  }
}
