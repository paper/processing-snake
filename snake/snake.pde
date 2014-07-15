/*-----------------------------------
  snake game by processing
  
  author  paper
  date    2014-07
-------------------------------------*/

int w = 10;
int snakeLength = 2;
int snakeHeadX;
int snakeHeadY;

int maxSnakeLength = 500;
int[] x = new int[maxSnakeLength];
int[] y = new int[maxSnakeLength];

boolean foodKey = true;
int foodX;
int foodY;

int backgroundColor = 244;
int bestScore = snakeLength;

boolean gameOverKey = false;

void setup() {
  size(500, 500);
  frameRate(15);
  noStroke();
}

void draw() {
  
  if( isGameOver() ){
    return;
  } 

  background(backgroundColor);
  
  if (key == CODED) {
    switch(keyCode){
      case LEFT:
        snakeHeadX -= w;
        break;
      case RIGHT:
        snakeHeadX += w;
        break;
      case DOWN:
        snakeHeadY += w;
        break;
      case UP:
        snakeHeadY -= w;
        break;
    }
  }

  if( isSnakeDie() ){
    return;
  }
  
  //add another food
  drawFood(width, height);
  
  //eat it
  if( snakeHeadX == foodX && snakeHeadY == foodY ){
    snakeLength++;
    foodKey = true;
  }
  
  //store snake body
  for (int i=snakeLength-1; i>0; i--) {
    x[i] = x[i-1];
    y[i] = y[i-1];
  }
  
  //store snake new head
  y[0] = snakeHeadY;
  x[0] = snakeHeadX;
  
  fill(#7B6DB7);
  
  //draw snake
  for (int i=0; i<snakeLength; i++) {
    rect(x[i], y[i], w, w);
  }
  
}//end draw

void snakeInit(){
  background(backgroundColor);
  snakeLength = 2;
  gameOverKey = false;
  snakeHeadX = 0;
  snakeHeadY = 0;
}

void drawFood(int maxWidth, int maxHeight) {
  fill(#ED1818);
  
  if ( foodKey ) {
    foodX = int( random(0, maxWidth)/w  ) * w;
    foodY = int( random(0, maxHeight)/w ) * w;
  }
  
  rect(foodX, foodY, w, w);
  foodKey = false;
}

boolean isGameOver(){
  if( gameOverKey && keyPressed && (key == 'r' || key == 'R') ){
    snakeInit();
  }
  
  return gameOverKey;
}

void showGameOver(){
  pushMatrix();
    
  gameOverKey = true;
  bestScore = bestScore > snakeLength ? bestScore : snakeLength;
  
  background(0);
  translate(width/2, height/2 - 50);
  fill(255);
  textAlign(CENTER);

  textSize(84);
  text(snakeLength + " / " + bestScore, 0, 0);
  
  fill(120);
  textSize(18);
  text("score / best", 0, 230);
  text("Game over, press 'R' to restart.", 0, 260);

  popMatrix();
}

boolean isSnakeDie(){
  //hitting the wall
  if( snakeHeadX < 0 || snakeHeadX >= width || snakeHeadY < 0 || snakeHeadY >= height){
    showGameOver();
    return true;
  }
  
  //eat itself
  if( snakeLength > 2 ){
    for( int i=1; i<snakeLength; i++ ){
      if( snakeHeadX == x[i] && snakeHeadY == y[i] ){
        showGameOver();
        return true;
      }
    }
  }
  
  return false;
}
