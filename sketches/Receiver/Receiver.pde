char incomingByte = 0;

void setup() {
  Serial.begin(9600);
  for(int i = 2; i <= 5; i++)
    pinMode(i, OUTPUT);
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
    // read the incoming byte:
    incomingByte = Serial.read();
    if(incomingByte <= '9' && incomingByte >= '0')
      incomingByte = incomingByte - '0';

    // say what you got:
    Serial.print("Received: ");
    Serial.println(incomingByte, BIN);
    updateLEDs(incomingByte);
  }
}
