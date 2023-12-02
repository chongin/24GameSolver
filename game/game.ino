#include <ArduinoJson.h>

void setup() {
  Serial.begin(9600);  // Set the baud rate to match the Python code
}

void loop() {
  if (Serial.available() > 0) {
    // Read the JSON data from Python
    StaticJsonDocument<200> doc;
    DeserializationError error = deserializeJson(doc, Serial);

    if (error) {
      Serial.print("Error deserializing JSON: ");
      Serial.println(error.c_str());
      return;
    }

    // Extract data from JSON
    const char* command = doc["command"];
    int value = doc["value"];

    // Process the command
    if (strcmp(command, "LED") == 0) {
      // Example: Control an LED based on the received value
      digitalWrite(LED_BUILTIN, value);
    }

    // Send a response back to Python
    doc.clear();
    doc["response"] = "ACK";
    serializeJson(doc, Serial);
    Serial.println();

    delay(500);  // Add a delay for stability
  }
}
