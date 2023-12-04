// api_client.dart
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/games/new_game'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);
        final digits = List<int>.from(jsonResponse['digits']);

        // Call the callback function with the new game data
        onNewGameData(digits);
      } else {
        print('Failed to get new game data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
}
