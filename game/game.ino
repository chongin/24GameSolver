#include <ArduinoJson.h>
#include "Lcd.h"
#include "game.h"

LCDMgr lcdManager;
Game *game = NULL;

void setup() {
  Serial.begin(115200);
  Serial.println("Ready");
}

void send_response(DynamicJsonDocument& doc)
{
  String jsonString;
  serializeJson(doc, jsonString);
  Serial.println(jsonString);
}

void processCommand(const char* command, JsonObject& data) {
  if (strcmp(command, "new_game") == 0) {
    game = new Game(lcdManager);
    JsonArray digitsJsonArray = data["digits"];

    if(digitsJsonArray.size() == 4)
    {
      int digits[4];
      for (int i = 0; i < 4; ++i)
      {
        digits[i] = digitsJsonArray[i].as<int>();
      }
      game->setDigits(digits);
    }
    

    DynamicJsonDocument doc(200);
    doc["command"] = "new_game";
    doc["data"] = digitsJsonArray;

    send_response(doc);
  } else if (strcmp(command, "update_value") == 0) {
      int index = data["index"];
      String value = data["value"];
      game->setValue(index, value);

      DynamicJsonDocument doc(200);
      doc["command"] = command;
      doc["index"] = index;
      doc["value"] = value;
      send_response(doc);
  } else if (strcmp(command, "clear_value") == 0) {
    game->clearValue();
    DynamicJsonDocument doc(200);
    doc["command"] = command;
    doc["result"] = "OK";
    send_response(doc);
  } else if (strcmp(command, "show_result") == 0) {
    game->clearValue();
    String result = data["result"];
    game->setResult(result);
    DynamicJsonDocument doc(200);
    doc["command"] = command;
    doc["result"] = result;
    send_response(doc);
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
  lcdManager.Update();

}
