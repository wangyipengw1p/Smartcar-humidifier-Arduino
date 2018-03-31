//--------------------------------------------------------------------------tempAndHumid-----
void printToMatlab(int modeSign) {
  lcdPrint();
  char a;
  switch (modeSign) {
    case 1:
      //移动加湿
      a = 'x';
      Serial.print(a);
      Serial.print((char)posiX);
      a = 'y';
      Serial.print(a);
      Serial.print((char)posiY);
      a = 'h';
      Serial.print(a);
      Serial.print((char)DHT11.humidity);
      a = 't';
      Serial.print(a);
      Serial.print((char)DHT11.temperature);
      break;
    default:
      a = 'h';
      Serial.print(a);
      Serial.print((char)DHT11.humidity);
      a = 't';
      Serial.print(a);
      Serial.print((char)DHT11.temperature);
      break;
  }

  return;
}
void humidifier(bool a) {
  if (a)digitalWrite(RelayPin, HIGH);
  else digitalWrite(RelayPin, LOW);
  return;
}

void lcdPrint() {
  int chk = DHT11.read(DHT11PIN);
  lcd.clear();
  delay(5);
  lcd.setCursor(1, 0);
  lcd.print("T:");
  lcd.print((float)DHT11.temperature, 1);
  lcd.print((char) 0xDF);
  lcd.print("C  M:");
  lcd.print(mode);
  lcd.setCursor(1, 1);
  lcd.print("H:");
  lcd.print((float)DHT11.humidity, 1);
  lcd.print("%   T:");
  lcd.print(threshold);

}


void humidTest() {
  Serial.println("\n");
  Serial.print("Humidity (%): ");
  Serial.println((float)DHT11.humidity, 2);
  Serial.print("Temperature (oC): ");
  Serial.println((float)DHT11.temperature, 2);
}


