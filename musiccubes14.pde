/* Import
_____________________________________________________________________ */

import processing.opengl.*;
import processing.serial.*;
import promidi.*;

/* Select starting cube
_____________________________________________________________________ */

int curXbee = 2;
int threshold = 0;
int divideNum = 50;
int[] formerValues = {0, 0, 0, 0, 0, 0};

/* Instrument / Circle setup
_____________________________________________________________________ */

String[] instrumentNames = {"Drums", "Loop 1", "Loop 2", "Synth", "Pads", "Effects"};
int[] instrumentSends = {0, 0, 0, 0, 0, 0};

String[] effectNames1 = {"Volume", "Panning", "Effects 1", "Effects 2", "Effects 3", "Effects 4"};
String[] effectNames2 = {"Volume", "Panning", "Effects 1", "Effects 2", "Effects 3", "Effects 4"};
String[] effectNames3 = {"Volume", "Panning", "Effects 1", "Effects 2", "Effects 3", "Effects 4"};
String[] effectNames4 = {"Volume", "Panning", "Effects 1", "Effects 2", "Effects 3", "Effects 4"};
String[] effectNames5 = {"Volume", "Panning", "Effects 1", "Effects 2", "Effects 3", "Effects 4"};
String[] effectNames6 = {"Beat Repeat", "Flanger Offset", "Delay Panning", "Reverb Diffusion", "Flanger Hi-Pass", "Flanger Rate"};
String[][] effectNames = {effectNames1, effectNames2, effectNames3, effectNames4, effectNames5, effectNames6};

int[] effectSends1 = {0, 1, 2, 3, 4, 5};
int[] effectSends2 = {6, 7, 8, 9, 10, 11};
int[] effectSends3 = {12, 13, 14, 15, 16, 17};
int[] effectSends4 = {18, 19, 20, 21, 22, 23};
int[] effectSends5 = {24, 25, 26, 27, 28, 29};
int[] effectSends6 = {30, 31, 32, 33, 34, 35};
int[][] effectSends = {effectSends1, effectSends2, effectSends3, effectSends4, effectSends5, effectSends6};

/* Global properties
_____________________________________________________________________ */

Instrument[] instruments = new Instrument[6];
Effects[] effects = new Effects[6];
Serial myPort;
PFont font2;
PFont font1;
int _barHeight = 80;

MidiIO midiIO;
MidiOut midiOut;

/* XBee setup
_____________________________________________________________________ */

int xbeeNumber = 1;
char identifier = '*';
int numResends = 0;

long lastRequest;
int requestReSend = 300;

/* Sensor Properties
_____________________________________________________________________ */

int cube1Side = -1;
int cube2Side = -1;
int gyroReading = 0;

color[] colors = {#ff2700, #0930ff, #ff40ff, #fffb00, #00fcff, #00fa00};



/* Setup
_____________________________________________________________________ */

void setup()
{
   size(screen.width, screen.height, JAVA2D);
   //size(1024, 768, JAVA2D);
   background(0);
   smooth();
   
   //font1 = loadFont("Helvetica-14.vlw");
   //font2 = loadFont("Helvetica-20.vlw"); 
   font1 = createFont("Helvetica", 20);
   font2 = createFont("Helvetica", 30);

   setupSerial();
   
   initMidi();
   
   createInstruments();
   
   sendRequest();
}

/* Setup Serial
_____________________________________________________________________ */

void setupSerial()
{
   println(Serial.list());
   myPort = new Serial(this, Serial.list()[1], 9600);
   myPort.bufferUntil('\n');
}

/* Create instruments
_______________________________________________ */

void createInstruments()
{
   int xPos = 220;
   
   for(int i = 0; i < 6; i++)
   {
      instruments[i] = new Instrument(i, xPos, 0, colors, font1, font2, instrumentNames[i], instrumentSends[i], effectNames[i], effectSends[i], 200, _barHeight, midiOut);
      
      xPos += 250;
   }
}

/* Draw
_____________________________________________________________________ */

void draw()
{
   background(10);
  
   updateInstruments();
   
   checkLastRequest();;
}

/* Update circles
_____________________________________________________________________ */

void updateInstruments()
{
   for(int i = 0; i < 6; i++)
   {
       // instruments
      if(cube1Side == i)   
      {
         instruments[i].setEffect(cube2Side);
         instruments[i].setEffectValue(gyroReading);
         instruments[i].update(true);
      }
      else                     
      {
         instruments[i].update(false);
      }
   }  
}

/* Serial event
_____________________________________________________________________ */

void serialEvent(Serial myPort)
{
   String message = myPort.readStringUntil('\n');
   
   if(message != null) 
   {
      message = trim(message);

      checkMessage(message);
   }
}

/* Init midi
__________________________________________________________________________ */

void initMidi()
{
   midiIO = MidiIO.getInstance(this);
   midiIO.printDevices();
   midiOut = midiIO.getMidiOut(0,0); 
}

/* Check serial message
_____________________________________________________________________ */

void checkMessage(String message)
{
   /*
   
   [0] = identifier (*)
   [1] = computer num
   [2] = xbee num
   [3] = curside
   [4] = gyroreading

   */
   
      // split string at commas
     int sensors[] = int(split(message, ','));
     char c1 = message.charAt(0);
     
     println(message);
  
     if(sensors.length > 4) 
     {       
         if(c1 == identifier && sensors[1] == xbeeNumber)
         {
            // If xbee 2         
            if(sensors[2] == 2)
            {
               cube1Side = sensors[3];
            }
            // if xbee 3
            else if(sensors[2] == 3)
            {
               cube2Side = sensors[3];
               
               if(cube2Side > -1)
               {
                  gyroReading = checkValue(formerValues[cube2Side], sensors[4]);
                  
                  formerValues[cube2Side] = sensors[4];
               }
               else
               {
                 gyroReading = 0;  
               }
            }
            
            curXbee = (curXbee == 2) ? 3 : 2;
         
            sendRequest();
         }
     }  
}

/* Check gyro value
_____________________________________________________________________ */

float returnNum;

int checkValue(int formerValue, int nowValue)
{ 
   returnNum = 0;
   
   // reverse
   switch(cube2Side)
   {
         case 2:
         case 3:
         case 5:
            nowValue = (nowValue < 0) ? abs(nowValue) : -(nowValue);
            break;
    }
  
    if(abs(formerValue - nowValue) > threshold)
    {       
      returnNum = nowValue / divideNum;
    }  
     
    return round(returnNum);
}

/* Send Request
_____________________________________________________________________ */

void sendRequest()
{  
   lastRequest = millis();  
   
   myPort.write(identifier);
   myPort.write(curXbee);
   
   //println("Message sent to Arduino number: " + curXbee);
}

/* Check last request
_____________________________________________________________________ */

void checkLastRequest()
{
   if(millis() - lastRequest > requestReSend)
   {
      numResends++;
      
      println("No response " + numResends + ", resending to XBee " + curXbee);
      gyroReading = 0;
      
      sendRequest();
   }
}

void reset()
{
   for(int i = 0; i < instruments.length; i++)
   {
      instruments[i].reset();
   }
}

/* Testing
_____________________________________________________________________ */

void keyPressed()
{
  switch(key)
  {
     case '1':
        cube1Side = 0;
        break; 
     case '2':
        cube1Side = 1;
        break; 
     case '3':
        cube1Side = 2;
        break; 
     case '4':
        cube1Side = 3;
        break; 
     case '5':
        cube1Side = 4;
        break;
     case '6':
        cube1Side = 5;
     case ' ':
        reset();
        break;  
  }
}
