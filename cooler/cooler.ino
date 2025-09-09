#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include <ArduinoJson.h>
#include <DallasTemperature.h>
#include <OneWire.h>
// #include <FastLED.h> 
#include <DHT.h>

AsyncWebServer server(80);
AsyncWebSocket ws("/");

const char* ssid = "SSID";
const char* password = "PASSWORD";


#define DHT_SENSOR_PIN  5
#define DHT_SENSOR_TYPE DHT22

#define COOLANT_SENSOR_PIN 27

#define FAN_PIN 26
#define PUMP_PIN 25

#define PAD_0_PIN 18
#define PAD_1_PIN 19

DHT dht_sensor(DHT_SENSOR_PIN, DHT_SENSOR_TYPE);
// CRGB leds[NUM_LEDS];

const int freq = 25000;  
const int channel = 0;
const int resolution = 8;   

int operationMode; // 0 off 1 auto 2 manual

int fanSpeed = 0;
int pumpSpeed = 0;
bool padStatus[] = {false,false};


// Sensors
int coolantTemp = 0;
int ambientTemp = 0;
int humidity = 0;

int goalTemperature = 0;
int currentTemperature = 0;
  
int curAutoPreset = 2; // Eco, Silent, Normal, Strong, Blast
unsigned long interval = 0;

struct AutoPreset{
  // intervals are repsesented with seconds
  unsigned int intervalTime; //seconds

  unsigned int coolingTimePercentage; //length of cooling cycle rest is standby with coolOffTime
  unsigned int coolOffTime; //length of cooling cycle with pads turned off

  unsigned int maxFanSpeed;
  unsigned int maxPumpSpeed;
  
};

AutoPreset autoPresets[] = {
  {60,25,5000,50,50},
  {60,50,5000,50,50},
  {60,60,5000,70,70},
  {60,100,5000,75,75},
  {60,100,5000,100,100}
};

OneWire oneWire(COOLANT_SENSOR_PIN);
DallasTemperature sensors(&oneWire);

float getCoolantTemperature(){
  sensors.requestTemperatures(); 
  return sensors.getTempCByIndex(0);
}

int getFanSpeed(){
  if(fanSpeed == 0) return 0;
  return (0.65 * fanSpeed + 35) * 2.55;
}
int getPumpSpeed(){
  if(pumpSpeed == 0) return 0;
  return (0.65 * pumpSpeed + 35) * 2.55;
}

float getAmbientTemperature(){return dht_sensor.readTemperature();}
float getAmbientHumidity(){return (dht_sensor.readHumidity() * 10) / 10;}



// volatile int fanSpeed = 50; 
// volatile int pumpSpeed = 75; 
volatile float coolantTemperature = 22.5;



// void onWebSocketEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type, void *arg, uint8_t *data, size_t len);
// String serializeState();
// void notifyClients();
// void handleWebSocketMessage(AsyncWebSocketClient *client, void *arg, uint8_t *data, size_t len);

void notifyClients(uint32_t excludeId = 0) {
  String jsonState = serializeState();
  ws.cleanupClients(); 
  for (AsyncWebSocketClient &c : ws.getClients()) {
    if (c.id() != excludeId && c.canSend()) {
      c.text(jsonState);
    }
  }
}

void setup() {
  Serial.begin(115200);
  Serial.println();

  Serial.print("Connecting");
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected");

  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  dht_sensor.begin();

  // Coolant temperature
  sensors.begin();

  // Pads
  pinMode(PAD_0_PIN, OUTPUT);
  pinMode(PAD_1_PIN, OUTPUT);

  ledcAttach(FAN_PIN, freq, 8);
  ledcWrite(FAN_PIN, 0);

  ledcAttach(PUMP_PIN, freq, 8);
  ledcWrite(PUMP_PIN, 0);


  ws.onEvent(onWebSocketEvent);
  server.addHandler(&ws);

  server.begin();
}



void loop() {

  if(operationMode == 0){
    digitalWrite(PAD_0_PIN, LOW);
    digitalWrite(PAD_1_PIN, LOW);
    ledcWrite(FAN_PIN, 0);
    ledcWrite(PUMP_PIN, 0);  
  }else if(operationMode == 1){
    // handleAuto();
  }else if(operationMode == 2){
    if(padStatus[0]) digitalWrite(PAD_0_PIN, HIGH);
    else digitalWrite(PAD_0_PIN, LOW);

    if(padStatus[1]) digitalWrite(PAD_1_PIN, HIGH);
    else digitalWrite(PAD_1_PIN, LOW);

    ledcWrite(FAN_PIN, getFanSpeed());
    ledcWrite(PUMP_PIN, getPumpSpeed());  
  }
  delay(5000);
  notifyClients();
  ws.cleanupClients();

  // static unsigned long lastTempUpdate = 0;
  // if (millis() - lastTempUpdate > 5000) {
  //   coolantTemperature += random(-5, 6) / 10.0; 
  //   if(coolantTemperature > 40.0) coolantTemperature = 40.0;
  //   if(coolantTemperature < 5.0) coolantTemperature = 5.0;
    
  //   Serial.print("Simulated temperature change: ");
  //   Serial.println(coolantTemperature);

  //   notifyClients();
    
  //   lastTempUpdate = millis();
  // }
  

}



