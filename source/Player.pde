class Player {
  PVector location;
  PVector spriteLocation;
  PVector direction;

  int scoreTrackerY;

  Player() {
    location = new PVector(width/2, height-200);
    scoreTrackerY = int(location.y);
    spriteLocation = location.copy();
    direction = new PVector(0, -1);
  }

  void display() {
    // Display the sprite (it's not at the true location of the player)
    pushMatrix();
    translate(spriteLocation.x, spriteLocation.y);
    rotate(3*HALF_PI);
    rotate(direction.heading());
    scale(2);
    if (playerIsBoosting) {
      float sinValue = sin(float(boosterDistance - boostStartY)/3160);
      scale(sinValue + 1);
      rotate(sinValue * TWO_PI);
    }
    if (PVector.dist(location, spriteLocation) < 5) {
      image(froggerIdleImg, 0, 0);
    } else {
      image(froggerJumpImg, 0, 0);
    }
    popMatrix();
  }

  void moveDown(int speed) {
    location.y += speed;
    spriteLocation.y += speed;
    scoreTrackerY += speed;
  }

  void move(int xDirection, int yDirection) {
    if (playerIsBoosting)
      return;
    // If the player were to move outside of the screen from the left or right,
    // leave the function
    if (xDirection == -1 && location.x-pathSize <= 0) {
      return;
    } else if (xDirection == 1 && location.x+pathSize >= width) {
      return;
    }

    // If the player were to move outside of the screen from top,
    // leave the function
    if (yDirection == -1 && location.y - pathSize <= 0) {
      return;
    }


    direction = new PVector(xDirection, yDirection);
    location = PVector.add(location, direction.copy().mult(pathSize));
    if (location.y < scoreTrackerY) {
      increaseScore(1);
    }
  }

  void update() {
    spriteLocation.lerp(location, 0.3);

    if (spriteLocation.y > height + 20) {
      GameState = 2;
    }

    if (spriteLocation.x < -20 || spriteLocation.x > width+2) {
      GameState = 2;
    }

    if (!playerIsBoosting) {
      // Collect coins
      for (int i=coins.size()-1; i>=0; i--) {
        PVector c = coins.get(i);

        if (PVector.dist(spriteLocation, c) <= 40) {
          increaseScore(5);
          coinScoreAlpha = 255;
          coins.remove(c);
        }
      }


      // Collect boosters
      if (!boosters.isEmpty()) {
        PVector booster = boosters.get(0);
        if (PVector.dist(spriteLocation, booster) <= 50) {
          playerIsBoosting = true;
          boostStartY = int(location.y);
          boosterDistance = boostStartY;
          boosters.remove(booster);
        }
      }
    }
    if (spriteLocation.y < scoreTrackerY) {
      scoreTrackerY = int(spriteLocation.y);
    }
  }
}
