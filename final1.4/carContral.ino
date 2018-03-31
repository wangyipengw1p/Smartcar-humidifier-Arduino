//---------------------------------------------------------------------------------car-----
void totalStop() {
  humidifier(false);
  stopward();
  mode = -1;
}

void randomRun() {
  /*
    forward1();
    long a[3];
    distance(a);
    if(a[1] > 40 )forward1();
    else if(a[1] < 30 && a[0] < 30 && a[2] < 30){
    backward();
    delay(500);
    }
    else {
    chooseWay(a);
    forward1();
    }
  */

  forward();

  distance(a);
  if (a[1] > 30 && a[0] >= 4 && a[2] >= 4) {
    forward();
  }
  else if (a[1] < 20 && a[0] < 20 && a[2] < 20) {
    addDistance(millis() - timeflag2, 1);
    backward();
    addDistance(-500, 2);
    distance(a);
    chooseWay(a);
    forward();
    timeflag2 = millis();
  }
  else {
    addDistance(millis() - timeflag2, 1);
    chooseWay(a);
    forward();
    timeflag2 = millis();
  }
}

void addDistance(unsigned long runTime, int addMode) {
  float s;
  if (addMode == 1)s = analogSpeed;
  else s = digitalSpeed;

  switch (carDirection) {
    case 1:
      posiY += s * runTime;
      break;
    case 2:
      posiX -= s * runTime * HR3;
      posiY -= s * runTime * 0.5;
      break;
    case 3:
      posiY -= s * runTime * 0.5;
      posiX += s * runTime * HR3;
      break;

  }

  //to ensure in char size (dm)
  if (posiX < -128)posiX += 256;
  if (posiX > 127)posiX -= 256;
  if (posiY < -128)posiY += 256;
  if (posiY < -128)posiY += 256;
}
void distance(long a[3]) {
  a[1] = measuringDistance(midTrig, midEcho);
  a[0] = measuringDistance(leftTrig, leftEcho);
  a[2] = measuringDistance(rightTrig, rightEcho);
  return;
}

