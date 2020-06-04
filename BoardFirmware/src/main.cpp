#include "..\lib\trigger_lib.cpp"

TeensyTrigger MyTrig;

void setup() {
  MyTrig.setup_io_pins();
  setup_serial();
}

void loop() {
  while(true){ // loop is slower than while(true)
    // here starts our state machine
    MyTrig.check_for_serial_command();
    switch (MyTrig.currentCommand) {
      // -----------------------------------------------------------------------
      case DO_NOTHING:
        MyTrig.do_nothing();
        break;

      // -----------------------------------------------------------------------
      case ENABLE_INT_TRIGGER:
        MyTrig.chen_stand_alone_trigger();
        break;
      // -----------------------------------------------------------------------
      case ENABLE_CASCADE_TRIGGER:
        MyTrig.chen_cascade_trigger();
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

