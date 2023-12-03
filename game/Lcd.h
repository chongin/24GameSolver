#pragma once
#include <LiquidCrystal.h>
#include "lcd_display.h"
#include "game_banner.h"

const int rs = 12;
const int en = 11;
const int d4 = 5;
const int d5 = 4;
const int d6 = 3;
const int d7 = 2;
const int ContrastValue = 100;
const String Numbers = "N:";

struct GameHistoryDrawing {
  int WinTimes = 0;
  int LostTimes = 0;
  int FailTimes = 0;

  int GetFailCount() {
    return LostTimes + FailTimes;
  }

  String ToString() {
    char buffer[20];
    sprintf(buffer, "W:%dL:%d", WinTimes, GetFailCount());
    return String(buffer);
  }
};

class LCDMgr
{
public:
  LCDMgr()
  {
    _lcd = new LiquidCrystal(rs, en, d4, d5, d6, d7);
    analogWrite(13, ContrastValue);
    _lcd->begin(16, 2);
   
    _lcd_grphic = new LcdGrphic(_lcd);
    ResetScene();
  }

  ~LCDMgr()
  {
    delete _lcd;
    delete _lcd_grphic;
  }

  void DrawBanner(int buzzer_pin)
  {
    GameBannerGrphic* banner = new GameBannerGrphic(_lcd);
    banner->DrawBanner(buzzer_pin);
    delete banner;
  }

  void DrawGameResult(bool win, int buzzer_pin)
  {
    GameBannerGrphic* banner = new GameBannerGrphic(_lcd);
    banner->DrawGameResult(win, buzzer_pin);
    delete banner;
  }
  void ResetScene() 
  {
    _lcd->clear();
    _current_row = 1;
    _current_col = 0;
    _flashing_value = 0;
    _current_option_index = 0;
    _current_number_index = 0;
    _default_show_number = true;
    if (_number_array != NULL) {
      delete _number_array;
      _number_array = NULL;
    }

    _number_size = 0;
  }

  void UpdateWinHistoryData(int win, int lost, int fail) {
    _game_history_drawing.WinTimes = win;
    _game_history_drawing.LostTimes = lost;
    _game_history_drawing.FailTimes = fail;
  }

  void SetNumbers(int* number_array, int number_size)
  {
    if (_number_array != NULL){
      delete _number_array;
    }

    _orginal_number_array = number_array;
    _orginal_size = number_size;

    _number_size = number_size;
    _number_array = new int[number_size]; //need deep copy
    for (int i = 0; i < number_size; ++i) 
    {
      _number_array[i] = number_array[i];
    }

    //printNumberArray();
  }

  void UpdateView(String formula, int seconds, bool is_started) 
  {
    UpdateFirstRowView(seconds);
    UpdateSecondRowView(formula, is_started);
  }

  void IncreaseOptionIndex()
  {
    if (_default_show_number) {
      if (_number_array == NULL) {
        Serial.println("I, All element are selected.");
        return;
      }

      _current_number_index += 1;
      _current_number_index %= _number_size;

      //Serial.print(String("I, Current number index:") + _current_number_index);
      //Serial.println(String(", Current number:") + _number_array[_current_number_index]);

      //printNumberArray();
    }
    else {
      _current_option_index += 1;
      _current_option_index %= _symbol_option_size;

     // Serial.print(String("I, Current option index:") + _current_option_index);
      //Serial.println(String(", Current option:") + _symbol_options[_current_option_index]);
    }
  }

  void DecreaseOptionIndex()
  {
    Serial.println("DecreaseOptionIndex Run");
    if (_default_show_number) {
      if (_number_array == NULL) {
        Serial.print("D, All element are selected.");
        return;
      }
      _current_number_index -= 1;
      if (_current_number_index < 0) {
        _current_number_index = 0;
      }
      _current_number_index %= _number_size;
      
      //Serial.print(String("D, Current number index:") + _current_number_index);
      //Serial.println(String(", Current number:") + _number_array[_current_number_index]);

      //printNumberArray();
    }
    else {
      _current_option_index -= 1;
      if (_current_option_index < 0) {
        _current_option_index = 0;
      }
      _current_option_index %= _symbol_option_size;

      //Serial.print(String("D, Current option index:") + _current_option_index);
     // Serial.println(String(", Current option:") + _symbol_options[_current_option_index]);
    }
  }

