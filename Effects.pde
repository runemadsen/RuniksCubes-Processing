class Effects extends DisplayObject
{
   /* Properties
   ______________________________________________________________________*/  
   
   EffectCircle[] _effects = new EffectCircle[6];
   color[] _colors;
   String[] _names;
   PFont _font;
   
   int _effect = -1;
   int _effectValue = 0;
   int[] _effectSends;
   
   boolean _enabled = false;
   
   /* Constructor
   ______________________________________________________________________*/
   
   Effects(int xPos, int yPos, color[] colors, String[] names, PFont font, int[] effectSends)
   {
      super(xPos, yPos, 0);
      
      _colors = colors;
      _names = names;
      _font = font;
      _effectSends = effectSends;
      
      createEffects();
   }
   
   /* Create circles
   ______________________________________________________________________*/
   
   void createEffects()
   {
      float xPos = _xPos;
      float yPos = _yPos;
      
      for(int i = 0; i < 6; i++)
      {
         _effects[i] = new EffectCircle(i, 100, xPos, yPos, _colors[i], _font, _names[i]);
         
         xPos += 420;
         
         if(i == 2)  
         { 
            xPos = _xPos;
            yPos += 380;
         }
      }
   }
   
   /* Update
   ______________________________________________________________________*/
   
   void update()
   {
      for(int i = 0; i < _effects.length; i++)
      {
         if(_effect == i)   
         {
            _effects[i].update(_effectValue, true);
         }
         else
         {
            _effects[i].update(0, false);
         }
      }
   }
   
   void reset()
   {
      for(int i = 0; i < _effects.length; i++)
      {
         _effects[i].reset();
      }  
   }
   
   /* Choose circle
   ______________________________________________________________________*/
   
   void setEffect(int effectNum)
   {
      if(effectNum == -1)
      {
         _enabled = false;
      }
      else
      {
         _enabled = true;
      }
      
      _effect = effectNum;
   }
   
   void setEffectValue(int effectValue)
   {
      _effectValue = effectValue;
   }
   
   int getEffectSend()
   {
      return _effectSends[_effect];  
   }
   
   int[] getEffectSends()
   {
      return _effectSends;  
   }
   
   int getEffectValue()
   {
      return _effects[_effect].getMidiValue();  
   }
   
   boolean getEnabled()
   {
      return _enabled;
   }
}
