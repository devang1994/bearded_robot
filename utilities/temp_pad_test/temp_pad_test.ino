int oPin=13;

void setup()
{
  Serial.begin(9600);
  pinMode(oPin,OUTPUT);
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
        digitalWrite(oPin, HIGH);
      }
      else
        digitalWrite(oPin, LOW);
    }
  }
}
      
