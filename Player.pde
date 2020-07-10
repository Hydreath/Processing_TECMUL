public class Player{
  private float currentSpeed;
  private float maxSpeed = 2000;
  private float initialSpeed;
  private PVector position;
  private PVector size;
  private PImage image;
  private float stirSpeed = 300;
  private float turn = 0;
  private float turnRadius = radians(5);
  private float currentHP = 1000;
  private float initialHP = 1000;
  private boolean isDead = false;
  private boolean canTakeDamage = true;
  private float lastTimeSinceDamage = 0;
  private float invinsibleTime = 1;
  private int score = 0;
  private Minim minim;
  private AudioPlayer ap;
  private boolean slowMode;

  
  
  public Player(PImage image, PVector inicialPos, PVector size, float inicialSpeed, Minim minim){
    this.currentSpeed = inicialSpeed;
    this.initialSpeed = inicialSpeed;
    this.position = inicialPos;
    this.image = image;
    this.size = size;
    image.resize((int)size.x, (int)size.y);
    currentHP = initialHP;
    this.minim = minim;
    ap = minim.loadFile("motor.wav");
    //ap.loop();
  }
  
  //TEST VALUES
  public void display(){
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(turn*turnRadius);
    image(image, 0, 0, size.x, size.y);
    popMatrix();
    imageMode(CORNER);
  }
  
  public void stir(float position){
    turn = position;
    this.position.x += position * stirSpeed / frameRate;
  }
  
  public void speedUp(){
    if(currentSpeed < maxSpeed)
      currentSpeed += 20/frameRate;
  }
  
  public float getSpeed(){
    return this.currentSpeed * (slowMode ? 0.5 : 1); 
  }
  
  public PVector getPosition(){
    return this.position; 
  }
  
  public PVector getSize(){
    return this.size;
  }
  
  public void collisionDetected(Obstacle ob, float dmg){
    if(canTakeDamage){
      //println("Collision");
      lastTimeSinceDamage = millis();
      canTakeDamage = false;
      currentHP -= dmg;
    }
  }
  
  public void update(){
    if(isDead()){
      currentSpeed = 0;
      ap.pause();
    }
    if(!canTakeDamage && millis() - lastTimeSinceDamage >= invinsibleTime * 1000){
      canTakeDamage = true;
    }
    if(position.x > width-image.width/2)
      position.x = width-image.width/2;
    if(position.x < image.width/2)
      position.x = image.width/2;
      
    if(position.x < 200 || position.x > 600 ){
      currentHP -= 50/frameRate;  
    }
  }
    
  public boolean isDead(){
    isDead = currentHP <= 0;
    return isDead;
  }
  
  public void addScore(int add){
    score += add; 
  }
  
  private void passiveScore(){
    score += round(millis() %1000);
  }
  
  public int getScore(){
    return this.score; 
  }
  
  public float getCurrentHP(){
    return this.currentHP;
  }
  
  public float getInitialHP(){
    return this.initialHP; 
  }
  
  public void reset(){
    currentHP = initialHP;
    score = 0;
    currentSpeed = initialSpeed;
    isDead = false;
  }
  
  public void slowDown(boolean state){
    this.slowMode = state; 
  }
}
