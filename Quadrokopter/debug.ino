void debugging(){
    delay(100);
    #ifdef acc_debug 
        Serial.print("a/g:\t");  // display tab-separated accel/gyro x/y/z values
        Serial.print(ax); Serial.print("\t");
        Serial.print(ay); Serial.print("\t");
        Serial.print(az); Serial.print("\t");
        Serial.print(gx); Serial.print("\t");
        Serial.print(gy); Serial.print("\t");
        Serial.println(gz);
    #endif
    #ifdef acc_stabil_debug 
        Serial.print("a/g:\t");  // display tab-separated accel/gyro x/y/z values
        Serial.print(axstabil); Serial.print("\t");
        Serial.print(aystabil); Serial.print("\t");
        Serial.print(azstabil); Serial.print("\t");
        Serial.print(gxstabil); Serial.print("\t");
        Serial.print(gystabil); Serial.print("\t");
        Serial.println(gzstabil);
    #endif
    #ifdef rxtx_debug  
        if ( radio.available() ){
        Serial.print("Speed = ");
        Serial.print(fernbedienung[1]);
        Serial.print("\tDrehung = ");      
        Serial.print(fernbedienung[0]);
        Serial.print("\tNicken = ");
        Serial.print(fernbedienung[3]);
        Serial.print("\tKippen = ");
        Serial.print(fernbedienung[2]);
        Serial.print("\tRestdata = ");
        Serial.println(fernbedienung[4]);
        }
        else{ 
        Serial.println("No radio available");
        }
    #endif
    #ifdef motor_debug
        Serial.print("Motor 1 = ");
        Serial.print(motor_1_wert);
        Serial.print("\tMotor 2 = ");
        Serial.print(motor_2_wert);
        Serial.print("\tMotor 3 = ");
        Serial.print(motor_3_wert);
        Serial.print("\tMotor 4 = ");
        Serial.println(motor_4_wert);
    #endif
    #ifdef winkel_debug
        Serial.print("Sollwinkel X , Y = ");
        Serial.print(winkel[2]);
        Serial.print("\t");
        Serial.print(winkel[3]);
        Serial.print("\tIstwinkel X , Y = ");
        Serial.print(winkel[0]);
        Serial.print("\t");
        Serial.println(winkel[1]);
    #endif
}
