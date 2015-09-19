//****************CONFIG*********************
//MOTOR
  #define MOTOR1 4 //PIN
  #define MOTOR2 5 //PIN
  #define MOTOR3 6 //PIN
  #define MOTOR4 7 //PIN
  #define MOTOR_STOP 0
  #define EINSCHALTSPEED 15
  #define SENSIBEL_NICK 8 // je näher gegen 1 desto stärkere Reaktion
  #define SENSIBEL_KIPP 8
  #define SENSIBEL_DREH 8
//FERNBEDIENUNGSDATEN
  #define FB_0_MIN 0
  #define FB_0_MAX 1023
  #define FB_1_MIN 0
  #define FB_1_MAX 1023
  #define FB_2_MIN 0
  #define FB_2_MAX 1023
  #define FB_3_MIN 0
  #define FB_3_MAX 1023
//KORREKTURDATEN
  #define SCHUB_MIN 0
  #define SCHUB_MAX 180
  #define NICK_MIN -50
  #define NICK_MAX 50
  #define KIPP_MIN -50
  #define KIPP_MAX 50
  #define DREH_MIN -50
  #define DREH_MAX 50
//MPU
  #define ACC_X_OFFSET 770
  #define ACC_Y_OFFSET 270
  #define ACC_Z_OFFSET -400
  #define GYRO_X_OFFSET 0
  #define GYRO_Y_OFFSET 0
  #define GYRO_Z_OFFSET 0
  #define SKALA 16384.0
  #define ARRAYANZAHL 5 // je mehr desto stabiler, aber desto langsamer
//RX/TX
  #define CE_PIN   9
  #define CSN_PIN 10
//PID_REGLER
  #define STACKLAN 70 // für I-Regler
  #define P_FAKTOR_X 0.2
  #define P_FAKTOR_Y -0.2
  #define P_FAKTOR_Z 0.2
  #define I_FAKTOR_X 0.05
  #define I_FAKTOR_Y -0.05
  #define I_FAKTOR_Z 0.05
//LED
//TODO

