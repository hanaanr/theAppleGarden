
import processing.sound.*;
SoundFile file; //creating file for my sound
PFont font; //setting up font
PImage appleImg; //setting up images
PImage basketImg;
int screenNumber = 0; //this determines whether we are at the instructions screen, the game screen or the end screen
int score = 0; //this is the score
float basketX; //x coordinate of the basket (basket can only move horizontally)
boolean moveDown = true; //this is for falling down motion of the apples

//the classes Basket and Apples are used to encapsulate the basket and apple properties
Basket basket; 
Apples apples;

void setup() {

  size (700, 700);
  background(255);

  file = new SoundFile(this, "mysound.mp3");
  font = loadFont("Arial-BoldMT-48.vlw");

  basketImg = loadImage("basket.png");
  appleImg = loadImage("apple.png");

  basket = new Basket(350);  
  apples = new Apples(350, 0);
}

void draw() {

  background(152, 195, 119);

  switch(screenNumber) { //this is to switch between the three screens 

  case 0: //instructions screen

    textFont(font);
    textSize(30);
    fill(204, 0, 0);
    text("Welcome to the Apple Garden!", 120, 100);

    textSize(20);
    fill(0, 102, 0);
    text("Instructions:", 100, 160);
    text("1. Your goal is to catch the falling apples in your", 110, 200);
    text("basket.", 110, 230);
    text("2. You can move your basket to left or right using", 110, 260);
    text("the left and right keys on your keyboard. Your", 110, 290);
    text("basket cannot move up or down.", 110, 320);
    text("3. For every apple you catch, your score increases", 110, 350);
    text("by 1 point.", 110, 380);

    fill(252, 238, 167);
    noStroke();
    rect(190, 427, 310, 30);

    fill(204, 0, 0);
    text("CLICK ANYWHERE TO BEGIN!", 200, 450);
    break;

  case 1:     // this is the actual game, displayed on the game screen 

    basket.movingBasket();
    apples.fallingApples();
    textFont(font);
    textSize(20);
    text("score:", 30, 50);
    text(score, 100, 50);

    break;

  case 2:     // this is the ending screen 

    text("You lost :( ", 300, 300);
    text("Click anywhere to play again!", 200, 330);
    break;
  }
}

//you can switch to the next screen upon clicking
void mousePressed() {
  if (screenNumber == 2) {
    screenNumber = 0;
  } else {
    screenNumber++;
  }
}

// this is the class for the apples 
class Apples {

  float appleX; //X coordinate of the apple
  float appleY; //Y coordinate of the apple

  Apples (float temp1, float temp2) {
    appleX = temp1; 
    appleY = temp2;
  }

  void fallingApples() { //this is the function for the falling apples

    image(appleImg, appleX, appleY, 90, 60); //display image of apple at (x, y)

    //moveDown is a global variable which is always set to true, so the apple always moves down
    if (moveDown == true) { 
      appleY = appleY + 7; //move down apple by 4 units
    }

    if (appleY <= 650) { //if the apple is still above a certain height close to the bottom of the screen (ie 650), let it continue moving down
      moveDown = true;
    }

    if (appleY > 650) { // if the apple crosses that threshold, then:
      screenNumber = 2; //switch to the ending screen ("you lost!") and also do the following to reset the game: 
      appleY = 0; //reset the apple's Y position back to the top
      appleX = random(30, 650);  //change the X position to any random position 
      moveDown = true; //move down
    }

    if (appleY > 600 && appleX < basketX + 140 && appleX > basketX - 20) { //if the apple's X and Y coordinates coincide with the that of the basket, then:
      appleY = 0; //reset the apple's Y basket back to the top
      appleX = random(30, 670); // change the X position to any random position 
      moveDown = true; //move down
      file.play(); // play the sound
      score++; // increase the score by one
    }
  }
}

// this is the class for the basket
class Basket {

  Basket(float temp1) {
    basketX = temp1; // this is the x coordinate of the basket. it is a global variable, because it is referenced in the Apple class
  }

  void movingBasket() { //ths is the function to move the basket left and right

    image(basketImg, basketX, 600, 200, 200); //display the image of the basket

    if (keyPressed) { // if the specified key is pressed, then:
      if (keyCode == LEFT) { //if LEFT is pressed, move the basket to the left 5 units
        basketX = basketX - 5;
      }
      if (keyCode == RIGHT) { //if RIGHT is pressed, move the basket to the right 5 units
        basketX = basketX + 5;
      }
    }
  }
}
