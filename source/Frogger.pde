Player player;
ArrayList<Spawner> spawners = new ArrayList<Spawner>();
ArrayList<PVector> coins = new ArrayList<PVector>();
ArrayList<PVector> boosters = new ArrayList<PVector>();


int boosterDistance;
int boostStartY;
int spaceBetweenPaths = floor(random(2, 5));
int pathSize = 100;
int score;
int highscore;
int coinScoreAlpha;
int GameState;
int grassTileY;

PFont streetCredFont;

boolean playerIsBoosting;

void setup() {
  size(700, 800);

  grassTileY = height-50;

  LoadAllImages();
  LoadAllSounds();

  player = new Player();
  createNextSpawner(100);

  try {
    highscore = int(loadStrings("HIGHSCORE.txt")[0]);
  } 
  catch (NullPointerException e) {
    highscore = 0;
  }

  streetCredFont = createFont("street cred.ttf", 96);
  textFont(streetCredFont);
}

void draw() {
  // Background (grass)
  imageMode(CENTER);
  for (int y=grassTileY; y>-50; y-=100) {
    for (int x=50; x<width; x+=100) {
      image(groundTileImgs[0], x, y);
    }
  }

  switch(GameState) {
  case 0:
    player.display();

    if (floor(float(frameCount)/20) % 2 == 0) {
      fill(255, 0, 0);
    } else {
      fill(100, 0, 0);
    }
    textSize(70);
    textAlign(CENTER);
    text("Press 'UP'", width/2, height/2);
    break;
  case 1:
    moveWorldDown();
    player.update();

    for (int i=spawners.size()-1; i>=0; i--) {
      Spawner s = spawners.get(i);

      s.update();
      if (!playerIsBoosting) {
        s.checkCollisions();
      }

      if (s.goesOffscreen()) {
        spawners.remove(s);
      }
    }

    for (int i=boosters.size()-1; i>=0; i--) {
      PVector b = boosters.get(i);

      if (b.y > height + 25) {
        boosters.remove(b);
      }
    }

    for (int i=coins.size()-1; i>=0; i--) {
      PVector c = coins.get(i);

      if (c.y > height + 25) {
        coins.remove(c);
      }
    }

    DisplayEverything();

    Spawner topMostSpawner = spawners.get(0);
    for (Spawner s : spawners) {
      if (s.yLocation < topMostSpawner.yLocation) {
        topMostSpawner = s;
      }
    }
    if (topMostSpawner.yLocation >= pathSize*spaceBetweenPaths) {
      float topPathY = topMostSpawner.yLocation;
      int startY = 100 - floor(topPathY - pathSize*spaceBetweenPaths);
      spaceBetweenPaths = floor(random(2, 5));
      createNextSpawner(startY);
    }


    if (playerIsBoosting) {
      if ((boosterDistance-boostStartY)/ pathSize >= 100) {
        for (Spawner s : spawners) {
          if (s.containsPlayer()) {
            return;
          }
        }
        playerIsBoosting = false;
      }
    }
    break;
  case 2:
    DisplayEverything();

    if (floor(float(frameCount)/20) % 2 == 0) {
      fill(255, 0, 0);
    } else {
      fill(100, 0, 0);
    }
    textSize(80);
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2);
    text("Press 'r' to retry", width/2, height/2+100);
    break;
  }
}

void moveWorldDown() {
  int speed = 2;
  if (player.location.y < 300) {
    speed = 5;
  }

  if (playerIsBoosting) {
    speed = pathSize;
    boosterDistance += speed;
    if ((boosterDistance-boostStartY) % pathSize == 0) {
      increaseScore(1);
    }
  } else {
    player.moveDown(speed);
  }
  for (Spawner s : spawners) {
    s.moveDown(speed);
  }

  for (PVector b : boosters) {
    b.y += speed;
  }

  for (PVector c : coins) {
    c.y += speed;
  }

  grassTileY += speed;
  if (grassTileY >= height+50) {
    grassTileY = height-50;
  }
}


