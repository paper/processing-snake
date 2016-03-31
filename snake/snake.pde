/*-----------------------------------
  snake game by processing
  
  author  paper
  date    2014-07
-------------------------------------*/

// 蛇每个格子的宽高长度
int w = 10;
int h = 10;

// 蛇的初始身长
int snakeLength = 2;

// 蛇头的坐标
int snakeHeadX;
int snakeHeadY;

// 蛇运动的方向。默认向右
char snakeDirection = 'R';

// 蛇最大身长。
// 如果你可以吃到500，那我也无话可说 :(
int maxSnakeLength = 500;

// 提前申请蛇身上每一节坐标的内存空间
int[] x = new int[maxSnakeLength];
int[] y = new int[maxSnakeLength];

// 食物是否被吃了的状态码
// 一开始就假设被吃了一个，是为了可以调用随机生成食物的方法
boolean foodKey = true;

// 食物坐标
int foodX;
int foodY;

// 画布的颜色 244,244,244
int backgroundColor = 244;

// 存储玩家最佳成绩。当然就是蛇的长度
int bestScore = snakeLength;

// 判断游戏是否结束的状态值。
boolean gameOverKey = false;

// 初始化
void setup() {
  
  // 画布大小是500*500
  size(500, 500);
  
  // 帧数控制在15
  frameRate(15);
  
  // 禁止画外边线。这样画矩形时，就不会描边。
  noStroke();
}

// 每一帧都会触发draw事件，类似setInterval
// 永远不会停止
void draw() {
  
  // 监听游戏结束画面事件 
  listenGameOver();
  
  // 每一帧都要判断：蛇是不是挂了？
  if( isSnakeDie() ){
    return;
  }
  
  // 填充画布背景颜色
  background(backgroundColor);
  
  // 当方向键被按下时
  if (keyPressed && key == CODED) {
    switch(keyCode){
      case LEFT:
        if(snakeDirection != 'R'){
          snakeDirection = 'L';
        }
        break;
      case RIGHT:
        if(snakeDirection != 'L'){
          snakeDirection = 'R';
        }
        break;
      case DOWN:
        if(snakeDirection != 'U'){
          snakeDirection = 'D';
        }
        break;
      case UP:
        if(snakeDirection != 'D'){
          snakeDirection = 'U';
        }
        break;
    }
  }
  
  // 根据上面方向键被按下时得到的方向，控制蛇头的方向
  switch(snakeDirection){
    case 'L':
      snakeHeadX -= w;
      break;
    case 'R':
      snakeHeadX += w;
      break;
    case 'D':
      snakeHeadY += w;
      break;
    case 'U':
      snakeHeadY -= w;
      break;
  }
  
  // 画一个食物
  // @width, @height 是指画布的宽高
  drawFood(width, height);
  
  // 画蛇
  drawSnake();
  
  // 如果蛇吃了食物
  if( snakeHeadX == foodX && snakeHeadY == foodY ){
    snakeLength++;
    foodKey = true;
  }
  
}//end draw

// 蛇初始化参数
void snakeInit(){
  snakeLength = 2;
  gameOverKey = false;
  snakeHeadX = 0;
  snakeHeadY = 0;
  snakeDirection = 'R';
}

// 画蛇
void drawSnake() {
  // 重新设置蛇的坐标
  // 从蛇尾开始更新
  for (int i=snakeLength-1; i>0; i--) {
    x[i] = x[i-1];
    y[i] = y[i-1];
  }
  
  // 设置蛇头新的坐标
  y[0] = snakeHeadY;
  x[0] = snakeHeadX;
  
  // 设置蛇的填充颜色
  fill(#7B6DB7);
  
  // 开始画蛇
  for (int i=0; i<snakeLength; i++) {
    rect(x[i], y[i], w, h);
  }
}

// 画个食物
void drawFood(int maxWidth, int maxHeight) {
  // 食物的颜色
  fill(#ED1818);
  
  // 如果被吃了，就再随机生产一个
  if ( foodKey ) {
    foodX = int( random(0, maxWidth)/w  ) * w;
    foodY = int( random(0, maxHeight)/h ) * h;
  }
  
  rect(foodX, foodY, w, h);
  foodKey = false;
}

// 出现游戏结束后的画面，要监听和处理的事情
void listenGameOver(){
  if( gameOverKey && keyPressed && (key == 'r' || key == 'R') ){
    snakeInit();
  }
}

// 显示游戏结束画面
void showGameOver(){
  // 将当前的坐标矩阵压入堆栈
  // 类似 canvas.save();
  pushMatrix();
    
  gameOverKey = true;
  bestScore = bestScore > snakeLength ? bestScore : snakeLength;
  
  // 黑底背景
  background(0);
  
  // 移动画布的中心
  translate(width/2, height/2 - 50);
  
  // 设置填充颜色为白色
  fill(255);
  
  // 设置文字的位置为居中
  // 居中是根据画布的y轴居中了，所以我们上面 translate 了画布向右一半的宽度
  textAlign(CENTER);
  
  // 设置文字的大小
  textSize(84);
  
  // 设置文字内容
  text(snakeLength + " / " + bestScore, 0, 0);
  
  fill(120);
  textSize(18);
  text("score / best", 0, 230);
  text("Game over, press 'R' to restart.", 0, 260);
  
  // 恢复这个矩阵
  // translate 失效，画布的起点又回到左上角
  // 类似 canvas.restore();
  popMatrix();
}

// 蛇死了么？
boolean isSnakeDie(){
  // 撞墙了
  if( snakeHeadX < 0 || snakeHeadX >= width || snakeHeadY < 0 || snakeHeadY >= height){
    showGameOver();
    return true;
  }
  
  // 自己吃自己
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
