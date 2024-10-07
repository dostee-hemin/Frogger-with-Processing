class Spawner {
  ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

  float yLocation;
  int spawnRate;
  int currentTime;
  int movementDirection;
  int movementSpeed;
  
  Spawner(float yLocation) {
    this.yLocation = yLocation;

    currentTime = floor(random(100));

    // Give the spawner a random direction
    movementDirection = 1;
    if (random(1) < 0.5) {
      movementDirection = -1;
    }
  }

  void quickUpdate() {
    for (int i=0; i<200; i++) {
      update();
    }
  }


  void display() {
    for (Obstacle o : obstacles) {
      o.display();
    }
  }

  void spawnObstacles() {
    println("Error! " + this + " is spawning obstacles from parent class");
  }


  void update() {
    currentTime++;
    if (currentTime % spawnRate == 0) {
      spawnObstacles();
      currentTime = 0;
    }

    for (int i=obstacles.size()-1; i>=0; i--) {
      Obstacle o = obstacles.get(i);
      o.update();

      if (o.isFinished()) {
        obstacles.remove(o);
      }
    }
  }

  void checkCollisions() {
    if (player.location.y < yLocation+pathSize/2 && player.location.y > yLocation-pathSize/2) {
      for (Obstacle o : obstacles) {
        if (o.hitsPlayer()) {
          GameState = 2;
        }
      }
    }
  }

  void moveDown(int speed) {
    yLocation += speed;
    for (Obstacle o : obstacles) {
      o.moveDown(speed);
    }
  }

  boolean goesOffscreen() {
    return yLocation > height + pathSize/2 + 100;
  }
  
  boolean containsPlayer() {
    return player.location.y < yLocation + pathSize/2 &&
      player.location.y > yLocation - pathSize/2;
  }
}


class ArrowTrap extends Spawner {
  ArrowTrap(float yLocation) {
    super(yLocation);

    spawnRate = floor(random(65, 150));
  }

  void display() {
    imageMode(CENTER);
    for(int x=50; x<width; x+=100) {
      image(groundTileImgs[3], x, yLocation);
    }
    
    super.display();
    
    pushMatrix();
    image(arrowDispenserImg, width-10, yLocation-50);
    translate(10,yLocation-50);
    scale(-1,1);
    image(arrowDispenserImg, 0, 0);
    popMatrix();
  }

  void spawnObstacles() {
    obstacles.add(new Arrow(-50, yLocation, 1));
    obstacles.add(new Arrow(width+50, yLocation, -1));
  }
}

class CrabSpawner extends Spawner {
  CrabSpawner(float yLocation) {
    super(yLocation);

    movementSpeed = floor(random(3, 6));
    spawnRate = 150 - (movementSpeed-2) * 20;
  }

  void display() {
    imageMode(CENTER);
    for(int x=50; x<width; x+=100) {
      image(groundTileImgs[1], x, yLocation);
    }

    super.display();
  }

  void spawnObstacles() {
    float startX = -50;
    if (movementDirection == -1) {
      startX = width + 50;
    }
    obstacles.add(new Crab(startX, yLocation, movementDirection, movementSpeed));
  }
}

class River extends Spawner {
  River(float yLocation, int movementSpeed) {
    super(yLocation);

    this.movementSpeed = movementSpeed;
    spawnRate = 100 - (movementSpeed-2) * 10;
  }

  void display() {
    imageMode(CENTER);
    for(int x=50; x<width; x+=100) {
      image(groundTileImgs[4], x, yLocation);
    }

    super.display();
  }

  void spawnObstacles() {
    float startX = -150;
    if (movementDirection == -1) {
      startX = width + 150;
    }
    obstacles.add(new Log(startX, yLocation, movementDirection, movementSpeed));
  }

  void checkCollisions() {
    if (player.location.y < yLocation+pathSize/2 && player.location.y > yLocation-pathSize/2) {      
      boolean hitsPlayer = false;
      for (Obstacle o : obstacles) {
        if (o.hitsPlayer()) {
          hitsPlayer = true;
        }
      }

      if (hitsPlayer) {
        player.location.y = yLocation;
        player.location.x += movementSpeed * movementDirection;
        player.spriteLocation.x += movementSpeed * movementDirection;
      } else {
        GameState = 2;
      }
    }
  }
}

class BoulderSpawner extends Spawner {
  BoulderSpawner(float yLocation) {
    super(yLocation);

    movementSpeed = floor(random(4, 8));
    spawnRate = 150 - (movementSpeed-2) * 15;
  }

  void display() {
    imageMode(CENTER);
    for(int x=50; x<width; x+=100) {
      image(groundTileImgs[2], x, yLocation);
    }

    super.display();
  }

  void spawnObstacles() {
    float startX = -pathSize*0.8;
    if (movementDirection == -1) {
      startX = width + pathSize*0.8;
    }
    obstacles.add(new Boulder(startX, yLocation, movementDirection, movementSpeed));
  }
}


class Road extends Spawner {
  int roadStartX;
  Road(float yLocation) {
    super(yLocation);

    movementSpeed = floor(random(3, 8));
    spawnRate = 150 - (movementSpeed-2) * 10;

    roadStartX = floor(random(200)) * -1;
  }

  void display() {
    imageMode(CENTER);
    image(roadImg, width/2, yLocation);

    super.display();
  }

  void spawnObstacles() {
    float startX = -150;
    if (movementDirection == -1) {
      startX = width + 150;
    }
    obstacles.add(new Car(startX, yLocation, movementDirection, movementSpeed));
  }
}


class TrainTrack extends Spawner {
  TrainTrack(float yLocation) {
    super(yLocation);

    spawnRate = floor(random(150, 300));
  }

  void display() {
    imageMode(CENTER);
    for(int x=50; x<width; x+=100) {
      image(groundTileImgs[5], x, yLocation);
    }
    
    super.display();


    image(trainSignalImage,50,yLocation-40);
    noStroke();
    if (currentTime > spawnRate * 0.8) {
      if (floor(float(frameCount)/5) % 2 == 0) {
        image(trainSignalLightImage, 30, yLocation-16);
      } else {
        image(trainSignalLightImage, 80, yLocation-16);
      }
    }
  }

  void spawnObstacles() {
    float startX = -width/1.5;
    if (movementDirection == -1) {
      startX = width + width/1.5;
    }
    obstacles.add(new Train(startX, yLocation, movementDirection));
  }
}
