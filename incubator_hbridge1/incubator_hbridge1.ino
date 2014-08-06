#include "DHT.h"
#define DHTTYPE DHT22
#define DHTPIN 13
DHT dht(DHTPIN, DHTTYPE);
int hPin=13;
int cPin=12;

//in current setup 1 cools box, 2 heats box, 0 shuts it down

void setup()
{
  Serial.begin(9600);
  pinMode(hPin,OUTPUT);
  pinMode(cPin,OUTPUT);
  dht.begin();
}

void loop()
{
  while(Serial.available()>0)
  {
    
    
    int b1=Serial.parseInt();
    if (Serial.read() == '\n') 
    {
      if(b1==1)
      {
        digitalWrite(hPin, HIGH);
        digitalWrite(cPin, LOW);
      }
      if(b1==2)
      {
        digitalWrite(hPin, LOW);
        digitalWrite(cPin, HIGH);

      }
      if(b1==0)
      {
        digitalWrite(hPin, LOW);
        digitalWrite(cPin, LOW);
      }
    }
    
    float t = dht.readTemperature();
    if (isnan(t)) 
    {
      Serial.println("Failed to read from DHT sensor!");
    }
    
    Serial.print("Temperature: "); 
    Serial.print(t);
    Serial.println(" *C "); 
    delay(3000);
  }
}
      

