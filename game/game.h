#pragma once
#include "formula_calculator.h"

enum CommandEnum
{
  None = 0x00,
  Left = 0x01,
  Right = 0x02,
  Up = 0x04,
  Down = 0x08
};

struct GameData {
  int* Cards; //don't delete, handle it by generator
  int CarSize;
  int GameID;
  GameData(int* cards, int car_size, int game_id): Cards(cards), CarSize(car_size),
    GameID(game_id)
  {
  }
};

enum GameState
{
  Started = 0,
  Win,
  Lost,
  Failed
};

class Game
{
public:
  Game(LCDMgr* game_scene, GameData* game_data)
  {
    _game_state = GameState::Started;
    _game_scene = game_scene;
    _game_data = game_data;
  }

  ~Game()
  {
    delete _game_data;
  }

  void Update()
  {
    bool is_started = _game_state == GameState::Started;
    _game_scene->UpdateView(_formula, GetSeconds(), is_started);
  }

  void UpdateFormula()
  {
    //check if already selected all number
    if (!_game_scene->IsCanBeSelected()) {
      Serial.println("Cannot update formula now,because no number exist.");
      return;
    }
    char ch = _game_scene->GetCurrentSelection();
    Serial.print("Update before: " + _formula);
    Serial.print(",Add char: ");
    Serial.print(ch);

    _formula += ch;
    Serial.println(",Update after: " + _formula);

    _game_scene->RemoveCurrentSelection();
    _game_scene->ChangeSelectionMode();
  }

  void CalculateResult()
  {
    if (_game_state != GameState::Started) {
      Serial.print("This game already close: cannot calculate formula again.");
      return;
    }

    bool res = false;
    float result = CalcFormula(_formula, res);
    if (res) {
      Serial.print("Cal Formula:");
      Serial.print(_formula);
      Serial.print(", result: ");
      Serial.println(result);
      _formula += "=" + keepOnePrecision(result);

      if (abs(result - 24) < 0.0001) {
        _game_state = GameState::Win;
      } else {
        _game_state = GameState::Lost;
      }
    }
    else {
      _game_state = GameState::Failed;
      Serial.print("CalcFormula failed,  maybe formula is wrong.");
    }

    //PrintGameInfo();
  }

  void HandleCommand(CommandEnum command)
  {
    switch(command)
    {
      case CommandEnum::Left:
        _game_scene->ChangeShowOption();
        break;
      case CommandEnum::Right:
        UpdateFormula();
        break;
      case CommandEnum::Up:
        _game_scene->IncreaseOptionIndex();
        break;
      case CommandEnum::Down:
        _game_scene->DecreaseOptionIndex();
        break;
    }
  }

  GameState GetGameState() {
    return _game_state;
  }
  
  String GetFormula()
  {
    return _formula;
  }
private:
  int GetSeconds()
  {
    return (millis() / 1000) - _seconds;
  }

  String GetGameStateStr()
  {
    String state = "";
    switch(_game_state)
    {
      case GameState::Started:
        state = "Started";
        break;
      case GameState::Win:
        state = "Win";
        break;
      case GameState::Lost:
        state = "Lost";
        break;
      case GameState::Failed:
        state = "Failed";
        break;
    }
    return state;
  }

  void PrintGameInfo()
  {
    Serial.print("game_id: ");
    Serial.print(_game_data->GameID);
    Serial.print(",game_state:");
    Serial.println(GetGameStateStr());
  }

  String keepOnePrecision(float number) {
    char result[8];
    int intPart = int(number);
    int decimalPart = int(number * 10) % 10;

    //snprintf(result, sizeof(result), "%d.%d", intPart, decimalPart);
    //don't change to float, just change to int
    snprintf(result, sizeof(result), "%d", intPart);
    return String(result);
  }
private:
  LCDMgr * _game_scene = NULL;
  GameData* _game_data = NULL;
  //String _formula = "(4+4)*(5-3)";
  String _formula;
  GameState _game_state;
  int _seconds = millis() / 1000;
};