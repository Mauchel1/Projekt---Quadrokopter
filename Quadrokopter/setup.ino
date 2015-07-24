
void setup_RxTx(){
  radio.begin();
  radio.openReadingPipe(1,pipe);
  radio.startListening();
}

void setup_motor(){ 
    motor_1.attach(MOTOR1);
    motor_2.attach(MOTOR2);
    motor_3.attach(MOTOR3);
    motor_4.attach(MOTOR4);
//    pinMode(MOTOR1,OUTPUT); 
//    pinMode(MOTOR2,OUTPUT);
//    pinMode(MOTOR3,OUTPUT);
//    pinMode(MOTOR4,OUTPUT);
//    analogWrite(MOTOR1, MOTOR_STOP);
//    analogWrite(MOTOR2, MOTOR_STOP);
//    analogWrite(MOTOR3, MOTOR_STOP);
//    analogWrite(MOTOR4, MOTOR_STOP);
}

void setup_accelgyro(){
    Wire.begin();
    #ifdef acc_debug
        Serial.println("Initializing I2C devices...");
    #endif
    accelgyro.initialize();// initialize device
    #ifdef acc_debug
        // verify connection
        Serial.println("Testing device connections...");
        Serial.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");
    #endif
}
