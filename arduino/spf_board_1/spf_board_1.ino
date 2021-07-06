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
FirebaseData fan1Stream;
FirebaseData fan2Stream;
FirebaseData fan3Stream;


// DHT11 pin
#define DHT_PIN    D0
DHT dht(DHT_PIN,DHT11); // ventilation/humidity , ventilation/temperature (report)
// fans pins
#define FAN1   D1 // ventilation/is_fan1_on (observe)
#define FAN2   D2 // ventilation/is_fan2_on (observe)
#define FAN3   D3 // ventilation/is_fan3_on (observe)
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
    reportHumididty();
    delay(3000);
    reportTemperature();
    delay(3000);
  }

}

void initPins()
{
  dht.begin();
  pinMode (FAN1,OUTPUT);
  pinMode (FAN2,OUTPUT);
  pinMode (FAN3,OUTPUT);
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
  Serial.println(isOk?"Humididty Reported":fbdo.errorReason().c_str());
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
  Serial.println(isOk?"Temperature Reported":fbdo.errorReason().c_str());
}
String getTemperatureLevel()
{
  float temp = dht.readTemperature();
  if(isnan(temp)){
    return "-1";
  }
  return String(temp);
}

void beginStreaming()
{

  if (!Firebase.RTDB.beginStream(&fan1Stream, "/ventilation/is_fan1_on")){
    Serial.printf("sream begin error, %s\n\n", fan1Stream.errorReason().c_str());
  }
  Firebase.RTDB.setStreamCallback(&fan1Stream, fan1Callback, fan1StreamTimeoutCallback);

  if (!Firebase.RTDB.beginStream(&fan2Stream, "/ventilation/is_fan2_on")){
    Serial.printf("sream begin error, %s\n\n", fan2Stream.errorReason().c_str());
  }
  Firebase.RTDB.setStreamCallback(&fan2Stream, fan2Callback, fan2StreamTimeoutCallback);
  
  if (!Firebase.RTDB.beginStream(&fan3Stream, "/ventilation/is_fan3_on")){
    Serial.printf("sream begin error, %s\n\n", fan3Stream.errorReason().c_str());
  }
  Firebase.RTDB.setStreamCallback(&fan3Stream, fan3Callback, fan3StreamTimeoutCallback);
  
}
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////FAN1////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void fan1Callback(FirebaseStream data)
{
  int isOn = data.boolData();
  Serial.println(isOn?"FAN1 IS ON":"FAN1 IS OFF");
  digitalWrite(FAN1, isOn?HIGH:LOW);
}

void fan1StreamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("Fan1 stream timeout, resuming...\n");
}
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////FAN2////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void fan2Callback(FirebaseStream data)
{
  int isOn = data.boolData();
  Serial.println(isOn?"FAN2 IS ON":"FAN2 IS OFF");
  digitalWrite(FAN2, isOn?HIGH:LOW);
}

void fan2StreamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("Fan2 stream timeout, resuming...\n");
}
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////FAN3////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void fan3Callback(FirebaseStream data)
{
  int isOn = data.boolData();
  Serial.println(isOn?"FAN3 IS ON":"FAN3 IS OFF");
  digitalWrite(FAN3, isOn?HIGH:LOW);
}

void fan3StreamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("Fan3 stream timeout, resuming...\n");
}
