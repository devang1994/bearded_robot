int hPin=13;
int cPin=12;
void setup()
{
  Serial.begin(9600);
  pinMode(hPin,OUTPUT);
  pinMode(cPin,OUTPUT);
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
      else
      {
        digitalWrite(hPin, LOW);
        digitalWrite(cPin, HIGH);
      }
    }
  }
}
      
