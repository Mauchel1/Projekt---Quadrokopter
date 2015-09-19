/****************************
↓(1)   (2)↑
    \ /
    / \
↑(3)   (4)↓

INFOS
map(value, fromLow, fromHigh, toLow, toHigh)
****************************/
#include <nRF24L01.h> // für RX/TX
#include <RF24.h> // für RX/TX
#include <RF24_config.h> // für RX/TX
#include <SPI.h>  // für RX/TX

#include <Servo.h> //für Motoren

#include "Config.h" // defines
#include "math.h"

#include <I2Cdev.h>  //für Accelerometer
#include <MPU6050.h> // Accelerometer
#include <Wire.h> // für Accelerometer

#include <PID_v1.h> //PID Control

//**************TESTFUNKTIONEN*************
// unten im Code im Mainloop einschalten (RX/TX)
// Fernbedienung_Poti(); // Nimmt die Fernbedienungsdaten ohne Senden+Empfangen aus Poti entgegen

//**************DEBUGGING***************
//  #define debug // um debugging generell einzuschalten

//  #define acc_debug // serielle ausgabe accelerometer/gyroskop
//  #define acc_stabil_debug // serielle ausgabe stabile acc/gyro
//  #define rxtx_debug //Fernbedienung - empfangene daten
//  #define motor_debug //die 4 Motorwerte, die rausgehen
//  #define winkel_debug // die beiden Sollwinkel und die vorhandenen winkel x,y
//  #define korrekt_debug // die 3 Korrekturwerte der Motoren Nick, Kipp, Dreh

//  #define seriell_Fernbedienung // Serielles Empfangen der Fernbedienungsdaten

//*****************DEKLARATIONEN*****************
//Accelerometer
MPU6050 accelgyro;
int16_t ax, ay, az;
int16_t gx, gy, gz;
int16_t axalt[ARRAYANZAHL], ayalt[ARRAYANZAHL], azalt[ARRAYANZAHL];
int16_t gxalt[ARRAYANZAHL], gyalt[ARRAYANZAHL], gzalt[ARRAYANZAHL];
int16_t axstabil, aystabil, azstabil;
int16_t gxstabil, gystabil, gzstabil;
float scale = 16384.0;
float xZero = 770;
float yZero = 270;
float zZero = -400;
float xACCskaliert;
float yACCskaliert;
float zACCskaliert;

//Motor
Servo motor_1;
Servo motor_2;
Servo motor_3;
Servo motor_4;

int motor_1_wert;
int motor_2_wert;
int motor_3_wert;
int motor_4_wert;

//Korrekturwerte
double nickkorrekt = 0;
double kippkorrekt = 0;
double drehkorrekt = 0;

double soll_nick = 0;
double soll_kipp = 0;
double soll_dreh = 0;

//Lage
float winkel[4] = {0.0 , 0.0 , 0.0 , 0.0}; // 0-XIST, 1-YIST, 2-XSOLL, 3-YSOLL
int schub = MOTOR_STOP;

//PID-Regler
double AbweichungX = 0;
double AbweichungY = 0;
//PID(&Input, &Output, &Setpoint, Kp, Ki, Kd, Direction)
PID NickPID(&AbweichungX, &nickkorrekt, &soll_nick, Kp, Ki, Kd, DIRECT);
PID KippPID(&AbweichungY, &kippkorrekt, &soll_kipp, Kp, Ki, Kd, DIRECT);

//RX/TX
const uint64_t pipe = 0xE8E8F0F0E1LL; // Define the transmit pipe
RF24 radio(CE_PIN, CSN_PIN); // Create a Radio
int fernbedienung[5];  // Enthält alle Fernbedienungsdaten 0-L_X, 1-L_Y, 2-R_X, 3-R_Y, 4-Data

//*****************SETUP*******************
void setup() {
#ifdef debug
  Serial.begin(38400); // beliebig
  while (!Serial);
#endif
  setup_accelgyro();
  setup_motor();
  setup_RxTx();
  NickPID.SetMode(AUTOMATIC);
  KippPID.SetMode(AUTOMATIC);
}

//*************LOOP*******************
void loop() {

  // ***********Accelerometer***********
  // read raw accel/gyro measurements from device
  accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
  // these methods (and a few others) are also available
  // accelgyro.getAcceleration(&ax, &ay, &az);
  // accelgyro.getRotation(&gx, &gy, &gz);

  // **************RX/TX****************
#ifndef seriell_Fernbedienung
  //        empfangen();
  Fernbedienung_Poti(); //Muss auskommentiert sein im Flugmodus
#endif

#ifdef seriell_Fernbedienung
  serielle_Fernbedienung();
#endif

  // *************Berechnung************
  acc_stabilisieren();
  berechnen();

  // *************Debugging*************
#ifdef debug
  debugging();
#endif

  // ***********Motor setzen************
  motor_1.write(motor_1_wert);
  motor_2.write(motor_2_wert);
  motor_3.write(motor_3_wert);
  motor_4.write(motor_4_wert);
  //    analogWrite(MOTOR1, motor_1_wert);
  //    analogWrite(MOTOR2, motor_2_wert);
  //    analogWrite(MOTOR3, motor_3_wert);
  //    analogWrite(MOTOR4, motor_4_wert);
}

void empfangen() {

  if ( radio.available() ) {
    // Read the data payload until we've received everything
    bool done = false;
    while (!done) {
      // Fetch the data payload
      done = radio.read( fernbedienung, sizeof(fernbedienung) );
    }
  }
  else {
    //TODO
  }
}

