public class RoadManager{                  
  private Pool<RoadBlock> pool;
  private RoadBlock top;
  private ArrayList<RoadBlock> blocks;
  private float spawnThreshold = 0;
  private PVector size = new PVector(400, 200, 0);
  private float startPosition = 0;
  private Player player;
  
  public RoadManager(Player player, PVector blockSize, float startPosition){
    spawnThreshold = size.y;
    pool = new Pool<RoadBlock>();
    blocks = new ArrayList<RoadBlock>();
    this.startPosition = startPosition;
    this.player = player;
    this.size = blockSize;
  }
  
  public void update(){ 
    if(needSpawn()){
      spawn(); 
    }
    int s = blocks.size();
    for(int i = 0; i < blocks.size(); i++){
      RoadBlock rb = blocks.get(i);
      rb.updatePosition(player.getSpeed());
      rb.display();
      if(checkBounds(rb)){
        removeBlock(rb);
      }
    }
    
    for(int i = 0; i < blocks.size(); i++){
      RoadBlock rb = blocks.get(i);
      rb.display();
    }
    
    //println(blocks.size());
  }
  
  
  private boolean needSpawn(){
    if(blocks.isEmpty())
      return true;
    if(top.getPosition().y > -spawnThreshold)
      return true;
    return false;
  }
  
  private void spawn(){
    RoadBlock rb=null;
    try{
      rb = (RoadBlock)pool.get();
    }catch(Exception e){
      rb = (RoadBlock)pool.addAndRetrieveObject(new RoadBlock());
    }
    rb = setupBlock(rb);
    top = rb;
    blocks.add(rb);
  }
  
  private RoadBlock setupBlock(RoadBlock rb){
    rb.setSize(size);
    float y = 0;
    if(top == null){
      y = height;
    }else{
      y = top.getPosition().y - rb.getSize().y;
    }
    rb.setPosition(new PVector(startPosition, y, 0));
    return rb;
  }
  
  private boolean checkBounds(RoadBlock rb){
    return rb.getPosition().y > height + spawnThreshold;
  }
  
  private boolean removeBlock(RoadBlock rb){
    boolean b = blocks.remove(rb);
    pool.release(rb);
    return b;
  }
  
  public PVector getRoadSize(){
    return size; 
  }
  
  public float getRoadStart(){
    return startPosition;
  }
  
  public void reset(){
    top = null;
    for(int i = 0; i < blocks.size(); i++){
      RoadBlock rb = blocks.get(i);
      if(removeBlock(rb)){
        i--;
      }
    }
    blocks.clear();
  }
}
