/* * * * * * * * * * * * * * * *\
 * Tank Monitor: Receiver
 *
 * This is the code that runs 
 * on the display unit, listening
 * for a signal from the unit at
 * the tank.
 *
 * Benson Kalahar
 * July 2011
\* * * * * * * * * * * * * * * */

char incomingByte = 0;

void setup() {
  Serial.begin(9600);
  for(int i = 2; i <= 5; i++)
    pinMode(i, OUTPUT);
  
  // Set the LED array to zero. If we never hear from the other
  // end, we show emptiness. 
  updateLEDs('0');
}

void updateLEDs(char b) {
  digitalWrite(2, B0001 & b);
  digitalWrite(3, B0010 & b);
  digitalWrite(4, B0100 & b);
  digitalWrite(5, B1000 & b);
}

void loop() {
  if (Serial.available() > 0)
    updateLEDs(Serial.read());
  else
    delay(250);
}
