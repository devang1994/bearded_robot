int led1 = A5;
int led2 = A4;
int led3 = A3;

void setup()
{
  Serial.begin(9600);
  pinMode(led1, OUTPUT);
}

void loop()
{
  while(Serial.available()>0)
  {
    int b1=Serial.parseInt();
    int b2=Serial.parseInt();
    int b3=Serial.parseInt();
    if (Serial.read() == '\n') {
      analogWrite(led1,b1);
      analogWrite(led2,b2);
      analogWrite(led3,b3);
      
      Serial.print(b1, HEX);
      Serial.print(b2, HEX);
      Serial.println(b3, HEX);
    }
  }
  
  
}
