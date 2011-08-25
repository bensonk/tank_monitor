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

// CYCLE_TIME defines how long we sleep between measurements.
// Values are in seconds.
#define CYCLE_TIME 60

#include <avr/sleep.h>
#include <avr/wdt.h>


// The following definitions were borrowed from the watchdog
// sample code from KHM.
#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif
#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif
volatile boolean f_wdt=1;
int woken_times = 0;


void setup() {
  Serial.begin(9600);

  // Pins 2-5 are the sensor inputs.
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);
  pinMode(5, INPUT);

  // Pin 6 turns on power to the radio. We can use this to
  // only turn on the radio when we have something to say.
  pinMode(6, OUTPUT);
  digitalWrite(6, LOW);

  // Pin 13 powers the sensors. When we aren't actively
  // measuring conductivity, we keep it off to save power
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);

  // Power saving routines, telling the arduino to turn
  // off things we don't use when we're asleep
  cbi(SMCR, SE);
  cbi(SMCR, SM0);
  cbi(SMCR, SM1);
  cbi(SMCR, SM2);

  // Set up the timer that will wake the arduino from deep sleep
  setup_watchdog(6);
}

void sleep_now() {
  Serial.println("\ttaking a nap");
  delay(5); // Give the serial port a chance to finish up
  set_sleep_mode(SLEEP_MODE_PWR_DOWN);
  sleep_enable();
  sleep_mode();
  sleep_disable();
  detachInterrupt(0);
  delay(5);
  Serial.print("\twaking count = ");
  Serial.println(woken_times);
}

void sleep(int secs) {
  woken_times = 0;
  while(woken_times < secs)
    sleep_now();
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
  sleep(CYCLE_TIME);
}


// Borrowed from Watchdog Sleep Example
// I really wish I understood what this does
void setup_watchdog(int mode) {
  byte bb;
  int ww;
  if(mode > 9) mode = 9;
  bb = mode & 7;
  if(mode > 7) bb |= (1<<5);
  ww = bb;
  MCUSR &= ~(1<<WDRF);
  WDTCSR |= (1<<WDCE) | (1<<WDE);
  WDTCSR = bb;
  WDTCSR |= _BV(WDIE);
}

// Also borrowed.  This is the interrupt function that gets called
// every time the watchdog timer fires an interrupt.  With a known
// frequency (e.g. every 8s), we can effectively sleep a long time
// by shortcutting back to the sleep routine unless the timer has
// fired a certain number of times.
ISR(WDT_vect) {
  f_wdt = 1;
  woken_times++;
}
