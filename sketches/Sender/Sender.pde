/* * * * * * * * * * * * * * * *\
 * Tank Monitor: Sender
 *
 * This is the code that runs 
 * at the site of the tank, 
 * monitoring float switches.
 *
 * Benson Kalahar
 * July 2011
\* * * * * * * * * * * * * * * */

int cycleTimeSeconds = 2;

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

void sleep(int secs) {
  delay(secs*1000);
}

void send_byte(byte b) {
  digitalWrite(6, HIGH);
  delay(35); // Let the radio start up
  Serial.begin(9600);
  for(int i = 0; i < 10; i++)
    Serial.write(b);
  delay(20); // Let the radio finish sending
  digitalWrite(6, LOW);
}

int read_value() {
  digitalWrite(13, HIGH);
  int inputs = 0;
  inputs += digitalRead(2) * 0b0001;
  inputs += digitalRead(3) * 0b0010;
  inputs += digitalRead(4) * 0b0100;
  inputs += digitalRead(5) * 0b1000;
  digitalWrite(13, LOW);
  return inputs;
}

void loop() {
  int val = read_value();
  send_byte(96+val);
  sleep(cycleTimeSeconds);
}



