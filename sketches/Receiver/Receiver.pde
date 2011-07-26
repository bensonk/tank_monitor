char incomingByte = 0;

void setup() {
  Serial.begin(9600);
  for(int i = 2; i <= 6; i++)
    pinMode(i, OUTPUT);
  
  // Pin 6 is the radio -- we're turning it on permanently here. 
  digitalWrite(6, HIGH);
  
  // Set the LED array to zero. If we never hear from the other
  // end, we show emptiness. 
  updateLEDs('0');
}

void updateLEDs(char b) {
  // Some shortcuts if you're typing directly into the terminal: 
  // 1: a, 2: c, 3: g, 4: o
  digitalWrite(2, B0001 & b);
  digitalWrite(3, B0010 & b);
  digitalWrite(4, B0100 & b);
  digitalWrite(5, B1000 & b);
}

void loop() {
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    if(incomingByte <= '9' && incomingByte >= '0')
      incomingByte = incomingByte - '0';
    updateLEDs(incomingByte);
  }
}
