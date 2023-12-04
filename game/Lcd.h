#pragma once
#include <LiquidCrystal.h>
//#include "lcd_display.h"


const int rs = 12;
const int en = 11;
const int d4 = 5;
const int d5 = 4;
const int d6 = 3;
const int d7 = 2;
const int ContrastValue = 100;

class LCDMgr {
public:
  LCDMgr() {
    _lcd = new LiquidCrystal(rs, en, d4, d5, d6, d7);
    analogWrite(13, ContrastValue);
    _lcd->begin(16, 2);
   
    ResetScene();
  }

  void ResetScene() {
    _lcd->clear();
    SetString(0, 4, "Chong In");
    SetString(1, 4, "IOT 1012");
  }

  void Update() {
    // Refresh the LCD display
  }

  void SetString(int row, int col, const String& value) {
    _lcd->setCursor(col, row);
    _lcd->print(value);
  }

private:
  LiquidCrystal* _lcd;
};