void serielle_Fernbedienung() {
  if ( Serial.available() > 0 )
  {
    static char input[16] = {0};
    static uint8_t i = 0;
    char c = Serial.read();

    if ( c >= '0' && c <= '9' && i < 15 )
      input[i++] = c;

    else
    {
      input[i] = '\0';
      i = 0;

      fernbedienung[1] = atoi(input);
      Serial.print(fernbedienung[1]);
      Serial.print('a');
    }

  }
}

void Fernbedienung_Poti() {
  fernbedienung[1] = analogRead(A1);
}

void acc_stabilisieren() {

  schieben(ax, axalt, ARRAYANZAHL);
  schieben(ay, ayalt, ARRAYANZAHL);
  schieben(az, azalt, ARRAYANZAHL);
  schieben(gx, gxalt, ARRAYANZAHL);
  schieben(gy, gyalt, ARRAYANZAHL);
  schieben(gz, gzalt, ARRAYANZAHL);

  axstabil = mittelwert(axalt, ARRAYANZAHL);
  aystabil = mittelwert(ayalt, ARRAYANZAHL);
  azstabil = mittelwert(azalt, ARRAYANZAHL);
  gxstabil = mittelwert(gxalt, ARRAYANZAHL);
  gystabil = mittelwert(gyalt, ARRAYANZAHL);
  gzstabil = mittelwert(gzalt, ARRAYANZAHL);
}

void schieben(int16_t dataneu, int16_t data[], int z) {
  int i = 0;
  for (i = 0 ; i < z - 1 ; i ++) {
    data[i] = data[i + 1];
  }
  data[z - 1] = dataneu;
}

float mittelwert (int16_t daten[], int anzahl) {
  float mittel = 0;
  int i = 0;
  for (i = 0 ; i < anzahl ; i++) {
    mittel += daten[i];
  }
  return mittel / anzahl;
}

void berechnen() {

  schub = map(fernbedienung[1], FB_1_MIN, FB_1_MAX, SCHUB_MIN, SCHUB_MAX);
  soll_nick = map(fernbedienung[3], FB_3_MIN, FB_3_MAX, NICK_MIN, NICK_MAX);// SENSIBEL_NICK;
  soll_kipp = map(fernbedienung[2], FB_2_MIN, FB_2_MAX, KIPP_MIN, KIPP_MAX);// SENSIBEL_KIPP;
  soll_dreh = map(fernbedienung[0], FB_0_MIN, FB_0_MAX, DREH_MIN, DREH_MAX);// SENSIBEL_DREH;

  winkelberechnung();
  regelung();

  if (schub > EINSCHALTSPEED) {
    motor_1_wert = schub - nickkorrekt + kippkorrekt ;//+ drehkorrekt;
    if (motor_1_wert > SCHUB_MAX - 1) motor_1_wert = SCHUB_MAX - 1;
    else if (motor_1_wert < EINSCHALTSPEED) motor_1_wert = EINSCHALTSPEED;

    motor_2_wert = schub - nickkorrekt - kippkorrekt ;//- drehkorrekt;
    if (motor_2_wert > SCHUB_MAX - 1) motor_2_wert = SCHUB_MAX - 1;
    else if (motor_2_wert < EINSCHALTSPEED) motor_2_wert = EINSCHALTSPEED;

    motor_3_wert = schub + nickkorrekt + kippkorrekt ;//- drehkorrekt;
    if (motor_3_wert > SCHUB_MAX - 1) motor_3_wert = SCHUB_MAX - 1;
    else if (motor_3_wert < EINSCHALTSPEED) motor_3_wert = EINSCHALTSPEED;

    motor_4_wert = schub + nickkorrekt - kippkorrekt ;//+ drehkorrekt;
    if (motor_4_wert > SCHUB_MAX - 1) motor_4_wert = SCHUB_MAX - 1;
    else if (motor_4_wert < EINSCHALTSPEED) motor_4_wert = EINSCHALTSPEED;
  }
  else {
    motor_1_wert = MOTOR_STOP;
    motor_2_wert = MOTOR_STOP;
    motor_3_wert = MOTOR_STOP;
    motor_4_wert = MOTOR_STOP;
  }
}

void winkelberechnung() { //TODO

  xACCskaliert = (axstabil - xZero) / scale * -1;
  yACCskaliert = (aystabil - yZero) / scale;
  zACCskaliert = (azstabil - zZero) / scale;
  //SOLLWINKEL X,Y
  winkel[2] = 0;
  winkel[3] = 0;
  //ISTWINKEL X,Y
  //    winkel[0] = atan2(azstabil,axstabil)*180.0/PI;
  //    winkel[1] = atan2(azstabil,aystabil)*180.0/PI;
  winkel[0] = atan(zACCskaliert / sqrt(pow(yACCskaliert, 2) + pow(xACCskaliert, 2)));
  winkel[1] = atan(yACCskaliert / sqrt(pow(zACCskaliert, 2) + pow(xACCskaliert, 2)));
  winkel[0] = winkel[0] * (180.0 / PI);
  winkel[1] = winkel[1] * (180.0 / PI);
}

void regelung() {
  nickkorrekt = 0;
  kippkorrekt = 0;
  drehkorrekt = 0;
  AbweichungX = winkel[2] - winkel[0];
  AbweichungY = winkel[3] - winkel[1];
  NickPID.Compute();
  KippPID.Compute();
//  SetOutputLimits(min, max)//TODO
}
