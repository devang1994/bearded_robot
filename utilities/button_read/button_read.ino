const int ledPin =  8;      // the number of the LED pin

// Variables will change:
int ledState = LOW;             // ledState used to set the LED
long previousMillis = 0;        // will store last time LED was updated

// the follow variables is a long because the time, measured in miliseconds,
// will quickly become a bigger number than can be stored in an int.
long interval = 1000;           // interval at which to blink (milliseconds)
int pushButton =2;
void setup() 
{
  // set the digital pin as output:
  pinMode(pushButton, INPUT);
  Serial.begin(9600);  
}

void loop()
{
  int buttonState = digitalRead(pushButton);
  // print out the state of the button:
  Serial.println(buttonState);
  delay(1000);     
}
