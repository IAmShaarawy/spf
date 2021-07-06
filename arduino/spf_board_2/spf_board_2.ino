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
FirebaseData stream;


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
}

void loop() {
  // put your main code here, to run repeatedly:

}

void initPins()
{
  pinMode (PUMB,OUTPUT);
  pinMode (FAN1,OUTPUT);
  pinMode (FAN2,OUTPUT);
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
