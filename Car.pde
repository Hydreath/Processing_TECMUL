public class Car extends Obstacle{

  public Car(Player player, PVector position, PVector size, PImage image, float damage, int bonus){
    super(player, position, size, image, damage, bonus);
    super.setCollisionThreshold(20,30);
  }
  
  public void display(){
    imageMode(CENTER);
    image(this.getImage(), getPosition().x, getPosition().y, getSize().x, getSize().y);
    imageMode(CORNER);
  }
  
  public void updatePosition(){
    this.getPosition().y += this.getPlayer().getSpeed()/frameRate;
  }
  
  protected void collisionHandler(){
    if(super.playerCheckCollision()){
      player.collisionDetected(this, this.getDamage());
    }
  }
}
