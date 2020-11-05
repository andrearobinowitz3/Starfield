// Starfield Program
// Andrea Robinowitz
// November 2, 2020

// GLOBAL VARIABLES
DogParticle [] particles;
int numberOfParticles = 40;

// AUXILLARY FUNCTIONS

int returnRandomNumber(int max) {
 // this function returns a random integer,x, such that 0<= X <= max
 // the argument, max, must be an integer >= 0.
return ((int) (Math.random()*(max+1)));
}

double distanceBetweenTwoPoints (float x1, float y1, float x2, float y2)
{
return (double) sqrt (sq(x2 - x1) + sq(y2 - y1));
}

// JAVA CORE FUNCTION
void setup()
{
 size (800, 700);
 frameRate(10);
 //background (255,255,255);
 particles = new DogParticle[numberOfParticles];
 // create particles in the whole array, EXCEPT for the last element of the array
 // we will save the last element of the array for the oddball.
 for (int i = 0; i<particles.length-1; i++) {
   particles[i] = new DogParticle ();
 }
 // create the oddball particle and put it in the last element of the array
 particles[particles.length - 1] = new OddBallParticle();
}

void draw ()
// clear the screen and show all particles and then have them move.
{
 background(0,0,0);
 for (int i = 0; i<particles.length; i++) {
   particles[i].show();
   particles[i].move();
 }
}


// Class Definitions

class DogParticle {
  double myX, myY, mySpeed, myAngle;
  float myRed, myBlue, myGreen;
  int wagDirection, wagCounter, myXDirection, blinkCount, gotOddBall,
    inMouth;

