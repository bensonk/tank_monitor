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

int cycleTimeSeconds = 100;

void setup() {
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);
  pinMode(5, INPUT);
}

void loop() {
  int inputs = 0;
  inputs += digitalRead(2);
  inputs += digitalRead(3);
  inputs += digitalRead(4);
  inputs += digitalRead(5);

  Serial.write(inputs);
}
