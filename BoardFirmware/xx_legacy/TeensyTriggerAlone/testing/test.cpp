#include "..\lib\teensy_lib.cpp"

uint16_t triggerOut = US_TRIG; //
  // bit 8 = DAQ_TRIG = TRIG 1
  // bit 7 = US_TRIG = TRIG 2
  // bit 5 = ONDA_TRIG = TRIG 3
  // bit 4 = EDGE_TRIG = TRIG 4
bool doTrigger = true; //
uint8_t lastTrigState = 0; //
uint8_t trigOutChMask = 0b00000000;

uint16_t slowMode; // delay in ms or us
uint16_t triggerPeriod;
uint16_t nTrigger; // trigger how many times?
uint32_t triggerCounter;
uint32_t lastSamplingTime; // used during stage calibration

void setup() {
  setup_io_pins();
  Serial.begin(9600);
  currentCommand = SET_TRIGGER_CH;
  for (int iLed = 0; iLed<8; iLed++)
  {
    digitalWriteFast(PORT_D_PINS[iLed],HIGH);
    delay(50);
  }
}


void loop() {
  while(true){
    TRIG_OUT_PORT = 0b11111111; // enable triggers as prev. defined
    delayMicroseconds(1);
    TRIG_OUT_PORT = 0b00000000; // disable all trigger
    delayMicroseconds(1000);
  }
}
