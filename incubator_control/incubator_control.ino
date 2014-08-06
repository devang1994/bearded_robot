#include "DHT.h"
#define DHTTYPE DHT22
#define DHTPIN 2
DHT dht(DHTPIN, DHTTYPE);
#define hPin 12
#define cPin 13
#define MARGIN 0.3
//remember pin configurations have been swapped aroubnd and are different from previous versions

float set_temp=28;
void setup()
{
  Serial.begin(9600);
  pinMode(hPin,OUTPUT);
  pinMode(cPin,OUTPUT);
  dht.begin();
  Serial.println("enter temperature. enter 999 to nap ");
}

void loop()
{
  float t = dht.readTemperature();
  int b1=Serial.parseInt();
  if (Serial.read() == '\n') 
  {
    Serial.print("Trying to control temperature at :");
    Serial.println(b1);
    set_temp=b1;
  }
  
  if(t<(set_temp-MARGIN))
  {
    Serial.println("heating");
    digitalWrite(hPin, HIGH);
    digitalWrite(cPin, LOW);
  }
  if(t>(set_temp+MARGIN))
  {
    Serial.println("Cooling");      
    digitalWrite(hPin, HIGH);
    digitalWrite(cPin, LOW);
  }
  if(t==999)
  {
    Serial.println("going for a nap");
    digitalWrite(hPin, LOW);
    digitalWrite(cPin, LOW);
  }


  
  if (isnan(t)) 
  {
    Serial.println("Failed to read from DHT sensor!");
  }

  Serial.print("Temperature: "); 
  Serial.print(t);
  Serial.println(" *C "); 
  delay(3000);

}
