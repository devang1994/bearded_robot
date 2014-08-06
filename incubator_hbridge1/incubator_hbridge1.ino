#include "DHT.h"
#define DHTTYPE DHT22
#define DHTPIN 2
DHT dht(DHTPIN, DHTTYPE);
#define hPin 13
#define cPin 12
void setup()
{
  Serial.begin(9600);
  pinMode(hPin,OUTPUT);
  pinMode(cPin,OUTPUT);
  dht.begin();
  Serial.println("1 to cool, 2 to heat and 0 to do nothing");
}

void loop()
{
  int b1=Serial.parseInt();
  if (Serial.read() == '\n') 
  {
    if(b1==1)
    {
      Serial.println("Cooling");
      digitalWrite(hPin, HIGH);
      digitalWrite(cPin, LOW);
    }
    if(b1==2)
    {
	Serial.println("HEAT");
      digitalWrite(hPin, LOW);
      digitalWrite(cPin, HIGH);
    }
    if(b1==0)
    {
      Serial.println("idleee");
      digitalWrite(hPin, LOW);
      digitalWrite(cPin,LOW);
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


