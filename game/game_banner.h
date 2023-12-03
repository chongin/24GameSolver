#pragma once

#include <LiquidCrystal.h>
#include "sounds.h"

class GameBannerGrphic
{
public:
  GameBannerGrphic(LiquidCrystal* lcd)
  {
    _lcd = lcd;
  }

  void DrawBanner(int buzzer_pin)
  {
    _lcd->clear();
    char text1[] = "IoT 1023";
    char text2[] = "Chong In";
    for (int i = 0; i < 8; ++i)
    {
      _lcd->setCursor(4 + i, 0);
      _lcd->write(text1[i]);
      _lcd->setCursor(4 + i, 1);
      _lcd->write(text2[i]);
      playTone(buzzer_pin, _welcome_tones[i], _good_luck_durations[i]);
    }
   
    delay(1000);
    _lcd->clear();
    _lcd->setCursor(3, 0);
    _lcd->print("24 Solver");
    _lcd->setCursor(3, 1);
    _lcd->print("Good Luck");
    delay(2000);
     _lcd->clear();
  }

  void DrawGameResult(bool win, int buzzer_pin){
    delay(1000);
    if (win) {
      _lcd->clear();
      //_lcd->setBacklight(1); //belong to Adafruit_LiquidCrystal, not include in LiquidCrystal
      _lcd->setCursor(3, 0);
      _lcd->print("You Win");
      _lcd->setCursor(3, 1);
      _lcd->print("Congrat!");
      playWinSound(buzzer_pin);
      delay(2000);
      //_lcd->setBacklight(0);
    } else {
      _lcd->clear();
      _lcd->setCursor(3, 0);
      _lcd->print("You Lost");
      _lcd->setCursor(2, 1);
      _lcd->print("keep Going!");
      playLostSound(buzzer_pin);
      delay(2000);
    }
  }
private:
  int _row0 = 0;
  int _row1 = 1;
  LiquidCrystal* _lcd = NULL;
  int _welcome_tones[8] = {659, 698, 784, 698, 659, 587, 659, 523};
  int _good_luck_durations[8] = {200, 200, 300, 300, 200, 200, 300, 400};
};