#include "DHT.h" //uses the DHT libarary from Adafruit

#define DHTPIN 2     // what pin we're connected to
#define HPIN 13
#define CPIN 12
#define DHTTYPE DHT22   // DHT 22  (AM2302)

// Connect pin 1 (on the left) of the sensor to +5V
// Connect pin 2 of the sensor to whatever your DHTPIN is
// Connect pin 4 (on the right) of the sensor to GROUND
// Connect a 10K resistor from pin 2 (data) to pin 1 (power) of the sensor

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  
  Serial.begin(9600); 
  Serial.println("Incubator Beta");
  pinMode(HPIN,OUTPUT);
  pinMode(CPIN,OUTPUT);
  dht.begin(); //initializies the sensor
  
}

void loop() {
  // Wait a few seconds between measurements.
  delay(2000);

  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float h = dht.readHumidity();
  // Read temperature as Celsius
  float t = dht.readTemperature();
  // Read temperature as Fahrenheit
  float f = dht.readTemperature(true);
  
  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  
  Serial.print("Temperature: "); 
  Serial.print(t);
  Serial.println(" *C ");
  
  int b1=Serial.parseInt();
  if (Serial.read() == '\n') 
  {
    if(b1==1)
    {
      digitalWrite(HPIN, HIGH);
      digitalWrite(CPIN, LOW);
    }
    if(b1==2)
    {
      digitalWrite(HPIN, LOW);
      digitalWrite(CPIN, HIGH);
    }
    if(b1==0)
    {
      digitalWrite(HPIN, LOW);
      digitalWrite(CPIN, LOW);
    }     
  }
}
