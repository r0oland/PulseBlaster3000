#include <Arduino.h> // always required when using platformio
#include <digitalWriteFast.h>

const uint8_t INPUT_PIN = 11;
const uint8_t OUTPUT_PIN = 9;

bool lastInputState;
bool inputState;
uint32_t lastTriggerOn = 0;        // will store last time LED was updated

////////////////////////////////////////////////////////////////////////////////
void setup(){
  // setup digital output pins
  pinMode(INPUT_PIN, INPUT_PULLUP);
  pinMode(OUTPUT_PIN, OUTPUT);

  lastInputState = digitalReadFast(INPUT_PIN);
}

////////////////////////////////////////////////////////////////////////////////
void loop() {
  // inputState = digitalReadFast(INPUT_PIN);
  digitalWriteFast(OUTPUT_PIN,digitalReadFast(INPUT_PIN))
  // if (digitalReadFast(INPUT_PIN) != lastInputState){
  //   lastInputState = !lastInputState;
  //   digitalWriteFast(OUTPUT_PIN, lastInputState);
  // }
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// support functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
