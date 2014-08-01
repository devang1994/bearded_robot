#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"
#include "DHT.h"



#define DHTTYPE DHT22
#define DHTPIN 13
// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMS2 = Adafruit_MotorShield(0x61); 
Adafruit_MotorShield AFMS1 = Adafruit_MotorShield(0x60); 
// Or, create it with a different I2C address (say for stacking)
// Adafruit_MotorShield AFMS = Adafruit_MotorShield(0x61); 

// Select which 'port' M1, M2, M3 or M4. In this case, M1
Adafruit_DCMotor *peltier1 = AFMS1.getMotor(4);
Adafruit_DCMotor *peltier2 = AFMS2.getMotor(4);
//Adafruit_DCMotor *myMotor3 = AFMS.getMotor(3);
// You can also make another motor on port M2
//Adafruit_DCMotor *myOtherMotor = AFMS.getMotor(2);

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Adafruit Motorshield v2 - DC Motor test!");

  AFMS1.begin();  // create with the default frequency 1.6KHz
  //AFMS.begin(1000);  // OR with a different frequency, say 1KHz
  AFMS2.begin();
  Serial.println("Begun");
  // Set the speed to start, from 0 (off) to 255 (max speed)
   
  peltier1->setSpeed(255);
  peltier1->run(FORWARD);
  // turn on motor
  peltier1->run(RELEASE);

  peltier2->setSpeed(255);
  peltier2->run(FORWARD);
  // turn on motor
  peltier2->run(RELEASE);

  dht.begin();//initializes the sensor
  
  Serial.println("Initialized");
}

void loop() {

  float h = dht.readHumidity();
  // Read temperature as Celsius
  float t = dht.readTemperature();
  // Read temperature as Fahrenheit
  float f = dht.readTemperature(true);
  
  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t) || isnan(f)) 
  {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  Serial.print("Temperature: "); 
  Serial.print(t);
  Serial.println(" *C ");  

  Serial.println("In loop");
  //myMotor3->run(FORWARD);
  //myMotor3->setSpeed(255);
  peltier1->run(FORWARD);
  peltier1->setSpeed(255);

  peltier2->run(FORWARD);
  peltier2->setSpeed(255);
  
  delay(100);

  //Serial.print("tech");
  //myMotor->run(RELEASE);
  //delay(1000);
}

