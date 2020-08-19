#include "..\lib\trigger_lib.cpp"

TeensyTrigger MyTrig;

void setup() {
  MyTrig.setup_io_pins();
  setup_serial();
  setup_leds();
  set_led_status(0);
}

void loop() {
  while(true){ // loop is slower than while(true)
    // here starts our state machine
    MyTrig.check_for_serial_command();
    switch (MyTrig.currentCommand) {
      // -----------------------------------------------------------------------
      case DO_NOTHING:
        MyTrig.do_nothing();
        set_led_status(0);
        break;

      // -----------------------------------------------------------------------
      case ENABLE_SCOPE:
        set_led_status(1);
        MyTrig.scope();
        set_led_status(0);
        break;

      // -----------------------------------------------------------------------
      case ENABLE_CASCADE:
        MyTrig.cascade();
        break;

      // -----------------------------------------------------------------------
      case ENABLE_LMI_MODE:
        MyTrig.chen_scope();
        break;
      // -----------------------------------------------------------------------
      case ENABLE_CHEN_CASCADE:
        MyTrig.chen_cascade();
        break;

      case CHECK_CONNECTION:
        serial_write_16bit(READY_FOR_COMMAND); // send the "ok, we are done" command
        MyTrig.currentCommand = DO_NOTHING; // exit state machine
        break;

      // -----------------------------------------------------------------------
      default:
        // statements
        MyTrig.currentCommand = DO_NOTHING; // exit state machine
        break;
    } // switch
  } // while
} // loop()

