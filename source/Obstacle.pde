class Obstacle {
  PVector location;
  int obstacleSize;
  int direction;
  int movementSpeed;

  Obstacle(float x, float y, int obstacleSize, int movementSpeed, int direction) {
    location = new PVector(x, y);
    this.obstacleSize = obstacleSize;
    this.direction = direction;
    this.movementSpeed = movementSpeed;
  }

  void display() {
    fill(255, 0, 0);
    noStroke();
    ellipse(location.x, location.y, obstacleSize, obstacleSize);
  }

  void moveDown(int speed) {
    location.y += speed;
  }

  void update() {
    location.x += direction * movementSpeed;
  }

  boolean isFinished() {
    if (direction == 1) 
      return location.x > width + obstacleSize/2;
    else if (direction == -1) 
      return location.x < -obstacleSize/2;

    return false;
  }

  boolean hitsPlayer() {
    return PVector.dist(location, player.spriteLocation) <= obstacleSize/2;
  }
}


class Arrow extends Obstacle {
  Arrow(float x, float y, int direction) {
    super(x, y, 75, 10, direction);
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y);
    scale(direction * -1, 1);
    image(arrowImg,0,0);
    popMatrix();
  }

  boolean hitsPlayer() {
    return player.spriteLocation.x < location.x + obstacleSize/2 &&
      player.spriteLocation.x > location.x - obstacleSize/2 &&
      player.spriteLocation.y < location.y + 10 &&
      player.spriteLocation.y > location.y - 10;
  }
}

class Crab extends Obstacle {
  float angle;
  Crab(float x, float y, int direction, int speed) {
    super(x, y, 50, speed, direction);
    angle = random(TWO_PI);
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(sin(angle) * PI/10);
    scale(direction, 1);
    image(crabImg, 0,0);
    popMatrix();
  }

  void update() {
    super.update();
    angle += 0.1 * movementSpeed;
  }
}


class Log extends Obstacle {
  PImage logImage;
  Log(float x, float y, int direction, int speed) {
    super(x, y, floor(random(1, 3)) * pathSize, speed, direction);
    
    if(obstacleSize == pathSize) {
      logImage = smallLogImage;
    } else {
      logImage = bigLogImage;
    }
  }
  

  void display() {
    pushMatrix();
    translate(location.x, location.y);
    scale(direction * -1, 1);
    image(logImage, 0, 0);
    popMatrix();
  }

  boolean hitsPlayer() {
    return player.spriteLocation.x < location.x + obstacleSize/2 &&
      player.spriteLocation.x > location.x - obstacleSize/2;
  }
}


class Boulder extends Obstacle {
  float angle;
  Boulder(float x, float y, int direction, int speed) {
    super(x, y, int(pathSize*0.8), speed, direction);
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(angle);
    image(boulderImg, 0, 0);
    popMatrix();
  }

  void update() {
    super.update();
    angle += direction * 0.03*movementSpeed;
  }
}


class Car extends Obstacle {
  PImage carImage;
  Car(float x, float y, int direction, int speed) {
    super(x, y, round(random(1, 2)) * 100, speed, direction);
    
    if(obstacleSize == 100) {
      carImage = smallCarImgs[floor(random(smallCarImgs.length))];
    } else {
      carImage = bigCarImgs[floor(random(bigCarImgs.length))];
    }
  }

  void display() {
    imageMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    scale(direction, 1);
    rotate(random(-0.02, 0.02) + HALF_PI);
    image(this.carImage, 0, 0);
    popMatrix();
  }

  boolean hitsPlayer() {
    return player.spriteLocation.x < location.x + obstacleSize/2 &&
      player.spriteLocation.x > location.x - obstacleSize/2;
  }
}

class Train extends Obstacle {
  PImage trainImage;
  Train(float x, float y, int direction) {
    super(x, y, 1000, 50, direction);
    
    trainImage = trainImgs[floor(random(4))];
  }

  void display() {
    rectMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    scale(direction, 1);
    image(trainImage,0,0);
    popMatrix();
  }

  boolean hitsPlayer() {
    return player.spriteLocation.x < location.x + obstacleSize/2 &&
      player.spriteLocation.x > location.x - obstacleSize/2;
  }
}
