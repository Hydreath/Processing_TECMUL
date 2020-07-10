public class UIManager{
  Player player;
  PImage points;
  PImage life;
  
  public UIManager(Player player){
    this.player = player; 
    points = loadImage("points.png");
    life = loadImage("life.png");
  }
  
  public void displayUI(){
    rectMode(CORNER);
    fill(color(0, 0, 36));
    rect(57, 53, 130, 18);
    float d = map(player.getCurrentHP(), 0, player.getInitialHP(), 0, 130);
    rectMode(CORNER);
    fill(color(217, 153, 215));
    rect(57, 53, (d<0?0:d), 18);
    image(life, 10, 40, 180, 60);
    
    image(points, width-points.width - 50, 20, 100, 100);
    textSize(24);
    fill(255);
    textAlign(CENTER);
    text(player.getScore(), width - points.width / 2 -45, 100);
  }
  
}
