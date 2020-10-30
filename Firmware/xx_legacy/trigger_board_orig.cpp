
#include <Arduino.h> // always required when using platformio

// wait a few clock cycles
#define NOP __asm__ __volatile__ ("nop\n\t") // ~6 ns = one clock cycle
#define WAIT_10_NS NOP; NOP;
#define WAIT_20_NS NOP; NOP; NOP; NOP;
#define WAIT_40_NS WAIT_20_NS; WAIT_20_NS;
#define WAIT_60_NS WAIT_20_NS; WAIT_20_NS; WAIT_20_NS;
#define WAIT_80_NS WAIT_40_NS; WAIT_40_NS;
#define WAIT_100_NS WAIT_80_NS; WAIT_20_NS;

// output test:
// byte pinTable[] = {2,14,7,8,6,20,21,5};

const uint8_t TRIGGER_IN1 = 8;
const uint8_t TRIGGER_IN2 = 12;
const uint8_t TRIGGER_OUT1 = 14;
const uint8_t TRIGGER_OUT2 = 39;
uint8_t lastTrigState;

void setup() {
  pinMode(TRIGGER_IN1,INPUT_PULLUP);
  pinMode(TRIGGER_IN2,INPUT_PULLUP);
  pinMode(TRIGGER_OUT1,OUTPUT);
  pinMode(TRIGGER_OUT2,OUTPUT);
  lastTrigState = digitalReadFast(TRIGGER_IN1);
}

void loop() {
  while (true)
  {
    if (digitalReadFast(TRIGGER_IN1) != lastTrigState){
      digitalWriteFast(TRIGGER_OUT1, HIGH);
      digitalWriteFast(TRIGGER_OUT2, HIGH);
      lastTrigState = !lastTrigState;
      WAIT_100_NS;
      WAIT_100_NS;
      WAIT_100_NS;
      digitalWriteFast(TRIGGER_OUT1, LOW);
      digitalWriteFast(TRIGGER_OUT2, LOW);
    }
  }
}
