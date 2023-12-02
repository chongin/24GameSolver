#include <ArduinoJson.h>
StaticJsonDocument<400> doc;
void setup() 
{
  Serial.begin(115200);
  Serial.println("Ready");
}

void loop()
{
  if (Serial.available() > 0)
  {
    delay(10);
    String s = Serial.readStringUntil('\n');
    
    DeserializationError error = deserializeJson(doc, s);
    if (error) 
    {
      Serial.print(F("deserializeJson() failed: "));
      Serial.println(error.c_str());
      return;
    }
    
    doc.clear();
    doc["command"] = "test";
    doc["result"] = "OK";
    doc["message"] = s;
    String jsonString;
    serializeJson(doc, jsonString);
    Serial.println(jsonString);
  }
}
