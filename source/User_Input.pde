void keyPressed() {
  switch(GameState) {
  case 0:
    if (keyCode == UP) {
      GameState = 1;
      player.move(0, -1);
    }
    break;
  case 1:
    switch(keyCode) {
    case UP:
      player.move(0, -1);
      break;
    case DOWN:
      player.move(0, 1);
      break;
    case LEFT:
      player.move(-1, 0);
      break;
    case RIGHT:
      player.move(1, 0);
      break;
    }
    break;
  case 2:
    if (key == 'r') {
      Reset();
    }
    break;
  }
}


void Reset() {
  GameState = 0;

  if (score > highscore) {
    highscore = score;
    String[] s = {str(highscore)};
    saveStrings("HIGHSCORE.txt", s);
  }
  score = 0;
  player = new Player();
  spawners.clear();
  coins.clear();
  boosters.clear();
  spaceBetweenPaths = floor(random(2, 5));
  coinScoreAlpha = 0;
  createNextSpawner(100);
}
