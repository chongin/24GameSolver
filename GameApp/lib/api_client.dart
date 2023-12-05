// api_client.dart
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static Future<void> updateValue(int index, String? value) async {
    print('API Call: update_value - Index: $index, Value: $value');

    final Uri uri = Uri.parse('http://127.0.0.1:5000/games/update/index/$index/value/$value');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Response Data: $jsonResponse');
    } else {
      throw Exception('Failed to updateValue. Status code: ${response.statusCode}');
    }
  }

  static Future<int> calculateFormula(String formula) async {
    final Uri uri = Uri.parse('http://127.0.0.1:5000/games/calculate_result');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> requestBody = {'formula': formula};

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('API Call: calculate $formula');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Response Data: $responseData');
      return responseData['result'] as int;
    } else {
      throw Exception('Failed to calculate formula. Status code: ${response.statusCode}');
    }
  }

  static Future<void> newGame(void Function(List<int>) onNewGameData) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/games/new_game'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Response Data: $jsonResponse');
      final digits = List<int>.from(jsonResponse['digits']);

      onNewGameData(digits);
    } else {
      throw Exception('Failed to get new game data. Status code: ${response.statusCode}');
    }
  }
}
