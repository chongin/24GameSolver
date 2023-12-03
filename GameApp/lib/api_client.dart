// api_client.dart
import 'dart:async';
import 'dart:math';

class ApiClient {
  static Future<void> updateValue(int index, String? value) async {
    await Future.delayed(Duration(seconds: 1));

    print('API Call: update_value - Index: $index, Value: $value');

    // You can add your actual API call here
    // For example, using the 'http' package:
    // final response = await http.post('your_api_url', body: {'index': index.toString(), 'value': value});
    // print(response.body);
  }

  static Future<void> calculate(void Function(int) onUpdateResult) async {
    await Future.delayed(Duration(seconds: 1));

    print('API Call: calcuate -');

    final random = Random();
    int result = random.nextInt(30);
    onUpdateResult(result);
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
