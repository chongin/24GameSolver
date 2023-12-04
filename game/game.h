#pragma once

#include "Lcd.h"
class Game {
public:
  Game(LCDMgr& lcd) : _lcd(lcd) {
    digits = new int[4];
  }

  ~Game() {
    delete[] digits;
  }

  void setDigits(int newDigits[4]) {
    for (int i = 0; i < 4; ++i) {
      digits[i] = newDigits[i];
    }
    char line[20]; // Adjust the size based on your LCD column count
    sprintf(line, "Digits: %d %d %d %d", digits[0], digits[1], digits[2], digits[3]);
    
    _lcd.SetString(0, 0, line);
  }

private:
  LCDMgr& _lcd;
  int* digits;
};