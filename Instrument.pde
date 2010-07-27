class Instrument extends DisplayObject
{
   /* Properties
   ______________________________________________________________________*/
   
   boolean _enabled = false;
   color _boxColor;
   int _boxWidth = 100;
   int _boxHeight = 70;
   int _sideNum = 0;
   PFont _font;
   String _name;
   int _send;
   Effects _effects;
   
   Controller _controller;
   MidiOut _midiOut;
   
   /* Constructor
   ______________________________________________________________________*/
   
   Instrument(int sideNum, int xPos, int yPos, color[] colors, PFont font, PFont effectFont, String name, int send, String[] effectNames, int[] effectSends, int boxWidth, int boxHeight, MidiOut midiOut)
   {
      super(xPos, yPos, 0);
      
      _boxHeight = boxHeight;
      _boxWidth = boxWidth;
      _sideNum = sideNum;
      _boxColor = colors[sideNum];
      _font = font;
      _name = name;
      _send = send;
      _midiOut = midiOut;
      
      createEffects(effectNames, colors, effectFont, effectSends);
   }  
   
   /* Create Effects
   ______________________________________________________________________*/
   
   void createEffects(String[] effectNames, color[] colors, PFont effectFont, int[] effectSends)
   {
      _effects = new Effects(520, 445, colors, effectNames, effectFont, effectSends);
   }
   
   /* Update
   ______________________________________________________________________*/
   
   void update(boolean enabled)
   {  
      if(!_enabled && enabled)
      {
         sendInstrumentMidi();
      }
      
      _enabled = enabled;
      
      if(_enabled)
      {
         drawEnabled();
         
         _effects.update();
         
         sendEffectMidi();
      }
      
      drawBox();
      
      drawText();
   }
   
   /* Draw ellipse
   ______________________________________________________________________*/
   
   void drawBox()
   {
      fill(_boxColor);
      noStroke();
      
      rect(_xPos, _yPos, _boxWidth, 50);  
   }
   
   /* Draw disabled
   ______________________________________________________________________*/
   
   void drawEnabled()
   {
      fill(255);
      rect(_xPos, _yPos, _boxWidth, _boxHeight); 
   }
   
   /* Draw text
   ______________________________________________________________________*/
   
   float centerX;
   float centerY;
   
   void drawText()
   {
      textFont(_font);
      textAlign(LEFT);
      
      if(_enabled)   fill(30);
      else           fill(240);
      
      centerX = _xPos + (_boxWidth / 2) - (textWidth(_name) / 2);
      centerY = _yPos + (_boxHeight - 5);
      
      text(_name, centerX, centerY);
   }
   
    /* Send MIDI Instrument
   ______________________________________________________________________*/
   
   void sendInstrumentMidi()
   {
      // here we send midi that the instrument is selected
      
      // I don't think we need it
   }
   
   /* Send MIDI Effect
   ______________________________________________________________________*/
   
   void sendEffectMidi()
   {
      if(_effects.getEnabled())
      {
         _controller = new Controller(_effects.getEffectSend(), _effects.getEffectValue());
         _midiOut.sendController(_controller);
      }
   }
   
   void reset()
   {
      _effects.reset();
      
      int[] sends = _effects.getEffectSends();
      
      for(int i = 0; i < sends.length; i++)
      {
          _controller = new Controller(sends[i], 0);
          _midiOut.sendController(_controller);
      }  
   }
   
   /* Getter / Setter
   ______________________________________________________________________*/
   
   void setEffect(int effectNum)
   {
      _effects.setEffect(effectNum);
   }
   
   void setEffectValue(int effectValue)
   {
      _effects.setEffectValue(effectValue);
   }
}