void DisplayEverything() {
  for (Spawner s : spawners) {
    s.display();
  }
  for (int i=0; i<boosters.size(); i++) {
    PVector b = boosters.get(i);
    pushMatrix();
    translate(b.x, b.y);
    float angle = float(frameCount)/10 + i*2;
    rotate(sin(0.3*angle)*cos(4*angle) * PI/5);
    image(jetpackImage, 0, 0);
    popMatrix();
  }
  for (int i=0; i<coins.size(); i++) {
    PVector c = coins.get(i);
    pushMatrix();
    translate(c.x, c.y);
    scale(sin((float(frameCount)/10)+i)* 0.25 + 1.25);
    image(coinImage, 0, 0);
    popMatrix();
  }

  player.display();

  // Score
  rectMode(CENTER);
  fill(0);
  stroke(255, 0, 0);
  strokeWeight(3);
  rect(width/2, 47, 205, 55, 7);
  rect(width/2, 100, 165, 45, 7);
  image(scoreTextImage, width/2, 50);
  textSize(47);
  textAlign(CENTER);
  fill(250, 225, 75);
  text(score, width/2, 115);

  // Highscore
  fill(0);
  rect(width-100, 100, 165, 65, 7);
  rect(width-100, 155, 135, 45, 7);
  image(highscoreTextImage, width-100, 100);
  fill(250, 225, 75);
  textSize(40);
  text(highscore, width-100, 167);

  // "+5" text for coins
  textSize(40);
  fill(250, 200, 60, coinScoreAlpha);
  text("+5", width/2 + 60, 107);
  if (coinScoreAlpha > 0) {
    coinScoreAlpha -= 5;
  }

  // Player's score tracker
  image(flagImage, 25, player.scoreTrackerY);
}

void createNextSpawner(int startY) {
  int n = floor(random(1, 7));
  int numberOfSpawners = floor(random(1, 5));
  switch(n) {
  case 1:
    for (int i=0; i<numberOfSpawners; i++) {
      spawners.add(new ArrowTrap(-startY - (numberOfSpawners-1)*pathSize + i*pathSize));
    }
    break;
  case 2:
    for (int i=0; i<numberOfSpawners; i++) {
      spawners.add(new CrabSpawner(-startY - i*pathSize));
    }
    break;
  case 3:
    int previousMovementSpeed = 0;
    for (int i=0; i<numberOfSpawners; i++) {
      int movementSpeed = floor(random(3, 7));
      if (i != 0) {
        while (abs(previousMovementSpeed-movementSpeed) < 2) {
          movementSpeed = floor(random(3, 7));
        }
      }
      spawners.add(new River(-startY - i*pathSize, movementSpeed));
      previousMovementSpeed = movementSpeed;
    }
    break;
  case 4:
    for (int i=0; i<numberOfSpawners; i++) {
      spawners.add(new BoulderSpawner(-startY - i*pathSize));
    }
    break;
  case 5:
    for (int i=0; i<numberOfSpawners; i++) {
      spawners.add(new Road(-startY - i*pathSize));
    }
    break;
  case 6:
    for (int i=0; i<numberOfSpawners; i++) {
      spawners.add(new TrainTrack(-startY - i*pathSize));
    }
    break;
  }


  for (int i=spawners.size()-1; i>=spawners.size() - numberOfSpawners; i--) {
    spawners.get(i).quickUpdate();
  }

  if (random(1) < 0.5) {
    int numberOfCoins = floor(random(1, numberOfSpawners));
    for (int i=0; i<numberOfCoins; i++) {
      coins.add(getPossibleLocation(numberOfSpawners));
    }
  }
  if (random(1) < 0.1 && !playerIsBoosting) {
    boosters.add(getPossibleLocation(numberOfSpawners));
  }
}

void increaseScore(int amount) {
  // Increase the score by the given amount and check if it's a new highscore
  score += amount;
  if (score > highscore) {
    highscore = score;
    String[] s = {str(highscore)};
    saveStrings("HIGHSCORE.txt", s);
  }
}


PVector getPossibleLocation(int numberOfSpawners) {
  float x = random(pathSize*2, width - pathSize*2);
  int chosenIndex = floor(random(numberOfSpawners));
  Spawner chosenSpawner = spawners.get(spawners.size()-chosenIndex-1);
  float y = chosenSpawner.yLocation;
  return new PVector(x, y);
}
