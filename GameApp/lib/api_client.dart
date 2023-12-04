// api_client.dart
import 'dart:async';
import 'dart:math';

class ApiClient {
  static Future<void> updateValue(int index, String? value) async {
    await Future.delayed(Duration(seconds: 1));

    print('API Call: update_value - Index: $index, Value: $value');
  }

  static Future<int> calculateFormula(String formula) async {
    await Future.delayed(Duration(seconds: 1));

    print('API Call: calcuate $formula');

    final random = Random();
    int result = random.nextInt(30);
    return result;
  }

  static Future<void> newGame(void Function(List<int>) onNewGameData) async {
    await Future.delayed(Duration(seconds: 1));

    print('API Call: New Game -');

    // Generate a random 4-digit number
    final random = Random();
    final randomDigits = List.generate(4, (_) => random.nextInt(10));

    // Call the callback function with the new game data
    onNewGameData(randomDigits);
  }
}
