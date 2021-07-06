#include <NewPing.h>
#include <Servo.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// WIFI
#define WIFI_SSID "Elshaarawy_2.4G"
#define WIFI_PASSWORD "123flowbase123"

// firebase paramters
#define API_KEY "AIzaSyBawpvLIAaC2pWVgTCKl-Wx3F_5Fpk50t0"
#define DATABASE_URL "https://fir-p-f-b0543-default-rtdb.europe-west1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

// firebase auth user emial and password
#define USER_EMAIL "user@test.com"
#define USER_PASSWORD "123456"

//Define Firebase auth and config
FirebaseAuth auth;
FirebaseConfig config;
FirebaseData fbdo;
FirebaseData feedStream;
FirebaseData waterStream;


// ultrasonic pins 
#define TRIG1  D0
#define ECHO1  D1
NewPing feed(TRIG1, ECHO1);//(report)
#define TRIG2  D2
#define ECHO2  D3
NewPing water(TRIG2, ECHO2);//(report)
// servo pin
#define SERVO_PIN  D4 //nutrition/is_tank_open //(observe)
Servo servo;
// pumb pin
#define PUMB   D5 //hydration/is_tank_open //(observe)
// buzzer pin
#define BUZZER  D8
// gas pin
#define GAS    A0 //(report)




void setup() 
{
  Serial.begin(9600);
  initPins();
  connectToWiFi();
  connectToFirebase();
  beginStreaming();
}

void loop() {
  if(Firebase.ready()){
    reportFeed();
    delay(3000);
    reportWater();
    delay(3000);
    reportGas();
    delay(3000);
  }

}

void initPins()
{
  pinMode (PUMB,OUTPUT);
  pinMode (BUZZER,OUTPUT);
  pinMode (GAS,INPUT);
  servo.attach(SERVO_PIN);
}

void connectToWiFi()
{
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
}

void connectToFirebase()
{
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}


// Feed
void reportFeed(){
  String value = getFeedLevel();
  bool isOk =Firebase.RTDB.setString(&fbdo, "/nutrition/food_level", value);
  Serial.println(isOk?"Feed Level Reported":fbdo.errorReason().c_str());
}
String getFeedLevel()
{
  float value = feed.ping_cm();
  return String(value/20);
}

// Water
void reportWater(){
  String value = getWaterLevel();
  bool isOk =Firebase.RTDB.setString(&fbdo, "/hydration/water_level", value);
  Serial.println(isOk?"Water Level Reported":fbdo.errorReason().c_str());
}
String getWaterLevel()
{
  float value = water.ping_cm();
  return String(value/13);
}

// gas
void reportGas(){
  String value = getGasLevel();
  bool isOk =Firebase.RTDB.setString(&fbdo, "/ventilation/air_quality", value);
  Serial.println(isOk?"Gas Level Reported":fbdo.errorReason().c_str());
}
String getGasLevel()
{
  float value = analogRead(GAS);
  return String(value/1023);
}

void beginStreaming(){
  if (!Firebase.RTDB.beginStream(&feedStream, "/nutrition/is_tank_open")){
    Serial.printf("feed sream begin error, %s\n\n", feedStream.errorReason().c_str());
  }
  Firebase.RTDB.setStreamCallback(&feedStream, feedCallback, feedStreamTimeoutCallback);

  if (!Firebase.RTDB.beginStream(&waterStream, "/hydration/is_tank_open")){
    Serial.printf("water sream begin error, %s\n\n", waterStream.errorReason().c_str());
  }
  Firebase.RTDB.setStreamCallback(&waterStream, waterCallback, waterStreamTimeoutCallback);
}
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////FEED////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void feedCallback(FirebaseStream data)
{
  int isOn = data.boolData();
  Serial.println(isOn?"FEED IS ON":"FEED IS OFF");
  servo.write(isOn?180:0);
}

void feedStreamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("Motor stream timeout, resuming...\n");
}
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////WATER////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void waterCallback(FirebaseStream data)
{
  int isOn = data.boolData();
  Serial.println(isOn?"WATER IS ON":"WATER IS OFF");
  digitalWrite(PUMB, isOn?HIGH:LOW);
}

void waterStreamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("lights stream timeout, resuming...\n");
}
