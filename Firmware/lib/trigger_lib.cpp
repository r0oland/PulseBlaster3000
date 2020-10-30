#include "trigger_lib.h"

// LED stuff
FASTLED_USING_NAMESPACE

// defin LED parameters
#define DATA_PIN LED_STRIP_PIN
#define LED_TYPE WS2812
#define COLOR_ORDER GRB
#define NUM_LEDS 5 
#define BRIGHTNESS 20
CRGB leds[NUM_LEDS]; // contains led info, this we set first, the we call led show

void setup_leds()
{
  // tell FastLED about the LED strip configuration
  FastLED.addLeds<LED_TYPE, 19, COLOR_ORDER>(leds, NUM_LEDS).setCorrection(TypicalLEDStrip);

  // set master brightness control
  FastLED.setBrightness(BRIGHTNESS);

  FastLED.clear();
  FastLED.show();
  for (int led = 0; led < NUM_LEDS; led++)
  {
    leds[led] = CRGB::White;
    delay(50);
    FastLED.show();
  }
  delay(50);
  pulse_leds(5, 3);
  FastLED.clear();
  FastLED.show();
  set_led_status(1);
}

void pulse_leds(uint8_t nPulses, uint8_t pulseSpeed)
{
  uint8_t ledFade = 255;      // start with LEDs off
  int8_t additionalFade = -5; // start with LEDs getting brighter
  uint8_t iPulse = 0;

  while (iPulse < nPulses)
  {
    for (uint8_t iLed = 0; iLed < NUM_LEDS; iLed++)
    {
      leds[iLed].setRGB(255, 255, 255);
      leds[iLed].fadeLightBy(ledFade);
    }
    FastLED.show();
    ledFade = ledFade + additionalFade;
    // reverse the direction of the fading at the ends of the fade:
    if (ledFade == 0 || ledFade == 255)
      additionalFade = -additionalFade;
    if (ledFade == 255)
      iPulse++;
    delay(pulseSpeed); // This delay sets speed of the fade. I usually do from 5-75 but you can always go higher.
  }
}

void set_led_status(uint8_t status)
{
  // (0 = all good, 1 = working, 2 = error, 3 = cascade, 4 = scope)
  CRGB rgb = CRGB::Black; // LED off
  switch (status)
  {
  case 0:
    rgb = CRGB::White; 
    break;
  case 1:
    rgb = CRGB::Orange; 
    break;
  case 2:
    rgb = CRGB::DarkRed; 
    break;
  case 3: // cascade
    rgb = CRGB::DarkSlateBlue; 
    break;
  case 4: // free running / scope mode
    rgb = CRGB::DarkGreen; 
    break;
  default:
    break;
  }
  for (uint8_t iLed = 0; iLed < NUM_LEDS; iLed++)
    leds[iLed] = rgb;
  FastLED.show();
}


//NanoDelay %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// delay for a given number of nano seconds
// less sensitive to interrupts and DMA
// max delay is 4 seconds
// NOTE:  minimum pulse width is ~700 nsec, accuracy is ~ -0/+40 ns
// NOTE:  you can't trust this code:
//        compiler or library changes will change timing overhead
//        CPU speed will effect timing

// prepare before, so less delay later
static uint32_t nano_ticks;

// constexpr double CLOCK_RATE = 240.0E6; // MCU clock rate - measure it for best accuracy
constexpr double CLOCK_RATE = 240.0E6; // MCU clock rate - measure it for best accuracy
// constexpr unsigned NANO_OVERHEAD = 470;         // overhead - adjust as needed
constexpr unsigned NANO_OVERHEAD = 130; // overhead - adjust as needed
// constexpr unsigned NANO_JITTER = 18;            // adjusts for jitter prevention - leave at 18
constexpr unsigned NANO_JITTER = 0; // adjusts for jitter prevention - leave at 18

void setup_nano_delay(uint32_t nanos)
{
  // set up cycle counter
  ARM_DEMCR |= ARM_DEMCR_TRCENA;
  ARM_DWT_CTRL |= ARM_DWT_CTRL_CYCCNTENA;

  if (nanos < NANO_OVERHEAD) // we can't do less than this
    nanos = NANO_OVERHEAD;

  // how many cycles to wait
  nano_ticks = ((nanos - NANO_OVERHEAD) / (1.0E9 / CLOCK_RATE)) + .5;

  if (nano_ticks < NANO_JITTER)
    nano_ticks = NANO_JITTER;

} // Setup_Nano_Delay()

// Do the delay specified above.
// You may want to disable interrupts before and after
FASTRUN void wait_nano_delay(void)
{
  uint32_t start_time = ARM_DWT_CYCCNT;
  uint32_t loop_ticks = nano_ticks - NANO_JITTER;

  // loop until time is almost up
  while ((ARM_DWT_CYCCNT - start_time) < loop_ticks)
  {
    // could do other things here
  }

  if (NANO_JITTER)
  {                      // compile time option
    register unsigned r; // for debugging

    // delay for the remainder using single instructions
    switch (r = (nano_ticks - (ARM_DWT_CYCCNT - start_time)))
    {
    case 18:
      __asm__ volatile("nop"
                       "\n\t");
    case 17:
      __asm__ volatile("nop"
                       "\n\t");
    case 16:
      __asm__ volatile("nop"
                       "\n\t");
    case 15:
      __asm__ volatile("nop"
                       "\n\t");
    case 14:
      __asm__ volatile("nop"
                       "\n\t");
    case 13:
      __asm__ volatile("nop"
                       "\n\t");
    case 12:
      __asm__ volatile("nop"
                       "\n\t");
    case 11:
      __asm__ volatile("nop"
                       "\n\t");
    case 10:
      __asm__ volatile("nop"
                       "\n\t");
    case 9:
      __asm__ volatile("nop"
                       "\n\t");
    case 8:
      __asm__ volatile("nop"
                       "\n\t");
    case 7:
      __asm__ volatile("nop"
                       "\n\t");
    case 6:
      __asm__ volatile("nop"
                       "\n\t");
    case 5:
      __asm__ volatile("nop"
                       "\n\t");
    case 4:
      __asm__ volatile("nop"
                       "\n\t");
    case 3:
      __asm__ volatile("nop"
                       "\n\t");
    case 2:
      __asm__ volatile("nop"
                       "\n\t");
    case 1:
      __asm__ volatile("nop"
                       "\n\t");
    default:
      break;
    } // switch()
  }   // if
} // Nano_Delay()

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TeensyTrigger::TeensyTrigger() {}
TeensyTrigger::~TeensyTrigger() {}

