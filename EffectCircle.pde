class EffectCircle extends DisplayObject
{
   /* Properties
   ______________________________________________________________________*/
   
   int _radius = 100;
   int _outerWidth = 86;
   int _innerWidth = 75;
   int numSpaces = 40; 
   int _sideNum = 0;
   int _curDegree = 0;
   String _name;
   CurveText _curveText;
   color _circleColor = 100;
   
   /* Constructor
   ______________________________________________________________________*/
   
   EffectCircle(int sideNum, int radius, float xPos, float yPos, color circleColor, PFont font, String name)
   {
      super(xPos, yPos, 0);
      
      _sideNum = sideNum;
      _radius = radius;
      _circleColor = circleColor;
      _name = name;
      
      _curveText = new CurveText(font, _name, _radius + 50);
      _curveText.setTextOffset(70);
      _curveText.setXPos(_xPos);
      _curveText.setYPos(_yPos);
      
   }  
   
   /* Update
   ______________________________________________________________________*/
   
   void update(int gyroReading, boolean enabled)
   {
      checkGyro(gyroReading);
      
      drawBackCircle();
      
      drawArc();
      
      drawEllipse();
      
      if(!enabled)
      {
         drawRing(#161616);
         _curveText.update(#434343);
      }
      else
      {
         drawRing(#ffffff);
         _curveText.update(#ffffff);
      }
      
     
   }
   
   /* Check side
   ______________________________________________________________________*/
   
   void checkGyro(int gyroReading)
   {       
      _curDegree += gyroReading / 20;
      
      if(_curDegree < 0)          _curDegree = 0;
      else if(_curDegree > 360)   _curDegree = 360;
   }
   
   /* Draw back circle
   ______________________________________________________________________*/
   
   
   void drawBackCircle()
   {
      fill(#121212);
      noStroke();
      ellipse(_xPos, _yPos, (_radius*2) + 82, (_radius*2) + 82);
   }
   
   /* Draw arc
   ______________________________________________________________________*/
   
   void drawArc()
   {
      stroke(_circleColor);
      strokeWeight(_outerWidth);
      strokeCap(SQUARE); 
      noFill();  
      
      arc(_xPos, _yPos, (_radius*2) - 23, (_radius * 2) - 23, 0, radians(_curDegree));
   }
   
   /* Draw ellipse
   ______________________________________________________________________*/
   
   void drawEllipse()
   {
      fill(_circleColor);
      noStroke();
      
      ellipse(_xPos, _yPos, _innerWidth, _innerWidth);  
   }
   
   /* Draw disabled
   ______________________________________________________________________*/
   
   void drawRing(color ringColor)
   {
      noFill();
      stroke(ringColor);
      strokeWeight(3);
      arc(_xPos, _yPos, (_radius*2) + 82, (_radius*2) + 82, 0, TWO_PI);
   }
   
   /* Getter / Setter
   ______________________________________________________________________*/
   
   int getMidiValue()
   {
      //println("returning current degree: " + _curDegree);
      return round(map(_curDegree, 0, 360, 0, 127));
   }
   
   /* Reset
   ______________________________________________________________________*/
   
   void reset()
   {
      _curDegree = 0;  
   }
}
