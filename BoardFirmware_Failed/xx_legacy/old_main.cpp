#include <Arduino.h> // always required when using platformio

// wait a few clock cycles
#define NOP __asm__ __volatile__ ("nop\n\t") // ~6 ns = one clock cycle
#define WAIT_10_NS NOP; NOP;
#define WAIT_20_NS NOP; NOP; NOP; NOP;
#define WAIT_40_NS WAIT_20_NS; WAIT_20_NS;
#define WAIT_60_NS WAIT_20_NS; WAIT_20_NS; WAIT_20_NS;
#define WAIT_80_NS WAIT_40_NS; WAIT_40_NS;
#define WAIT_100_NS WAIT_80_NS; WAIT_20_NS;
#define WAIT_200_NS WAIT_100_NS; WAIT_100_NS;
#define WAIT_400_NS WAIT_200_NS; WAIT_200_NS;


// port bits = 87654321;
// trig port = 12834567;
                                 // 12834567
#define ALL_TRIGGER_HIGH GPIOC_PDOR = 0b11111111; //
#define ALL_TRIGGER_LOW GPIOC_PDOR = 0b00000000; //
#define ALL_LED_HIGH GPIOD_PDOR = 0b11111111; //
#define ALL_LED_LOW GPIOD_PDOR = 0b00000000; //
#define ENABLE_1234 GPIOC_PDOR =  (GPIOC_PDOR & 0b00100111 ) | 0b11011000
  // enables trigger outputs 1 (bit 8), 2 (bit 7), 3 (bit 5) and 4 (bit 4)
  // should not affect the other bits (needs to be tested!)
#define DISABLE_1234 GPIOC_PDOR = (GPIOC_PDOR & 0b00100111 ) | 0b00000000 //

#define TRIG_IN_1 ((GPIOB_PDIR >> 0) & 1U) // trig in 1 = bit 1 = no shift
#define TRIG_IN_2 ((GPIOB_PDIR >> 1) & 1U) // trig in 2 = bit 2 = one shift

// port B (GPIOB_PDOR/GPIOB_PDIR) -> used for trigger input
const uint8_t PORT_B_PINS[] = {16,17};
// port C (GPIOC_PDOR/GPIOC_PDIR) -> used for trigger output
const uint8_t PORT_C_PINS[] = {15,22,23,9,10,13,11,12};
// port D (GPIOD_PDOR/GPIOD_PDIR) -> used for LED output
const uint8_t PORT_D_PINS[] = {2,14,7,8,6,20,21,5};


// trigger input Port to teensy Port mapping -> PORT_C_PINS
// trigger in | teensy trigger in PIN | teensy port bit
// 1 | 16 | 0
// 2 | 17 | 1


// trigger output Port to teensy Port mapping -> PORT_C_PINS
// trigger out | teensy trigger out PIN | teensy port bit
// 1 | 12 | 8
// 2 | 11 | 7
// 3 | 10 | 5
// 4 | 9  | 4
// 5 | 23 | 3
// 6 | 22 | 2
// 7 | 15 | 1
// 8 | 13 | 6

// triggerPort to LED mapping -> PORT_D_PINS
// led out | teensy LED PIN | teensy port bit
// 1 | 5  | 8
// 2 | 21 | 7
// 3 | 6  | 5
// 4 | 8  | 4
// 5 | 7  | 3
// 6 | 14 | 2
// 7 | 2  | 1
// 8 | 20 | 6

// this is how we set, clear and toggle trigger ports
// triggerPort |= (1UL << 1-1); // set 0st bit = first port
// triggerPort &= ~(1UL << 3-1); // clear 2nd bit = third port
// triggerPort ^= (1UL << 5-1); // toggle 4th bit = 5th port

void setup() {
  pinMode(PORT_B_PINS[0],INPUT);
  pinMode(PORT_B_PINS[1],INPUT);
  for (int i=0; i<8; i++){
    pinMode(PORT_C_PINS[i],OUTPUT);
    pinMode(PORT_D_PINS[i],OUTPUT);
  }
}


// void loop() {
//   uint8_t lastTrigState = TRIG_IN_1;
//   while(true) {
//     if (TRIG_IN_1 != lastTrigState)
//     {
//       ALL_TRIGGER_HIGH;
//       lastTrigState = !lastTrigState;
//       WAIT_400_NS;
//       ALL_TRIGGER_LOW;
//     }
//   }
// }

void loop() {
  delay(500);
  WAIT_400_NS;
  ALL_TRIGGER_HIGH;
  ALL_LED_HIGH;
  delay(500);
  WAIT_400_NS;
  ALL_TRIGGER_LOW;
  ALL_LED_LOW;
}
