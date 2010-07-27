class DisplayObject
{
   /* Properties
   ________________________________________________ */
   
   protected float _xPos = 0;
   protected float _yPos = 0;
   protected float _zPos = 0;
   
   protected float _xRot = 0;
   protected float _yRot = 0;
   protected float _zRot = 0;
   
   protected float _curYRot = 0;
   protected float _curXRot = 0;
   protected float _curZRot = 0;
   
   /* Constructor 1
   ________________________________________________ */
   
   DisplayObject()
   {
   }
   
   /* Constructor 1
   ________________________________________________ */
   
   DisplayObject(float xPos, float yPos, float zPos)
   {
      _xPos = xPos;
      _yPos = yPos;
      _zPos = zPos;
   }
   
   /* Constructor 2
   ________________________________________________ */
   
   DisplayObject(float xPos,float yPos, float zPos, float xRot, float yRot, float zRot)
   {
      _xPos = xPos;
      _yPos = yPos;
      _zPos = zPos;
      
      _xRot = xRot;
      _yRot = yRot;
      _zRot = zRot;
   }
   
   /* Abstract
   ________________________________________________ */
   
   void update()
   {
      println("Update must be overriden in subclass");
   }
   
   /* Methods
   ________________________________________________ */
   
   protected void locateRotation()
   {
      rotateY(_curYRot); 
      _curYRot += _yRot;

      rotateX(_curXRot); 
      _curXRot += _xRot; 
      
      rotateZ(_curZRot);
      _curZRot += _zRot;
   }
   
   protected void locatePosition()
   {
      translate(_xPos, _yPos);
   }
   
   /* Getter / Setter
   ________________________________________________ */
   
   void setXPos(float xPos)
   {
      _xPos = xPos;  
   }
   
   float getXPos()
   {
      return _xPos;  
   }
   
   void setYPos(float yPos)
   {
      _yPos = yPos;  
   }
   
   float getYPos()
   {
      return _yPos;  
   }
   
   void setZPos(float zPos)
   {
      _zPos = zPos;  
   }
   
   float getZPos()
   {
      return _zPos;  
   }
   
   void setXRot(float xRot)
   {
      _xRot = xRot;  
   }
   
   float getXRot()
   {
      return _xRot;  
   }
   
   void setYRot(float yRot)
   {
      _yRot = yRot;  
   }
   
   float getYRot()
   {
      return _yRot;  
   }
   
   void setZRot(float zRot)
   {
      _zRot = zRot;  
   }
   
   float getZRot()
   {
      return _zRot;  
   }
   
   void setCurXRot(float curXRot)
   {
      _curXRot = curXRot;  
   }
   
   float getCurXRot()
   {
      return _curXRot;  
   }
   
   void setCurYRot(float curYRot)
   {
      _curYRot = curYRot;  
   }
   
   float getCurYRot()
   {
      return _curYRot;  
   }
   
   void setCurZRot(float curZRot)
   {
      _curZRot = curZRot;  
   }
   
   float getCurZRot()
   {
      return _curZRot;  
   }
}
