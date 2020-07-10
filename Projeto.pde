import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.video.*;
import processing.sound.*;

Minim minim;
PImage texture;
Player player;
boolean right= false, left = false;
RoadManager roadManager;
BackgroundManager bgManager;
ObstacleManager obManager;
UIManager uiManager;
PImage background;
PImage mainmenu;
PVector roadBlockSize;
float roadStartPosition;
AudioPlayer ap;
int gamestate = 0;
Capture video;
PImage prevFrame;
float threshold = 150;
float sectionSize= 0;
PImage logo;

AudioIn in;
Amplitude a;

float limit = 0.25;

void setup(){
  logo = loadImage("logo.png");
  size(800, 600);  background(color(255,255,255));
  minim = new Minim(this);
  roadBlockSize = new PVector(400, 200, 0);
  roadStartPosition = width / 2 - roadBlockSize.x / 2;
  mainmenu = loadImage("mainmenu.png");
  player = new Player(loadImage("car.png"), new PVector(width/2, height-100, 0), new PVector(75,150,0), 100, minim);
  roadManager = new RoadManager(player, roadBlockSize, roadStartPosition);
  bgManager = new BackgroundManager(player);
  obManager = new ObstacleManager(player, roadManager.getRoadSize(), width/2);
  uiManager = new UIManager(player);
  background = loadImage("background.png");
  background.resize(width, height);
  frameRate(60);
  ap = minim.loadFile("song.mp3");
  ap.setGain(0);
  ap.loop();
  
  video = new Capture(this, 320, 240);
  sectionSize = video.width /3;
  video.start();
  prevFrame = createImage(video.width, video.height, RGB);
  
  in = new AudioIn(this, 0);
  a = new Amplitude(this);
  a.input(in);
}

void draw(){
  //println(frameRate);
  switch(gamestate){
    case 0:
      startscreen();
      break;
    case 1:
      maingame();
      break;
    case 2:
      endscreen();
      break;
  }
  //ALWAYS ON TOP
  textSize(14);
  textAlign(RIGHT);
  text("Paulo Fernandes, nº20767", width-10, 20);
}

void keyPressed(){
  switch(gamestate){
     case 0:
       if(key == ' '){
         gamestate = 1;
       }
       break;
     case 2:
     if(key == ' '){
       gamestate = 1;
       bgManager.reset();
       roadManager.reset();
       obManager.reset();
       player.reset();
     }
     break;
  }
  
  if(key == CODED){
    right = keyCode == RIGHT;
    left = keyCode == LEFT;
  }
}

void keyReleased(){
  if(key == CODED){
    if(keyCode == RIGHT)
      right = false;
    if(keyCode == LEFT)
      left = false;
  }
}

void maingame(){
  image(background, 0,0, width, height);
  bgManager.update();
  roadManager.update();
  obManager.update();
  player.slowDown(soundControll());
  player.speedUp();
  player.update();
  player.stir(right ? 1 : left ? -1: 0);
  uiManager.displayUI();      
  player.display();
  if(player.isDead()){
    gamestate = 2; 
  }
  
  //DRAWING CAMERA STUFF
  pushMatrix();
  translate(200, 0);
  scale(-1,1);
  image(video, 0, height-140, 200, 140);
  popMatrix();
  for(int i = 1; i < 3; i++){
    stroke(color(255,0,0));
    line(i*(200/3), height-140, i*(200/3), height);
  }
  
  //DRAWING MIC STUFF
  ellipseMode(CENTER);
  fill(255);
  noStroke();
  ellipse(700, height-75, a.analyze()*100, a.analyze() * 100);
  noFill();
  stroke(color(255, 0, 0));
  ellipse(700, height-75, limit*100, limit*100);
  stroke(0);
  ellipse(700, height-75, 100, 100);
  
  image(logo, 10, 150, 150, 52);
  textAlign(CENTER);
  textSize(14);
  text("Engenharia Informática", 85, 160 + logo.height);
}

void startscreen(){
  image(mainmenu, 0 ,0, width, height);
  textAlign(CENTER);
  textSize(64);
  text("Infinite Outrun", width/2, 200);
  textSize(22);
  text("Press [SPACE] to start!", width/2, 250);
  
  
  imageMode(CENTER);
  image(logo, width/2, 350, 150, 52);
  textAlign(CENTER);
  textSize(14);
  text("Engenharia Informática", width/2, 360 + logo.height);
  imageMode(CORNER);
}

void endscreen(){
  image(mainmenu, 0 ,0, width, height);
  textAlign(CENTER);
  textSize(64);
  text("GAMEOVER", width/2, 200);
  textSize(32);
  text("Score: "+player.getScore(), width/2, 250);
  textSize(22);
  text("Press [SPACE] to restart!", width/2, 290);
  
  imageMode(CENTER);
  image(logo, width/2, 350, 150, 52);
  textAlign(CENTER);
  textSize(14);
  text("Engenharia Informática", width/2, 360 + logo.height);
  imageMode(CORNER);
}

void cameraControll(){
  int rightMov = 0;
  int leftMov = 0;
  int noMov = 0;
  
  video.loadPixels();
  prevFrame.loadPixels();
  
  for(int x = 0; x < video.width; x++){
    for(int y = 0; y < video.height; y++){
      int loc = x+y*video.width;
      color current = video.pixels[loc];
      color previous = prevFrame.pixels[loc];
      
      float r1 = red(current);
      float g1 = green(current);
      float b1 = blue(current);
      
      float r2 = red(previous);
      float g2 = green(previous);
      float b2 = blue(previous);
      
      float dist= dist(r1,g1,b1,r2,g2,b2);
      
      if(dist > threshold){
        if(x < sectionSize){
          rightMov++; 
        }else if(x> sectionSize * 2){
          leftMov++; 
        } else{
          noMov++; 
        }
      }  
    }
  }
  if(leftMov > rightMov && leftMov > noMov){
    left = true;
    right = false;
  }else if(rightMov > leftMov && rightMov > noMov){
    right = true;
    left = false;
  }else{
    right = false;
    left = false;
  }
  
  int move = 0;
  if(leftMov > rightMov && leftMov > noMov){
    move--;
  }else if(rightMov > leftMov && rightMov > noMov){
    move++;
  }
  
  println("move: " + move);
}

void captureEvent(Capture video){
  //gravar o frame anterior para deteção de movimento
  //antes de ler o frame seguinte
  prevFrame.copy(video, 0, 0, video.width, video.height, 0,0, video.width, video.height);
  prevFrame.updatePixels();
  //ler o frame seguinte
  video.read();
  //PROCESS CAMERA CONTROLLS
  cameraControll();
}

boolean soundControll(){
  float v = a.analyze();
  return v > limit;
}
