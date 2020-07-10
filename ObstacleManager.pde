public class ObstacleManager{
  private Lane[] lanes;
  private Player player;
  private float spawnChance = 0.2;
  private Obstacle next;
  private ArrayList<Obstacle> obstacles;
  private float offCenter = 30;
  private float timeToSpawn = 1;
  private float lastSpawn = 0;
  
  public ObstacleManager(Player player, PVector roadSize, float position){
    lanes = new Lane[3];
    lanes[0] = new Lane(new PVector(position-roadSize.x/4-offCenter, 0,0));
    lanes[1] = new Lane(new PVector(position, 0, 0));
    lanes[2] = new Lane(new PVector(position+roadSize.x/4+offCenter, 0,0));
    obstacles = new ArrayList<Obstacle>();
    this.player = player;
  }
  
  public void update(){
    if(willSpawn() && next == null && millis() - lastSpawn > timeToSpawn *1000){
      next = createObstacle();
      lastSpawn = millis();
    }
    
    
    if(next != null){
      ArrayList<Lane> spawnable = canSpawn();
      if(!spawnable.isEmpty()){
        spawnable.get((int)random(spawnable.size())).setupObstacle(next);
        obstacles.add(next);
        next = null;
      }
    }
    
    for(Lane lane:lanes){
      lane.update(); 
    }
    
  }

  
  private boolean willSpawn(){
    return random(1) > spawnChance;
  }
  
  private Obstacle createObstacle(){
    switch((int)random(2)){
      case 0:
        return new Car(player, new PVector(0,0,0), new PVector(75,150,0), loadImage("truck.png"), 300, 1000);
      case 1:
        return new Bike(player, new PVector(0,0,0), new PVector(50,80,0), loadImage("bike.png"), 200, 1000);
      default:
        return new Car(player, new PVector(0,0,0), new PVector(75,150,0), loadImage("truck.png"), 300, 1000);
    }
  }
  
  private ArrayList<Lane> canSpawn(){
    ArrayList<Lane> s = new ArrayList<Lane>();
    for(Lane l:lanes){
      boolean canSpawn = true;
        for(Obstacle o:obstacles){
          if(dist(l.getPosition().x, l.getPosition().y, o.getPosition().x, o.getPosition().y) < l.getMinDistance()){
            canSpawn = false;
            break;
          }
        }
        if(canSpawn)
          s.add(l);
      }
    return s;
  }
  
  public void reset(){
    obstacles.clear();
    for(Lane l:lanes){
      l.reset();
    }
  }
}
