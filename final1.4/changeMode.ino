//------------------------------------------------------------------------------ mode ----
void setMode(int sign) {
  lcd.print(sign);
  switch (sign) {
    case 49 : {
        mode = 0;
        break;
      }
    case 50: {
        posiX = 0;     //归零坐标
        posiY = 0;
        timeflag2 = millis();
        timeflag3 = millis();
        mode = 1;
        break;
      }
    case 51: {
        mode = 2;
        timeflag1 = millis();
        break;
      }
    case 52: {
        mode = 3;
        bforward = true;
        break;
      }
    case  53: {
        mode = 3;
        bturnLeft = true;
        break;
      }
    case 54: {
        mode = 3;
        bturnRight = true;
        break;
      }
    case 55: {
        mode = 3;
        bbackward = true;
        break;
      }
    case 56: {
        mode = 3;
        bstopward = true;
        break;
      }
    case 57 : {
        mode = 3;
        bforwarddd = true;
        break;
      }
    default: mode = 0;
  }
}


void setSign() {
  if (Serial.available() > 0) {
    signData = Serial.read();
    lcd.print(signData);
    switch (signData) {
      case 120://x

        totalStop();
        break;
      case 109://m
        if (Serial.available() > 0) setMode(Serial.read());
        else  {

          if (mode == 3) mode = -1;       //if data error
        }
        break;
      case 116://t
        if (Serial.available() > 0) threshold = Serial.read();
        if (mode == 3) mode = -1;            //if no data movement
        break;
      case 108://l
        if (mode == 1) {
          if (Serial.available() > 0) Xtogo = Serial.read();
          else break;
          if (Serial.available() > 0) {
            Ytogo = Serial.read();
            lcd.print(Xtogo);
          }
          else break;
          goToLocate = true;
        }
        break;

      default:
        if (mode == 3) mode = -1;            //if no data movement
        break;
    }
  }
  else  if (mode == 3) mode = -1;         //if no data movement

}
