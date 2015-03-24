#include <nRF24L01.h>
#include <RF24.h>
#include <RF24_config.h>
#include <SPI.h>

//*********CONFIG***********
#define CE_PIN   9
#define CSN_PIN 10
#define JOYSTICK_L_X A0
#define JOYSTICK_L_Y A1
#define JOYSTICK_R_X A2
#define JOYSTICK_R_Y A3

//*******DEBUGGING MODE**********
//#define debug

//*******DEKLARATIONEN**********
const uint64_t pipe = 0xE8E8F0F0E1LL; // Define the transmit pipe
RF24 radio(CE_PIN, CSN_PIN); // Create a Radio
int joystick[5]; 

void setup() {
  radio.begin();
  radio.openWritingPipe(pipe);
  #ifdef debug
  Serial.begin(9600);
  #endif
}

void loop() {
  joystick[0] = analogRead(JOYSTICK_L_X);
  joystick[1] = analogRead(JOYSTICK_L_Y);
  joystick[2] = analogRead(JOYSTICK_R_X);
  joystick[3] = analogRead(JOYSTICK_R_Y);
  joystick[4] = 66;//TODO - hierher muss ne funktion, die alle knöpfe etc als analogwert wiedergibt
  radio.write( joystick, sizeof(joystick) );
  #ifdef debug
  debugging();
  #endif
}

void debugging(){

Serial.print("send_L_X = ");
Serial.print(joystick[0]);
Serial.print("\tsend_L_Y = ");      
Serial.print(joystick[1]);
Serial.print("\tsend_R_X = ");
Serial.print(joystick[2]);
Serial.print("\tsend_R_Y = ");      
Serial.print(joystick[3]);
Serial.print("\tsend_DATA = ");
Serial.println(joystick[4]);


}
