#include <ArduinoJson.h>

void setup() {
  Serial.begin(115200);  // Set the baud rate to match the Python code
  Serial.println("Ready");
}

void processCommand(const char* command, JsonObject& data) {
  if (strcmp(command, "new_game") == 0) {
    JsonArray digits = data["digits"];
    DynamicJsonDocument doc(200);
    doc["command"] = "new_game";
    JsonArray data = doc.createNestedArray("data");
    data.add(1);
    data.add(2);
    data.add(3);
    data.add(4);

    String jsonString;
    serializeJson(doc, jsonString);
    Serial.println(jsonString);
  } 
}

void loop() {
  if (Serial.available() > 0) {
    // Read the JSON data from Python
    DynamicJsonDocument doc(200);
    DeserializationError error = deserializeJson(doc, Serial);

    if (error) {
      Serial.print("Error deserializing JSON: ");
      Serial.println(error.c_str());
      return;
    }

    // Extract data from JSON
    const char* command = doc["command"];
    JsonObject data = doc["data"];

    // Process the command
    processCommand(command, data);

    delay(50);  // Add a delay for stability
  }
}
