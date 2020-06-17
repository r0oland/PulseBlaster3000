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
const uint8_t PORT_D_PINS[] = {2,14,7,8,6,20,21,5}; // prot D (GPIOD_PDOR/GPIOD_PDIR)
const uint8_t PORT_C_PINS[] = {15,22,23,9,10,11,12}; // prot C (GPIOC_PDOR/GPIOC_PDIR)

uint8_t lastTrigState;

void setup() {
  for (int i=0; i<8; i++){
    pinMode(PORT_D_PINS[i],OUTPUT);
    pinMode(PORT_C_PINS[i],OUTPUT);
  }
}

void loop() {
  while (true)
  {
    for (int i=0; i<=7; i++)
    {
      byte b = 1<<i;
      GPIOD_PDOR = b;
      delayMicroseconds(1);
      GPIOC_PDOR = b;
      delayMicroseconds(1);
    }
    for (int i=0; i<=7; i++)
    {
      byte b = 0<<i;
      GPIOD_PDOR = b;
      delayMicroseconds(1);
      GPIOC_PDOR = b;
      delayMicroseconds(1);
    }
  }
}
