#include "DHT.h"
#define DHTTYPE DHT22
#define DHTPIN 2
DHT dht(DHTPIN, DHTTYPE);
#define hPin 12
#define cPin 13
#define MARGIN 0.2
//remember pin configurations have been swapped aroubnd and are different from previous versions

/*gets 1 number as inputs from serial, if number is 1 it transmits temperature, 
if number is 2 it sets the desired temperature ,
by taking another input in the same line*/

float t;
float set_temp=28;
void setup()
{
  Serial.begin(9600);
  pinMode(hPin,OUTPUT);
  pinMode(cPin,OUTPUT);
  dht.begin();

}

void loop()
{
  
  if (Serial.available() > 0) 
  {

    // look for the next valid integer in the incoming serial stream:
    int instruction = Serial.parseInt(); //if 1 read temperature , 
    
    if(instruction==1)
    {
      t = dht.readTemperature();
      Serial.println(t);
    }

    if(instruction==2)
    {
      set_temp=Serial.parseInt();
      Serial.println("done");
    }

        
    }
  }


  if(t<(set_temp-MARGIN))
  {
    //Serial.println("heating");
    digitalWrite(hPin, HIGH);
    digitalWrite(cPin, LOW);
  }
  if(t>(set_temp+MARGIN))
  {
    //Serial.println("Cooling");      
    digitalWrite(hPin, HIGH);
    digitalWrite(cPin, LOW);
  }
  if((t<(set_temp+MARGIN))&&(t>(set_temp-MARGIN)))
  {
    //Serial.println("going for a nap");
    digitalWrite(hPin, LOW);
    digitalWrite(cPin, LOW);
  }
}

