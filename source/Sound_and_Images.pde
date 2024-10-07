PImage boulderImg;
PImage arrowImg;
PImage arrowDispenserImg;
PImage froggerIdleImg;
PImage froggerJumpImg;
PImage crabImg;
PImage roadImg;
PImage smallLogImage;
PImage bigLogImage;
PImage coinImage;
PImage jetpackImage;
PImage trainSignalImage;
PImage trainSignalLightImage;
PImage flagImage;
PImage scoreTextImage;
PImage highscoreTextImage;


PImage[] smallCarImgs = new PImage[6];
PImage[] bigCarImgs = new PImage[3];
PImage[] groundTileImgs = new PImage[6];
PImage[] trainImgs = new PImage[4];
PImage[] gardenStuffImages = new PImage[9];


void LoadAllImages() {
  boulderImg = loadImage("Images/boulder.png");
  boulderImg.resize(int(pathSize*0.8), int(pathSize*0.8));

  arrowImg = loadImage("Images/arrow.png");
  arrowImg.resize(75, 20);

  arrowDispenserImg = loadImage("Images/arrowDispenser.png");
  arrowDispenserImg.resize(80, 160);

  froggerIdleImg = loadImage("Images/froggerIdle.png");
  froggerIdleImg.resize(40, 40);

  froggerJumpImg = loadImage("Images/froggerJump.png");
  froggerJumpImg.resize(100, 80);

  crabImg = loadImage("Images/crab.png");
  crabImg.resize(80, 80);
  
  roadImg = loadImage("Images/road.png");
  roadImg.resize(width, pathSize);
  
  smallLogImage = loadImage("Images/smallLog.png");
  bigLogImage = loadImage("Images/bigLog.png");
  coinImage = loadImage("Images/coin.png");
  jetpackImage = loadImage("Images/jetpack.png");
  trainSignalImage = loadImage("Images/trainSignal.png");
  trainSignalLightImage = loadImage("Images/trainSignalLight.png");
  flagImage = loadImage("Images/flag.png");
  scoreTextImage = loadImage("Images/scoreText.png");
  highscoreTextImage = loadImage("Images/highscoreText.png");
  highscoreTextImage.resize(160,60);

  for (int i=0; i<smallCarImgs.length; i++) {
    smallCarImgs[i] = loadImage("Images/car" + (i+1) + ".png");
    smallCarImgs[i].resize(160, 160);
  }

  for (int i=0; i<bigCarImgs.length; i++) {
    bigCarImgs[i] = loadImage("Images/truck" + (i+1) + ".png");
    bigCarImgs[i].resize(100, 200);
  }

  for (int i=0; i<groundTileImgs.length; i++) {
    groundTileImgs[i] = loadImage("Images/tile" + (i+1) + ".png");
    groundTileImgs[i].resize(100, 100);
  }
  
  for (int i=0; i<trainImgs.length; i++) {
    trainImgs[i] = loadImage("Images/train" + (i+1) + ".png");
    trainImgs[i].resize(1000, 80);
  }
  
  for (int i=0; i<gardenStuffImages.length; i++) {
    gardenStuffImages[i] = loadImage("Images/gardenStuff" + (i+1) + ".png");
  }
  
  imageMode(CENTER);
}

void LoadAllSounds() {
}
