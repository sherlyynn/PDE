//setting up level stage
PImage levelStage;
PImage displayLevel;

//setting location where the user begins
float userX = 50;
float userY = 50;

//setting initial velocity and gravity
float userVelX = 0;
float userVelY = 0;
float gravity = 0.2;

//setting the user moving & jumping speed
float userSpeed = 2;
float userJumpSpeed = -6;
float user = 20;

//setting arrow keys for play
float up;
float down;
float left;
float right;


//check the stage for usefullness
//first boolean checks if user is on platform or in air
//second boolean checks if the platform edges
boolean onPlatform;
boolean platformEdge (float left1, float top1, float right1, float bottom1, float left2, float top2, float right2, float bottom2)
{
  return !(left1 > right2 || right1 < left2 || top1 > bottom2 || bottom1 < top2);
}

void setup()
{
  // a call to the file directory to get the background
  size(500,500);
  levelStage = requestImage("level0.png");
  displayLevel = requestImage("level0.png");
}

void draw()
{
  
  fill (0); // colour that shows when the user is in mid air
  userVelX = (right - left) * userSpeed; //giving initial velocity when user stops
  userVelY = userVelY + gravity; //update velocity when user is in mid air and gives free-fall effect
  float moveX = userX + userVelX; //when user move left/right, this gives it speed to move
  float moveY = userY + userVelY; //when user move up and down, this gives it speed to move
  
  boolean tempPlatform = true; 
  //the following calls for the image to be displayed on window
  if (levelStage.width > 0)
  {
    image(levelStage,0,0,width,height);
    if (displayLevel.width >0)
    {
      image(displayLevel,0,0,width,height);
    }
    
    //analyze each pixel on the display and store them in memory 
    //this is because we need to check the image for its edges
    levelStage.loadPixels();
    for (int y=0; y < levelStage.height; y++)
    {
      for (int x=0; x < levelStage.width; x++)
      {
        color pixel = levelStage.pixels[y*levelStage.width+x]; //this is where each pixel on the image is stored, it is an array
        float scale = width / levelStage.width; //scaling the image size to the display window
        float rightx = moveX; //set horizontal moves to the edges pixels
        float lefty = userY; //set vertical pixels to user's vertical movement
        float platformx = x * (int)scale; //this casts "scale" into an integer to give us the platform edges pixel accurately
        float platformy = y * (int)scale;
        float pixelsize = 10; //we set the size of each pixel so it doesn't cross over on the edges
        float user = 10; //setting the user position so it doesn't cross over any edges
        
        //checking edge bounds to reset position and velocity
        if (platformEdge(platformx, platformy, platformx + pixelsize, platformy + pixelsize, rightx, lefty, rightx+user, lefty+user) == true && red(pixel) == 0)
        {
          if ( userVelX < 0 && userX >= platformx + pixelsize)
          {
            userVelX = 0;
          }
          if ( userVelX > 0 && userX < platformx)
          {
            userVelX = 0;
          }
        }
        
        //to move user on the platform, updating when there is a new position
        rightx = userX;
        lefty = moveY;
        
        if ( platformEdge(platformx, platformy, platformx + pixelsize, platformy + pixelsize, rightx, lefty, rightx+user, lefty+user) && red(pixel) == 0)
        {
          fill (30,20,55,55);
          if ( userVelY < 0 && userY >= platformy)
          {
            userVelY = 0;
            tempPlatform = false;
          }
          if ( userVelY > 0 && userY < platformy)
          {
            userVelY = 0;
            tempPlatform = true;
          }
        
        }
      }
    }
  }

  userX = userX + userVelX;
  userY = userY + userVelY;
  
  ellipse(userX,userY, user,user);
  onPlatform = tempPlatform;
  
}

void keyReleased()
{
  if (key == CODED)
  {
    if(keyCode == LEFT)
    {
      left = 0;
    }
    if(keyCode == RIGHT)
    {
      right = 0;
    }
    if(keyCode == UP)
    {
      up = 0;
    }
    if(keyCode == DOWN)
    {
      down = 0;
    }
  }
}

void keyPressed()
{
  if (key == ' ')
  {
    if (onPlatform == true)
    {
      userVelY = userJumpSpeed;
    }
  } 
  
  if (key ==  CODED)
  {
    if(keyCode == LEFT)
    {
      left = 1;
    }
    if(keyCode == RIGHT)
    {
      right = 1;
    }
    if(keyCode == UP)
    {
      up = 1;
    }
    if(keyCode == DOWN)
    {
      down = 1;
    }
  }
}

  
  
