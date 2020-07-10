public abstract class Obstacle implements IDisplayable{
  private Player player;
  private PVector position;
  private PVector size;
  private PImage image;
  private float damage;
  private int bonus;
  private PVector collisionThreshold;
  private boolean passed = false;
  
  public Obstacle(Player player, PVector position, PVector size, PImage image, float damage, int bonus){
    this.player = player;
    this.position = position;
    this.size = size;
    this.image = image;
    this.damage = damage;
    this.bonus = bonus;
    this.collisionThreshold = new PVector();
  }
  
  public Player getPlayer(){
    return this.player;
  }
  
  public PVector getPosition(){
    return this.position; 
  }
  public void setPosition(PVector position){
    this.position = position;
  }
  
  public PVector getSize(){
    return this.size;
  }
  
  public PImage getImage(){
    return this.image; 
  }
  
  
  public abstract void updatePosition();
  
  public abstract void display();
  
  protected boolean playerCheckCollision(){
    if(player.getPosition().y < this.position.y && !passed){
      player.addScore(this.bonus); 
      passed = true;
    }
    
    return(player.getPosition().x < position.x + size.x - collisionThreshold.x && 
      player.getPosition().x + player.getSize().x > position.x + collisionThreshold.x && 
      player.getPosition().y < position.y + size.y - collisionThreshold.y && 
      player.getPosition().y + player.getSize().y > position.y + collisionThreshold.y);
  }
  
  protected abstract void collisionHandler();
  
  public float getDamage(){
    return this.damage;
  }
  
  public void setCollisionThreshold(float x, float y){
    this.collisionThreshold.x = x;
    this.collisionThreshold.y = y;
  }
    
  public boolean isPassed(){
    return passed;
  }
  
}
