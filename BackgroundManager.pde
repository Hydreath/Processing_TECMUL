public class BackgroundManager{
  private ArrayList<GridLine> grid;
  private GridLine lastSpawn;
  private float blockSize = 20;
  private Player player;
  private Pool<GridLine> pool;
  
  public BackgroundManager(Player player){
    pool = new Pool<GridLine>();
    grid = new ArrayList<GridLine>();
    this.player = player;
  }
  
  public void update(){
    while(lastSpawn == null || lastSpawn.getY() + player.getSpeed() / frameRate > 0)
      spawn();
      
    for(int i = 0; i < grid.size(); i++) {
      GridLine line = grid.get(i);
      line.updatePosition(player.getSpeed());
      if(checkBounds(line)){
        despawn(line); 
      }
    }
    
    for(int i = 0; i < grid.size(); i++) {
      GridLine line = grid.get(i);
      line.display();
    }
  }
  
  private void spawn(){
    GridLine line = null;
    float y = 0;
    if(lastSpawn == null)
      y = height;
    else
      y = lastSpawn.getY() - blockSize ;    
    try{
      line = pool.get();
    }catch(Exception e){
      line = pool.addAndRetrieveObject(new GridLine(blockSize, y));
    };
    line.setY(y);
    grid.add(line);
    lastSpawn = line;
  }
  
  private boolean checkBounds(GridLine line){
    return line.getY() > height; 
  }
  
  private boolean despawn(GridLine line){
    pool.release(line);
    return grid.remove(line);
  }
  
  public void reset(){
    lastSpawn = null;
    for(int i = 0; i < grid.size(); i++){
      if(despawn(grid.get(i))){
        i--; 
      }
    }
  }
}
