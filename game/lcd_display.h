#pragma once
#include <LiquidCrystal.h>

class LcdGrphic
{
public:
  LcdGrphic(LiquidCrystal* lcd)
  {
    _lcd = lcd;
    initializeGraphics();
  }

  void DrawTime(int seconds, int row)
  {
    int cal_col = 0;
    if (seconds / 10 > 0)
    {
      cal_col = 1;
      if (seconds / 100 > 0)
      {
        cal_col += 1;
      }
    } 
    
    _lcd->setCursor(15 - cal_col, row);
    _lcd->print(seconds);
  }

  void DrawFlashingSymbol(int col, int row)
  {
    _lcd->setCursor(col, row);
    _lcd->print('_');
  }

  void DrawString(String str, int start_col, int row)
  {
    int length = str.length();
    for (int i = 0; i < length; ++i)
    {
      _lcd->setCursor(start_col + i, row);
      _lcd->print(str[i]);
    }
  }

  void DrawPicture(char name, int col, int row)
  {
    _lcd->setCursor(col, row);
    switch(name)
    {
      case '+':
        _lcd->write(byte(0));
        break;
      case '-':
        _lcd->write(byte(1));
        break;
      case '*':
        _lcd->write(byte(2));
        break;
      case '/':
        _lcd->write(byte(3));
        break;
      case '=':
        _lcd->write(byte(4));
        break;
      case '(':
        _lcd->write(byte(5));
        break;
      case ')':
        _lcd->write(byte(6));
        break;
    }
  }

  void DrawNumber(int number, int col, int row)
  {
    _lcd->setCursor(col, row);
    _lcd->print(number);
  }

private:
  void initializeGraphics() 
  {
    _addition_graphic = new byte[8]{
      B00000,   
      B00100,
      B00100,
      B11111,
      B11111,
      B00100,
      B00100,
      B00000
    };
    
    _subtraction_graphic = new byte[8]{
      B00000,   
      B00000,
      B00000,
      B11111,
      B11111,
      B00000,
      B00000,
      B00000
    };

    _multiplication_graphic = new byte[8]{
      B00000,
      B00000,
      B10001,
      B01010,
      B00100,
      B01010,
      B10001,
      B00000
    };

    _division_graphic = new byte[8]{
      B00000,
      B01100,
      B00000,
      B11111,
      B00000,
      B00000,
      B01100,
      B00000
    };

    // _equal_graphic = new byte[8]{
    //   B00000,
    //   B00000,
    //   B01110,
    //   B00000,
    //   B01110,
    //   B00000,
    //   B00000,
    //   B00000
    // };

    _left_bracket_graphic = new byte[8]{
      B00010,
      B00100,
      B01000,
      B01000,
      B01000,
      B00100,
      B00010,
      B00000
    };

    _right_bracket_graphic = new byte[8]{
      B01000,
      B00100,
      B00010,
      B00010,
      B00010,
      B00100,
      B01000,
      B00000
    };

    _lcd->createChar(0, _addition_graphic);
    _lcd->createChar(1, _subtraction_graphic);
    _lcd->createChar(2, _multiplication_graphic);
    _lcd->createChar(3, _division_graphic);
    //_lcd->createChar(4, _equal_graphic);
    _lcd->createChar(5, _left_bracket_graphic);
    _lcd->createChar(6, _right_bracket_graphic);
  }
private:
  LiquidCrystal* _lcd;
  byte* _addition_graphic;
  byte* _subtraction_graphic;
  byte* _multiplication_graphic;
  byte* _division_graphic;
  //byte* _equal_graphic;
  byte* _left_bracket_graphic;
  byte* _right_bracket_graphic;
};