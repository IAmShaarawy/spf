#include <DHT.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// WIFI
#define WIFI_SSID "Sacha"
#define WIFI_PASSWORD "flowbase"

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


// motor pins 
#define MOTOR  D2 // cleaning 1
#define MOTOR_REVERSE  D3 // cleaning -1 and 0 stop (observe)
// DHT11 pin
#define DHT_PIN    D4
DHT dht(DHT_PIN,DHT11); // ventilation/humidity , ventilation/temperature (report)
// light pin
#define LIGHT   D5 // lights/is_lights_on (observe)
// fans pins
#define FAN3   D6 // ventilation/is_fan4_on (observe)
#define FAN4   D7 // ventilation/is_fan3_on (observe)
// LDR pin
#define LDR    A0 // lights/brightness(report)
FirebaseData fbdo;
void setup()
{
  Serial.begin(9600);
  initPins();
  connectToWiFi();
  connectToFirebase();
}

void loop() {
  if(Firebase.ready()){
    reportHumididty();
    delay(3000);
    reportTemperature();
    delay(3000);
    reportBrightness();
    delay(3000);
  }

}

void initPins()
{
  pinMode (MOTOR,OUTPUT);
  pinMode (MOTOR_REVERSE,OUTPUT);
  dht.begin();
  pinMode (LIGHT,OUTPUT);
  pinMode (FAN3,OUTPUT);
  pinMode (FAN4,OUTPUT);
  pinMode (LDR,INPUT);

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

// Humididty
void reportHumididty(){
  String value = getHumidityLevel();
  bool isOk =Firebase.RTDB.setString(&fbdo, "/ventilation/humidity", value);
  Serial.println(isOk?"Humididty OK":fbdo.errorReason().c_str());
}
String getHumidityLevel()
{
  float hum = dht.readHumidity();
  if(isnan(hum)){
    return "-1";
  }
  return String(hum/100);
}

// Temperature
void reportTemperature(){
  String value = getTemperatureLevel();
  bool isOk =Firebase.RTDB.setString(&fbdo, "/ventilation/temperature", value);
  Serial.println(isOk?"Temperature OK":fbdo.errorReason().c_str());
}
String getTemperatureLevel()
{
  float temp = dht.readTemperature();
  if(isnan(temp)){
    return "-1";
  }
  return String(temp);
}


// Brightness
void reportBrightness(){
  String value = getBrightnessLevel();
  bool isOk =Firebase.RTDB.setString(&fbdo, "/lights/brightness", value);
  Serial.println(isOk?"Brightness OK":fbdo.errorReason().c_str());
}
String getBrightnessLevel()
{
  float value = analogRead(LDR);
  return String(value/1023);
}
