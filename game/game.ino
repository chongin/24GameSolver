#include "game_manager.h"

GameManager* game_mgr = NULL;

void setup() 
{
  Serial.begin(115200);

  game_mgr = new GameManager();
  game_mgr->CreateNewGame();
}

void loop() 
{
  

  game_mgr->GetCurrentGame()->Update();


  delay(500);
}