 DogParticle ()
 {
     myX = (800/2);
     myY = (700/2);
     mySpeed = 2 + (double) Math.random() * 7.0;
     myAngle = (double) Math.random() * 2 * Math.PI;
     myRed = (float) Math.random() * 256;
     myBlue = (float) Math.random() * 256;
     myGreen = (float) Math.random() * 256;
     wagDirection = 0;
     wagCounter = 15;
     myXDirection = 0;
     blinkCount = (int) Math.random() * 20;
     gotOddBall = 0;
     inMouth = 0;
 }

void reinitializeParticle () {
  myX = (800/2);   // set x and y coordinates to the center of the screen
  myY = (700/2);
  mySpeed = 2 + (double) Math.random() * 7.0;  // assign random speed
  myAngle = (double) Math.random() * 2 * Math.PI;  // assign random angle
  gotOddBall = 0;
}

void move () {
  double stepX, stepY, distanceThisStep;

  if ((myX > 800) || (myX < 0) || (myY > 700) || (myY < 0)) {
    // dog has moved off of the screen
   reinitializeParticle ();
   }
  else
  // the dog is on the screen
  {
    if ((gotOddBall == 0) &&
        (particles[particles.length -1].inMouth == 0) &&
        (distanceBetweenTwoPoints ((float) myX, (float) myY,
            (float) particles[particles.length -1].myX,
            (float) particles[particles.length -1].myY) < 20))
            // if the dog is close to the tennis ball, and is not already running
            // away with it then:
       {
         // reverse the angle of the dog
          myAngle = myAngle + Math.PI;
          // and go max speed!!
          mySpeed = 20;
          gotOddBall = 1;
        }
    stepX = (Math.cos (myAngle) * mySpeed); // calculate the step in X direction
    if (stepX >= 0) {
      // if the dog is going left to right, then set myXDirection to 1
      myXDirection = 1;
    }
     else {
       // dog is going right to left
        myXDirection = 0;
     }

     if (gotOddBall == 1) {
         // and move the tennis ball to the dogs mouth; set it to have
         // the same speed and angle as the dog;
          particles[particles.length - 1].changeDirection (mySpeed, myAngle);
          particles[particles.length - 1].inMouth  = 1;
          particles[particles.length - 1].myY = myY + 4;
          if (myXDirection == 1) {
            particles[particles.length - 1].myX = myX - 1;
          }
          else
          { particles[particles.length - 1].myX = myX + 1;
          }
    }
    stepY = (Math.sin (myAngle) * mySpeed); // set the size of the Y step

    myX = myX + stepX; // move the dog by set the myX and myY to the new locations
    myY = myY + stepY;

    // see if it's time to move the tail
    changeWag();

  }
}

void show() {
   if (myXDirection == 0) {
     fill(255,255,255);
     ellipse((float) myX,(float) myY,20,20);
     ellipse((float) myX+20,(float) myY+10,40,16); // dog tummy
     ellipse((float) myX+5,(float) myY+17,5,20);
     ellipse((float) myX+10,(float) myY+17,5,20);
     ellipse((float) myX+30,(float) myY+17,5,20);
     ellipse((float) myX+35,(float) myY+17,5,20);
     //fill(54); //make ellipse fill black for eyes
     blink();
     ellipse((float) myX-3,(float) myY-2,3,3); // left eye
     ellipse((float) myX+3,(float) myY-2,3,3); // right eye
     fill(0,0,0);
     ellipse((float) myX,(float) myY+2,3,3); // nose
     fill(255,192,203); //make pink color for tongue
     ellipse((float) myX,(float) myY+7,4,5); //tongue
     strokeWeight(4);
     stroke(255,255,255);
     if (wagDirection == 0) {
       // draw tail
         line((float)(myX+35),(float)(myY+5),(float)(myX+39),(float)(myY-14));
        }
        else {
          line((float)(myX+35),(float)(myY+5),(float)(myX+42),(float)(myY-3));
        }
     noStroke();
     fill(255,255,255);
     // draw ears
     triangle((float) (myX-10), (float) (myY-5), (float) (myX-1),
            (float) (myY-10), (float) (myX-8), (float) (myY-14));
     triangle((float) (myX-2), (float) (myY-9), (float) (myX+7),
            (float) (myY-7), (float) (myX+8), (float) (myY-14));
     stroke (myRed, myBlue, myGreen);
     strokeWeight(3);
     //draw collar and tag
     line ((float)(myX+14),(float)(myY+1),(float)(myX+0), (float) (myY+13));
     noStroke();
     fill(200,200,240);
     ellipse((float) (myX+0), (float)(myY+14),5,5);
   }
   else
   {
     fill(255,255,255);
     ellipse((float) myX,(float) myY,20,20);
     ellipse((float) myX-20,(float) myY+10,40,16); // dog tummy
     ellipse((float) myX-5,(float) myY+17,5,20);
     ellipse((float) myX-10,(float) myY+17,5,20);
     ellipse((float) myX-30,(float) myY+17,5,20);
     ellipse((float) myX-35,(float) myY+17,5,20);
     //fill(54); //make ellipse fill black for eyes
     blink();
     ellipse((float) myX+3,(float) myY-2,3,3); // left eye
     ellipse((float) myX-3,(float) myY-2,3,3); // right eye
     fill(0,0,0);
     ellipse((float) myX,(float) myY+2,3,3); // nose
     fill(255,192,203); //make pink color for tongue
     ellipse((float) myX,(float) myY+7,4,5); //tongue
     strokeWeight(4);
     stroke(255,255,255);
     if (wagDirection == 0) {
       // draw tail
         line((float)(myX-35),(float)(myY+5),(float)(myX-39),(float)(myY-14));
        }
        else {
          line((float)(myX-35),(float)(myY+5),(float)(myX-42),(float)(myY-3));
        }
     noStroke();
     fill(255,255,255);
     // draw ears
     triangle((float) (myX+10), (float) (myY-5), (float) (myX+1),
            (float) (myY-10), (float) (myX+8), (float) (myY-14));
     triangle((float) (myX+2), (float) (myY-9), (float) (myX-7),
            (float) (myY-7), (float) (myX-8), (float) (myY-14));


     stroke (myRed, myBlue, myGreen);
     strokeWeight(3);
     //draw collar and tag
     line ((float)(myX-14),(float)(myY+1),(float)(myX-0), (float) (myY+13));
     noStroke();
     fill(200,200,240);
     ellipse((float) (myX-0), (float)(myY+14),5,5);
   }
}


 void blink () {
   if (blinkCount <= 0) {
     blinkCount =  20 + (int) Math.random()*4;
     fill (255,255,255);
   }
   else {
       fill (0,0,0);
       blinkCount--;
   }
 }

 void changeDirection (double speed, double angle) {
   mySpeed = speed;
   myAngle = angle;
 }

 void changeWag () {
    if (returnRandomNumber (10) <= 8) {
      // 80% chance that wag timer is processed -- if this line is not here,
      // all of the tags wag together, perfectly rhythmically. And it looks funny
         if (wagDirection == 0) {
              wagDirection = 1;
         }
         else
         {
            wagDirection = 0;
          }
 }
}
}

class OddBallParticle extends DogParticle {

 void move () {
   if ((myX > 800) || (myX < 0) || (myY > 700) || (myY < 0)) {
     //if the OddBallParticle has moved off the screen, start it at the center again:
     myX = Math.random() * 800;
     myY = Math.random() * 700;
     inMouth = 0;
   }
   else
   {
     if (inMouth == 1) {
       myX = myX + Math.cos (myAngle) * mySpeed;
       myY = myY + Math.sin (myAngle) * mySpeed;
     }
     else
     {
       myX = (float) mouseX;
       myY = (float) mouseY;
     }
   }

 }

 void show () {
   fill (0,240,0);
   ellipse ((float) myX, (float) myY, 7,7);
 }

}
