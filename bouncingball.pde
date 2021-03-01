// All assignments we need for the base
PVector baseL;
PVector baseR;
float floorLength;
PVector coords[];
PVector deltaBase;
PVector normal;
//All assignments we need for the bouncy ball
PVector location;
PVector velocity;
PVector gravity;
float rad = 20;
float speedBall = 3.0;
//All assignment we need to calculate reflection of bounce
PVector incidence;
void setup()
{
 //set up of the vector of slanted base
 size(810,360);
 baseL = new PVector( 0,height -150);
 baseR = new PVector(width, height);
 setGround();

 //set initial ball location
 location = new PVector(0,0);
 //set initial ball velocity
 velocity = new PVector(0.2, 2.5);
 velocity.mult(speedBall);
}
void setGround()
{
 //distant of the floor length span left of window to right
 floorLength = PVector.dist(baseL,baseR);

 //Stores the coordinates of our base into an array
 coords = new PVector[ceil(floorLength)];
 for (int i = 0; i < coords.length; i++)
 {
 coords[i] = new PVector();
 coords[i].x = baseL.x + ((baseR.x - baseL.x) / floorLength) * i;
 coords[i].y = baseL.y + ((baseR.y - baseL.y) / floorLength) * i;
 }

}
void draw()
{
 //draw the window background
 fill(0,12);
 noStroke();
 rect(0,0,width, height);
 //slant base
 stroke(200,0);
 strokeWeight(1);
 fill(200);
 quad(baseL.x, baseL.y, baseR.x, baseR.y, baseR.x, height, 0, height);

 //calculate the top of slanted base
 deltaBase = PVector.sub(baseR, baseL);
 deltaBase.normalize();
 normal = new PVector (-deltaBase.y, deltaBase.x);

 //draw ball
 stroke(255);
 fill(48,139,206,103);
 ellipse(location.x, location.y, rad*2,rad*2);

 //start moving bouncy ball
 location.add(velocity);

 //Multiply x component of incidence vector with velocity
 //and multiply y component of incidence vector with -1 so it bounce off the direction
 //it bounces onto
 incidence = PVector.mult(velocity,-1);
 incidence.normalize();

 //when ball hits the slanted base
 for ( int i = 0; i < coords.length; i++)
 {
 if (PVector.dist(location, coords[i]) < rad )
 {
 float dotP = incidence.dot(normal);

 //using orthogonal projection we can calculate the reflection vector
 //then we set the reflection vector to be direction vector
 //this is to update the direction vector each time the ball bounces
 velocity.set(2*normal.x*dotP - incidence.x, 2*normal.y*dotP - incidence.y, 0);
 velocity.mult(speedBall);
 location = location.add(velocity);

 //draw normal line
 stroke(255,129,200);
 strokeWeight(2);
 line(location.x, location.y, location.x-normal.x*200, location.y-normal.y*200);
 }

 }
 //check right edge bound
 if(location.x > width - rad)
 {
 location.x = width - rad;
 velocity.x = 0;

 if (location.y > 170)
 {
 velocity.y = 0;
 }
 }
 
 //check top bound
 if (location.y < rad)
 {
 location.y = rad;
 velocity.y *= -1;
 velocity.x = 1;
 }
}
