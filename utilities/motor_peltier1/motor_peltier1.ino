/* 
This is a test sketch for the Adafruit assembled Motor Shield for Arduino v2
It won't work with v1.x motor shields! Only for the v2's with built in PWM
control

For use with the Adafruit Motor Shield v2 
---->	http://www.adafruit.com/products/1438
*/

#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

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
  
  Serial.println("Initialized");
}

void loop() {
  

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
