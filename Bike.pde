public class Bike extends Obstacle{
  
  public Bike(Player player, PVector position, PVector size, PImage image, float damage, int bonus){
    super(player, position, size, image, damage, bonus);
    super.setCollisionThreshold(10,40);
  }
  
  public void display(){
    imageMode(CENTER);
    image(this.getImage(), getPosition().x, getPosition().y, getSize().x, getSize().y);
    imageMode(CORNER);
  }
  
  public void updatePosition(){
    this.getPosition().y += this.getPlayer().getSpeed() * 0.8/frameRate;
    this.getPosition().x += cos(radians(millis())) *25/ (frameRate * 2);
  }
  
  protected void collisionHandler(){
    if(super.playerCheckCollision()){
      player.collisionDetected(this, this.getDamage());
    }
  }
  
}