long measuringDistance(int TrigPin, int EchoPin) {
  long duration;
  //pinMode(TrigPin, OUTPUT);
  digitalWrite(TrigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(TrigPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(TrigPin, LOW);

  //pinMode(EchoPin, INPUT);
  duration = pulseIn(EchoPin, HIGH);

  long flag = duration / 29 / 2;
  if (flag > 0 && flag < 100)return flag;
  else return 100;
}

void chooseWay(long a[3]) {

  if (a[0] > a[2]) {
    turnLeft(1);
    if (++carDirection > 3) carDirection = 1;
  }
  else {
    turnRight(1);
    if (--carDirection < 1) carDirection = 3;
  }

}

void toLocation(int x, int y) {
  if (carDirection == 2) {
    turnLeft(3);
    carDirection = 3;
  }
  else if (carDirection == 3) {
    turnRight(3);
    carDirection = 3;
  }

  /*    Direction demo in following fcn lines only:
                       | Y+
                       |
                      (1)
                       |
                       |
     ————(2)————————(4)———— X+
                       |
                       |
                      (3)
                       |
                       |
  */

  int xi, yi;
  xi = x - posiX;
  yi = y - posiY;
//----------------------------------------------------------------------------
  lcd.clear();
  lcd.print(xi);
  lcd.print(yi);
  lcd.print(Xtogo);
  lcd.print(Ytogo);
  GO(xi > 0, abs(xi / analogSpeed), yi > 0, abs(yi / analogSpeed));

  stopward();
  goToLocate = false;
  return;
}

void GO (bool bx, int tx, bool by, int ty) {
  if (abs(tx) < 50 && abs(ty) < 50) return;
  lcd.print("1");
  bool flag = false;
  if (bx) {
    while (carDirection != 4) {
      turnRight(2);
      if (--carDirection < 1) carDirection = 4;
    }
  }
  else {
    while (carDirection != 2) {
      turnRight(2);
      if (--carDirection < 1) carDirection = 4;
    }
  }
  timeflag4 = millis();
  while (millis() - timeflag4 < tx) {
    setSign();

    if (mode == 1) {
      distance(a);

      if (a[1] > 10)forward();
      else {
        flag = true;
        break;
      }
    }
    else return;
  }
  tx -= millis() - timeflag4;

  if (by) {
    while (carDirection != 1) {
      turnRight(2);
      if (--carDirection < 1) carDirection = 4;
    }
  }
  else {
    while (carDirection != 3) {
      turnRight(2);
      if (--carDirection < 1) carDirection = 4;
    }
  }
  //如果两个行进方向都有障碍则后退，然后递归
  distance(a);
  if (flag && a[1] < 10) {
    backward();
    ty += 500;
  }
  else {
    timeflag4 = millis();
    while (millis() - timeflag4 < ty) {
      setSign();
      if (mode == 1) {
        distance(a);
        if (a[1] > 10)forward();
        else break;

      }
      else return;

    }

    ty -= millis() - timeflag4;
  }
  GO(tx > 0, abs(tx), ty > 0, abs(ty));
  
}

//-------------------------------------------------------------------------------------------
void forwarddd() {
  digitalWrite(input1, HIGH); //给高电平
  digitalWrite(output1, LOW); //给低电平
  digitalWrite(input2, HIGH); //给高电平
  digitalWrite(output2, LOW); //给低电平
  digitalWrite(output3, HIGH); //给高电平
  digitalWrite(input3, LOW); //给低电平
  digitalWrite(output4, HIGH); //给高电平
  digitalWrite(input4, LOW); //给低电平

}

void forward() {
  analogWrite(input1, 130); //给高电平
  analogWrite(output1, 0); //给低电平
  analogWrite(input2, 130); //给高电平
  analogWrite(output2, 0); //给低电平
  analogWrite(output3, 130); //给高电平
  analogWrite(input3, 0); //给低电平
  analogWrite(output4, 130); //给高电平
  analogWrite(input4, 0); //给低电平

}

void stopward() {
  digitalWrite(input1, LOW); //给高电平
  digitalWrite(output1, LOW); //给低电平
  digitalWrite(input2, LOW); //给高电平
  digitalWrite(output2, LOW); //给低电平
  digitalWrite(output3, LOW); //给高电平
  digitalWrite(input3, LOW); //给低电平
  digitalWrite(output4, LOW); //给高电平
  digitalWrite(input4, LOW); //给低电平

}

void turnRight(int turnMode) {

  digitalWrite(input1, HIGH); //给高电平
  digitalWrite(output1, LOW); //给低电平
  digitalWrite(input2, LOW); //给高电平
  digitalWrite(output2, HIGH); //给低电平
  digitalWrite(output3, HIGH); //给高电平
  digitalWrite(input3, LOW); //给低电平
  digitalWrite(output4, LOW); //给高电平
  digitalWrite(input4, HIGH); //给低电平
  switch (turnMode) {
    case 1:
      delay(480);
      break;
    case 2:
      delay(375);
      break;
    case 3:
      delay(260);
      break;
  }

  return;
}


void turnLeft(int turnMode) {
  digitalWrite(input1, LOW); //给高电平
  digitalWrite(output1, HIGH); //给低电平
  digitalWrite(input2, HIGH); //给高电平
  digitalWrite(output2, LOW); //给低电平
  digitalWrite(output3, LOW); //给高电平
  digitalWrite(input3, HIGH); //给低电平
  digitalWrite(output4, HIGH); //给高电平
  digitalWrite(input4, LOW); //给低电平

  switch (turnMode) {
    case 1:
      delay(480);
      break;
    case 2:
      delay(375);
      break;
    case 3:
      delay(260);
      break;
  }
  return;
}

void backward() {
  digitalWrite(input1, LOW); //给高电平
  digitalWrite(output1, HIGH); //给低电平
  digitalWrite(input2, LOW); //给高电平
  digitalWrite(output2, HIGH); //给低电平
  digitalWrite(output3, LOW); //给高电平
  digitalWrite(input3, HIGH); //给低电平
  digitalWrite(output4, LOW); //给高电平
  digitalWrite(input4, HIGH); //给低电平
  delay(500);
  return;
}

