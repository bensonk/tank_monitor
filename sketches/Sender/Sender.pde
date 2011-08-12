/* * * * * * * * * * * * * * * *
 * Tank Monitor
 *
 * This is the code that runs 
 * at the site of the tank, 
 * monitoring float switches.
 *
 * Benson Kalar
 * July 2011
 * * * * * * * * * * * * * * * */

int cycleTimeSeconds = 5;

void setup() {
  Serial.begin(9600);

  // Pins 2-5 are the sensor inputs. 
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);
  pinMode(5, INPUT);
  
  // Pin 6 powers the radio. We can use this to only turn 
  // on the radio when we have something to say.
  pinMode(6, OUTPUT);
  // For now, we'll just leave it on, but a software update
  // here could save us a lot of power. 
  digitalWrite(6, HIGH);

  // Pin 13 powers the sensors. When we aren't actively
  // measuring conductivity, we can turn it off. 
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
}

int read_value() {
  digitalWrite(13, HIGH);
  int inputs = 0;
  inputs += !digitalRead(2);
  inputs += !digitalRead(3);
  inputs += !digitalRead(4);
  inputs += !digitalRead(5);
  digitalWrite(13, LOW);
  return inputs;
}  

void loop() {
  int val = read_value();
  Serial.print("Read values:");
  Serial.println(val);
  delay(1000 * cycleTimeSeconds);
}
