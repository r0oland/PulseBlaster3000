#ifndef TRIGGER_LIB
#define TRIGGER_LIB

#include <Arduino.h> // always required when using platformio
#include "..\lib\serial_lib.cpp"
#include "wait.h" // always required when using platformio

// port B (GPIOB_PDOR/GPIOB_PDIR) -> used for trigger input
const uint8_t TRIG_IN_PINS[] = {16,17};
// port C (GPIOC_PDOR/GPIOC_PDIR) -> used for trigger output
const uint8_t TRIG_OUT_PINS[] = {15,22,23,9,10,13,11,12};
// port D (GPIOD_PDOR/GPIOD_PDIR) -> used for LED output
const uint8_t LED_OUT_PINS[] = {2,14,7,8,6,20,21,5};


// Define serial communication commands (shared with matlab)
const uint_fast16_t DO_NOTHING = 0;
const uint_fast16_t STOP_TRIGGER = 23;
const uint_fast16_t ENABLE_INT_TRIGGER = 66;
const uint_fast16_t DISABLE_INT_TRIGGER = 67;
const uint_fast16_t ENABLE_CASCADE_TRIGGER = 68;
const uint_fast16_t DISABLE_CASCADE_TRIGGER = 69;
const uint_fast16_t CHECK_CONNECTION = 88;
const uint_fast16_t READY_FOR_COMMAND = 98;
const uint_fast16_t DONE = 99;

// bits in GPIOC_PDOR, NOT counted from zero...
constexpr uint_fast8_t DAQ_BIT = 8;      // ch 1
constexpr uint_fast8_t ANDOR_BIT = 7;    // ch 2
constexpr uint_fast8_t STIM_BIT = 5;     // ch 3
constexpr uint_fast8_t BLOCK_BIT = 4;    // ch 4
constexpr uint_fast8_t AOD_BIT = 3;      // ch 5
constexpr uint_fast8_t FAST_CAM_BIT = 2; // ch 6

// All below might not be needed or has not been tested... %%%%%%%%%%%%%%%%%%%%%
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define ALL_TRIGGER_HIGH GPIOC_PDOR = 0b11111111; //
#define ALL_TRIGGER_LOW GPIOC_PDOR = 0b00000000; //
#define ALL_LED_HIGH GPIOD_PDOR = 0b11111111; //
#define ALL_LED_LOW GPIOD_PDOR = 0b00000000; //
#define ENABLE_1234 GPIOC_PDOR =  (GPIOC_PDOR & 0b00100111 ) | 0b11011000
  // enables trigger outputs 1 (bit 8), 2 (bit 7), 3 (bit 5) and 4 (bit 4)
  // should not affect the other bits (needs to be tested!)
#define DISABLE_1234 GPIOC_PDOR = (GPIOC_PDOR & 0b00100111 ) | 0b00000000

#define TRIG_IN_1 ((GPIOB_PDIR >> 0) & 1U) // trig in 1 = bit 1 = no shift
#define TRIG_IN_2 ((GPIOB_PDIR >> 1) & 1U) // trig in 2 = bit 2 = one shift

// PORTS and PIN fun %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#define TRIG_IN_PORT GPIOB_PDIR
#define TRIG_OUT_PORT GPIOC_PDOR
#define LED_PORT GPIOD_PDOR

#define TRIG_IN1_HIGH (GPIOB_PDIR & (1UL << 0))
#define TRIG_IN1_LOW  (GPIOB_PDIR ^ (1UL << 0))
#define TRIG_IN1      (GPIOB_PDIR ^ (1UL << 0))

#define TRIG_IN2_HIGH GPIOB_PDIR & (1UL << 1)
#define TRIG_IN2_LOW GPIOB_PDIR ^ (1UL << 1)

// TeensyTrigger Class Definition %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
class TeensyTrigger {
  public:
    inline TeensyTrigger();
    inline ~TeensyTrigger();

    inline void setup_io_pins();
    inline void show_led_welcome();
    inline void set_all_led_brightness(uint8_t ledPower);
    inline void do_nothing();

    FASTRUN uint_fast8_t check_for_serial_command();

    FASTRUN void chen_stand_alone_trigger();
    FASTRUN void chen_cascade_trigger();
    // FASTRUN void execute_serial_command();
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    // variables for analog & digital temperature measurements
    const uint_fast16_t COMMAND_CHECK_INTERVALL = 200; // [ms] wait this long before checking for serial

    uint8_t trigOutChMask = 0b00000000;
    uint8_t ledOutMask = 0b00000000;
    uint_fast16_t currentCommand = DO_NOTHING; // for incoming serial data
    uint_fast8_t lastTrigState = 0;
    uint_fast32_t lastCommandCheck = 0;
    uint8_t ledBrightness = 0; // use in do nothing to fade LEDs
    uint8_t fadeIn = 1; // getting brighter or darker
    uint_fast32_t lastNothingCheck = 0; // used in do nothing to fade leds

  private:

};

#endif
