/*
   v1.4 new features:
   GO
*/
//-------------------------------------------------------------------------------------------
/*
   receieved from bluetooth:(char)
   1    mode 0 静止加湿
   2    mode 1 移动加湿
   3    mode 2 定点加湿， 到达阈值停止
   ===================================
   mode 3   手动控制
   --------------------
   4    前进
   5    左转
   6    右转
   7    后退
   8    停止
   9    点动式前进
*/
//-------------------------------------------------------------------------------------------


#include <Wire.h>
#include <time.h>
#include <LiquidCrystal_I2C.h>
#include <dht11.h>
#include <math.h>

dht11 DHT11;
LiquidCrystal_I2C lcd(0x3F, 16, 2);

#define DHT11PIN    38      //DHT11

#define leftTrig    30      //HC-SR04
#define leftEcho    32
#define midTrig     22
#define midEcho     24
#define rightTrig   26
#define rightEcho   28


#define input1    3         //AC motor
#define output1   2
#define input2    5
#define output2   4
#define input3    6
#define output3   7
#define input4    9
#define output4   8

#define RelayPin  36        //relay

//--------------------------------------------------------------------------------data------
#define analogSpeed 0.0035955     //(cm/ms)
#define digitalSpeed 0.00635
#define HR3 0.8660254       //0.5*√3


//--------------------------------------------------------------------------------global-----
unsigned long timeflag = 0;     //用于控制向GUI传输数据时间
unsigned long timeflag1 = 0;    //用于控制定点加湿时间
unsigned long timeflag2 = 0;    //用于计算小车位置
unsigned long timeflag3 = 0;    //用于长时间直线行驶强制刷新坐标
unsigned long timeflag4 = 0;    //用于前往湿度最低的地方
int mode = -1;                   //模式标志
int signData;                  //传输数据标志
long a[3];                      //超声波数据
int threshold = 60;             //当前设置的湿度阈值
float posiX = 0;                //当前小车坐标（dm）
float posiY = 0;
float Xtogo = 0;                //matlab指定的适度最低位置
float Ytogo = 0;
int carDirection = 1;
/*    Direction demo:          120°
                     | Y+
                     |
                    (1)
                     |
                     |
   —————————————————— X+
                     |
        (2)          |          (3)
                     |
                     |
                     |
*/
bool bforward = false;
bool bforwarddd = false;
bool bstopward = false;
bool bturnLeft = false;
bool bturnRight = false;
bool bbackward = false;
bool goToLocate = false;
//-----------------------------------------------------------------------------funcDeclear---
void setSign();//接收指令设置模式
void setMode(int sign);
void printToMatlab(int modeSign);//输出
void humidifier(bool a);//控制加湿器
void lcdPrint();//LCD显示
void humidTest();
void totalStop();
void randomRun();
void addDistance(unsigned long runTime, int addMode); //更新坐标，参数：直行时间（ms），添加模式（不同速度）
void distance(long a[3]);//超声模块获取3个方向数据
long measuringDistance(int TrigPin, int EchoPin);
void chooseWay(long a[3]);
void forwarddd();
void forward();
void stopward();
void turnRight(int turnMode);
void turnLeft(int turnMode);
/*
   time data for turns:(ms)
   ---------------------------------
   time         angle       mode4Fcn
   480          120           1
   375          90            2
   260          60            3
   ---------------------------------
*/
void backward();
void toLocation(int x, int y);//前往指定位置
void GO (bool bx, int tx, bool by, int ty);
//================================================================================setup======

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  pinMode(input1, OUTPUT);        //car
  pinMode(output1, OUTPUT);
  pinMode(input2, OUTPUT);
  pinMode(output2, OUTPUT);
  pinMode(input3, OUTPUT);
  pinMode(output3, OUTPUT);
  pinMode(input4, OUTPUT);
  pinMode(output4, OUTPUT);

  pinMode(leftTrig, OUTPUT);       //HC-SR04
  pinMode(midTrig, OUTPUT);
  pinMode(rightTrig, OUTPUT);
  pinMode(leftEcho, INPUT);
  pinMode(midEcho, INPUT);
  pinMode(rightEcho, INPUT);

  lcd.init();                      // initialize the LCD
  lcd.backlight();

  pinMode(RelayPin, OUTPUT);      //relay

  humidifier(false);              //turn off the humidifier

  stopward();

  printToMatlab(1);                //

  timeflag = millis();
}

void loop()
{
  setSign();
  switch (mode) {
    case -1:
      break;
    case 0:
      //原地加湿
      if (DHT11.humidity < threshold) humidifier(true);
      else humidifier(false);
      stopward();
      break;
    case 1:
      //移动加湿，绘制图像，定点加湿完成后静止加湿
      humidifier(true);
      if (!goToLocate) {
        randomRun();
      }
      else {
        humidifier(false);
        addDistance(millis() - timeflag2, 1);
        toLocation(Xtogo, Ytogo);
        humidifier(true);
        mode = 0;
        
      }
      //长时间直线行驶强制刷新坐标
      if (millis() - timeflag3 > 5000) {
        addDistance(millis() - timeflag2, 1);
        timeflag2 = millis();
        timeflag3 = millis();
      }
      break;
    case 2:
      //定点加湿，到达阈值后更换地点加湿


      if ((millis() - timeflag1) > 10000 && (a[0] > 15 || a[1] > 15 || a[2] > 15)) {
        stopward();
        timeflag1 = millis();
        while (DHT11.humidity < threshold ){
          setSign();
          if(mode == 2){
            humidifier(true);
            if(millis() - timeflag1 > 2000){
              printToMatlab(2);
              timeflag1 = millis();
            }
          }
          else break;//----------------------------------bug,不能传数据
        }
        timeflag1 = millis();
      }
      else {
        humidifier(false);
        randomRun();
      }
      break;
    case 3://手动控制(仅执行一次）
      if (bforward) {
        forward();
        bforward = false;
      }

      if (bforwarddd) {
        forwarddd();
        delay(200);

        stopward();
        bforwarddd = false;
      }
      if (bstopward) {
        stopward();
        bstopward = false;
      }
      if (bturnLeft) {
        turnLeft(1);
        stopward();

        bturnLeft = false;
      }
      if (bturnRight) {
        turnRight(1);
        stopward();

        bturnRight = false;
      }
      if (bbackward) {
        backward();
        stopward();

        bbackward = false;
      }
      break;
    default:
      break;

  }
  //--------------------------------------- rx every 2 seconds
  if (millis() - timeflag > 2000) {
    printToMatlab(mode);
    timeflag = millis();
  }
}