  void ChangeShowOption()
  {
    _default_show_number = !_default_show_number;
    _current_option_index = 0;
    _current_number_index = 0;

    Serial.println(String("Change slection mode success, show number: ") + _default_show_number);
  }

  char GetCurrentSelection()
  {
    if (_default_show_number)
    {
      char ch = '0' + _number_array[_current_number_index];
      Serial.print("Current Selection: ");
      Serial.println(ch);
      return ch;
    } else 
    {
      return _symbol_options[_current_option_index];
    }
  }

  //because current number selection already add to the formula.
  void RemoveCurrentSelection()
  {
    if (!_default_show_number) {
      return;
    }
    
    if (_number_size > 1) {
      bool find_flag = false;
      int* new_array = new int[_number_size - 1];
      for (int i = 0; i < _number_size; ++i) {
        if (i != _current_number_index) {
          int index = i;
          if (find_flag) {
            index -= 1;
          }
          new_array[index] = _number_array[i];
          Serial.print(String("Remove index:") + _current_number_index);
          Serial.println(String(", value:") + _number_array[index]);
        } else {
          find_flag = true;
        }
      }
      _number_size -= 1;
      delete _number_array; //delete old array
      _number_array = new_array;
      _current_number_index = 0;
    } else {
      // delete last one element and no need to create a new array, becausel already all selected;
      _number_size -= 1;
      delete _number_array; //delete old array
      _number_array = NULL;
      _current_number_index = 0;

      Serial.print("Congrat you choose all number.");
    }
  }

  void ChangeSelectionMode()
  {
    _current_option_index = 0;
    _current_number_index = 0;
    _default_show_number = !_default_show_number;
  }

  bool IsCanBeSelected()
  {
    if (_default_show_number){
      return _number_array != NULL;
    } 
    else {
      return true;
    }
  }
private:
  void printNumberArray()
  {
    Serial.print(String("Total number count:") + _number_size);
    for (int i = 0; i < _number_size; ++i) {
    //  Serial.print(String(",Index:") + i);
    //  Serial.print(String(", value:") + _number_array[i]);
    }
    Serial.println("");
  }

private:
  void UpdateFirstRowView(int seconds)
  {
     //Draw Numbers
    _lcd_grphic->DrawString(Numbers, 0, 0);
    for(int i = 0; i < _orginal_size; ++i)
    {
      _lcd_grphic->DrawNumber(_orginal_number_array[i], Numbers.length() + i, 0);
    }

     //Draw game history
    int start_pos = 7;
    _lcd_grphic->DrawString(_game_history_drawing.ToString(), start_pos, 0);

    //Draw timer
    _lcd_grphic->DrawTime(seconds, 0);
  }

  void UpdateSecondRowView(String formula, bool is_started)
  {
    if (formula.length() > 0)
    {
      _lcd_grphic->DrawString(formula, 0, _current_row);
    }

    if (!is_started){
      //game not started, no need to show flashing and number or symbol
      return;
    }
    int next_pos = formula.length();
    if (_flashing_value++ % 2 == 0)
    {
      _lcd_grphic->DrawFlashingSymbol(next_pos, _current_row);
    } 
    else {
      if (_default_show_number)
      {
        _lcd_grphic->DrawNumber(_number_array[_current_number_index], next_pos, _current_row);
      }
      else {
        _lcd_grphic->DrawPicture(_symbol_options[_current_option_index], next_pos, _current_row);
      }
    }
  }
private:
  LiquidCrystal* _lcd = NULL;
  LcdGrphic* _lcd_grphic = NULL;
  int _current_row;
  int _current_col;
  
  char* _symbol_options = new char[6]{'+', '-', '*', '/', '(', ')'};
  int _symbol_option_size = 6;
  int* _number_array = NULL;
  int _number_size = 0;

  int* _orginal_number_array = NULL; //keep orginal data, to print the number
  int _orginal_size = 0;

  int _current_option_index = 0;
  int _current_number_index = 0;
  bool _default_show_number = true;
  int _flashing_value = 0; //make the last digest flashing

  GameHistoryDrawing _game_history_drawing;
};


