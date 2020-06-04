#include "serial_lib.h"

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uint16_t serial_read_16bit()
{
  serial_wait_next_command(); // wait for 2 bytes
  return Serial.read() + (Serial.read() << 8);  // read a 16-bit number from 2 bytes
}

uint32_t serial_read_32bit()
{
  serial_wait_four_bytes(); // wait for 4 bytes
  return (Serial.read() + (Serial.read() << 8) +
    (Serial.read() << 16) + (Serial.read() << 24));  // read a 16-bit number from 2 bytes
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uint16_t serial_read_16bit_no_wait()
{
  // same as serial_read_16bit but not checking for available bytes
  // used only where speed is critical
  return Serial.read() + (Serial.read() << 8);  // read a 16-bit number from 2 bytes
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
void serial_write_16bit(uint16_t writeData){
  uint8_t outBuffer[2];
  outBuffer[0] = writeData & 255;
  outBuffer[1] = (writeData >> 8)  & 255;
  Serial.write(outBuffer, 2);
}
void serial_write_16bit(uint_fast16_t writeData){
  uint8_t outBuffer[2];
  outBuffer[0] = writeData & 255;
  outBuffer[1] = (writeData >> 8)  & 255;
  Serial.write(outBuffer, 2);
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
void serial_write_32bit(uint32_t writeData){
  uint8_t outBuffer[4];
  outBuffer[0] = writeData & 255;
  outBuffer[1] = (writeData >> 1*8)  & 255;
  outBuffer[2] = (writeData >> 2*8)  & 255;
  outBuffer[3] = (writeData >> 3*8)  & 255;
  Serial.write(outBuffer, 4);
}

void serial_write_32bit(uint_fast32_t writeData){
  uint8_t outBuffer[4];
  outBuffer[0] = writeData & 255;
  outBuffer[1] = (writeData >> 1*8)  & 255;
  outBuffer[2] = (writeData >> 2*8)  & 255;
  outBuffer[3] = (writeData >> 3*8)  & 255;
  Serial.write(outBuffer, 4);
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
void serial_wait_next_command(){
  // wait for 2 bytes to be available
  while(Serial.available() < 2){}
}

void serial_wait_four_bytes(){
  // wait for 2 bytes to be available
  while(Serial.available() < 4){}
}

// define general functions here
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// setup serial
void setup_serial(){
  Serial.begin(9600);
  Serial.println();
  Serial.println("-------------------------------------------------------------");
  Serial.println("----------------------  Teensy Trigger  ---------------------");
  Serial.println("--------------------  Ver.2.1 | JR | 2019  -------------------");
  Serial.println("-------------------------------------------------------------");
  delay(1000);
}
