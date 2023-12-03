
#pragma once
const int MAX_QUEUE = 30;

//I reference this website to generate this decks:
//https://rosettacode.org/wiki/24_game/Solve#C++
class GameDeckGenerator
{
public:
  GameDeckGenerator()
  {
    _decks = new int[MAX_QUEUE][4]{
      {8, 3, 7, 9},
      {1, 4, 3, 1},
      {5, 4, 3, 6},
      {2, 5, 5, 8},
      {5, 4, 7, 3},
      {3, 3, 9, 2},
      {3, 2, 7, 9},
      {7, 1, 5, 3},
      {7, 6, 9, 4},
      {3, 5, 3, 1},
      {5, 7, 1, 9},
      {1, 2, 9, 6},
      {3, 4, 5, 3},
      {3, 9, 6, 7},
      {7, 7, 2, 5},
      {1, 7, 4, 6},
      {1, 3, 6, 2},
      {3, 4, 9, 2},
      {8, 3, 8, 4},
      {9, 8, 5, 1},
      {4, 7, 5, 4},
      {1, 9, 2, 9},
      {7, 5, 7, 6},
      {5, 5, 8, 8},
      {5, 9, 8, 2},
      {2, 5, 8, 9},
      {4, 4, 2, 5},
      {7, 1, 3, 6},
      {7, 8, 4, 8},
      {6, 9, 9, 8},
      {6, 6, 9, 5}
    };
  }

  int* RandomOneSet()
  {
    int rand = random(MAX_QUEUE);
    return _decks[rand];
  }

  int GetCardNumber()
  {
    return 4;
  }
private:
  int (*_decks)[4];
};