String serializeState() {
  DynamicJsonDocument jsonDoc(256); 
  jsonDoc["operation_mode"] = operationMode;
  jsonDoc["auto_preset"] = curAutoPreset;
  jsonDoc["pad_0"]  = padStatus[0] ? true : false;
  jsonDoc["pad_1"] = padStatus[1] ? true : false;
  jsonDoc["fan_speed"] = fanSpeed;
  jsonDoc["pump_speed"] = pumpSpeed;
  jsonDoc["coolant_temperature"] = 5;
  jsonDoc["ambient_temperature"] = 27.6;
  jsonDoc["humidity"] = 90;
  // jsonDoc["current_temperature"] = currentTemperature;
  jsonDoc["current_temperature"] = 26;
  jsonDoc["goal_temperature"] = goalTemperature;

  // jsonDoc["coolant_temperature"] = getCoolantTemperature()
  // jsonDoc["ambient_temperature"] = getAmbientTemperature();
  // jsonDoc["humidity"] = getAmbientHumidity();

  // JsonDocument doc;
  // doc["fanSpeed"] = fanSpeed;
  // doc["pumpSpeed"] = pumpSpeed;

  // doc["coolantTemperature"] = String(coolantTemperature, 1);

  String jsonString;    
  serializeJson(jsonDoc, jsonString);
  return jsonString;
}



void onWebSocketEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type, void *arg, uint8_t *data, size_t len) {
  switch (type) {
    case WS_EVT_CONNECT:
      Serial.printf("Client #%u connected from %s\n", client->id(), client->remoteIP().toString().c_str());
      client->keepAlivePeriod(10);
      client->text(serializeState());
      break;
    case WS_EVT_DISCONNECT:
      Serial.printf("Client #%u disconnected\n", client->id());
      break;
    case WS_EVT_DATA: {
        handleWebSocketMessage(client, arg, data, len);
        break;
    }
    case WS_EVT_PONG:              
      Serial.printf("ws[%s][%u] received pong\n", server->url(), client->id());
      break;                    
    case WS_EVT_ERROR:
      Serial.printf("ws[%s][%u] error(%u): %s\n", server->url(), client->id(), *(uint16_t*)arg, (char*)data);
      break;                
  }
}

void handleWebSocketMessage(AsyncWebSocketClient *client, void *arg, uint8_t *data, size_t len) {
  AwsFrameInfo *info = (AwsFrameInfo*)arg;
  if (info->final && info->index == 0 && info->len == len && info->opcode == WS_TEXT) {
    // Attempt to deserialize the incoming JSON
    JsonDocument doc;
    DeserializationError error = deserializeJson(doc, data, len);

    if (error) {
      Serial.print("deserializeJson() failed: ");
      Serial.println(error.c_str());                          
      client->text("{\"error\":\"Invalid JSON format\"}");
      return;
    }
    if(doc.containsKey("mode")) operationMode = doc["mode"];
      if(doc.containsKey("auto_preset")){
        if(curAutoPreset != doc["auto_preset"]) interval = 0;
        curAutoPreset = doc["auto_preset"];
      }
      if(doc.containsKey("fan_speed")){
        int speed = doc["fan_speed"];
        if(speed == 0) fanSpeed = 0;
        else if(speed == 1) fanSpeed = 20;
        else if(speed == 2) fanSpeed = 40;
        else if(speed == 3) fanSpeed = 60;
        else if(speed == 4) fanSpeed = 80;
        else if(speed == 5) fanSpeed = 100;
      }
      if(doc.containsKey("pump_speed")){
        int speed = doc["pump_speed"];
        if(speed == 0) pumpSpeed = 0;
        else if(speed == 1) pumpSpeed = 20;
        else if(speed == 2) pumpSpeed = 40;
        else if(speed == 3) pumpSpeed = 60;
        else if(speed == 4) pumpSpeed = 80;           
        else if(speed == 5) pumpSpeed = 100;
      }
      if(doc.containsKey("pad_0"))  padStatus[0] = doc["pad_0"];
      if(doc.containsKey("pad_1"))  padStatus[1] = doc["pad_1"];

      if(doc.containsKey("goal_temperature")){
        goalTemperature = doc["goal_temperature"];
      }

      Serial.println("Broadcasting new state.");

      client->text("ok");
      notifyClients(client->id());
  }
}