// setup IO PINs ---------------------------------------------------------------
void TeensyTrigger::setup_io_pins()
{
  // set two trigger inputs as digital input pins
  pinMode(TRIG_IN_PINS[0], INPUT);
  pinMode(TRIG_IN_PINS[1], INPUT);
  // set 8 trigger outputs and corresponding LEDs as digital output pins
  for (uint8_t i = 0; i < 8; i++)
  {
    pinMode(TRIG_OUT_PINS[i], OUTPUT);
  }
}

// make led blink --------------------------------------------------------------
void TeensyTrigger::do_nothing()
{
  // TODO - replace with LED strip based slow breathing
  // maybe just let case breather and stat LEDs be green?
}

// make led blink --------------------------------------------------------------
void TeensyTrigger::show_led_welcome()
{
  // TODO - replace with LED strip based welcome
}

// check for new command -------------------------------------------------------
FASTRUN uint_fast8_t TeensyTrigger::check_for_serial_command()
{
  // read a command if one was send
  if (Serial.available() >= 2)
  {
    this->currentCommand = serial_read_16bit_no_wait(); // read the incoming byte:
    return 1;
  }
  else
    return 0;
}

// trigger in simple scope mode, this triggers on all channels (for now...)
FASTRUN void TeensyTrigger::scope()
{
  uint_fast32_t lastCommandCheck = 0;
  uint_fast32_t triggerCounter = 0;
  uint_fast8_t doTrigger = true;
  uint32_t lastTriggerTime = 0;

  // read confing as send from matlab
  uint_fast32_t triggerPeriod = serial_read_32bit(); // trigger period in us
  uint_fast32_t trigOnTime = serial_read_32bit();
  uint_fast32_t nTrigger = serial_read_32bit();

  setup_nano_delay(trigOnTime);
  serial_write_16bit(TRIGGER_STARTED); // send the "we are triggering" command

  while (doTrigger)
  {
    while ((micros() - lastTriggerTime) < triggerPeriod)
      {}; // here we wait...

    lastTriggerTime = micros();
    TRIG_OUT_PORT = 0b11111111; // all high
    wait_nano_delay();
    TRIG_OUT_PORT = 0b00000000; // all low
    triggerCounter++; 
    // if nTrigger = 0 we trigger forevere, otherwise check if we are done
    if (nTrigger && (triggerCounter >= nTrigger))
      doTrigger = 0;

    // check if we got a new serial command to stop triggering
    // COMMAND_CHECK_INTERVALL is high, so we only check once in a while
    if ((millis() - lastCommandCheck) >= COMMAND_CHECK_INTERVALL)
    {
      lastCommandCheck = millis();
      if (Serial.available() >= 2)
      {
        this->currentCommand = serial_read_16bit_no_wait();
        if (this->currentCommand == STOP_SCOPE)
          doTrigger = false;
      }
    }
  } // while (doTrigger)

  serial_write_16bit(DONE); // send the "ok, we are done" command
  serial_write_32bit(triggerCounter);
  this->currentCommand = DO_NOTHING; // exit state machine
}

//------------------------------------------------------------------------------
// start trigger cascade when trigger input changes (both rising and falling)
FASTRUN void TeensyTrigger::cascade(){
  // send the "we are triggering" command
  serial_write_16bit(CASCADE_STARTED); 

  // send trigger duration in microseconds
  uint_fast32_t trigOnTime = serial_read_32bit(); // [us]
  
  // send the "we are triggering" command again
  serial_write_16bit(CASCADE_STARTED); 

  TRIG_OUT_PORT = 0b00000000; // make sure we start low...
  bool waitForTrigger = true;
  uint_fast32_t triggerCounter = 0;
  
  while(waitForTrigger){
    if (TRIG_IN_1 != lastTrigState){
      TRIG_OUT_PORT = 0b11111111; // enable triggers
      lastTrigState = !lastTrigState;
      // our trigger signal is blocking and 20 us is just short enough to allow
      // for max trigger rate of 50 kHz, so we miss triggers here if the
      // trigger input is faster than that
      // delayMicroseconds(20); 
      delayMicroseconds(trigOnTime);
      TRIG_OUT_PORT = 0b00000000; // disable all trigger
      triggerCounter++;
    }

    // check if we got a new serial command to stop triggering
    // COMMAND_CHECK_INTERVALL is high, so we only check once in a while
    if ((millis() - lastCommandCheck) >= COMMAND_CHECK_INTERVALL)
    {
      lastCommandCheck = millis();
      if (Serial.available() >= 2)
      {
        currentCommand = serial_read_16bit_no_wait();
        if (currentCommand == DO_NOTHING)
          waitForTrigger = false;
      }
    }
  }
  TRIG_OUT_PORT = 0b00000000; // make sure we end low...
  serial_write_16bit(DONE); // send the "ok, we are done" command
  serial_write_32bit(triggerCounter);
  currentCommand = DO_NOTHING; // exit state machine
}