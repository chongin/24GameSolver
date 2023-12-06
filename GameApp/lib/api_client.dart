// api_client.dart
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  //static String baseUri = 'http://192.168.2.44:5000';
  //static String baseUri = 'http://127.0.0.1:5000';
  static String baseUri = 'http://192.168.0.115:5000';

  static Future<void> updateValue(int index, String? value) async {
    print('API Call: update_value - Index: $index, Value: $value');

    final Uri uri = Uri.parse('$baseUri/games/update_value');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> requestBody = {'index': index, 'value': value};
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Response Data: $jsonResponse');
    } else {
      throw Exception(
          'Failed to updateValue. Status code: ${response.statusCode}');
    }
  }

  static Future<int> calculateFormula(String formula) async {
    final Uri uri = Uri.parse('$baseUri/games/calculate_result');
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
      throw Exception(
          'Failed to calculate formula. Status code: ${response.statusCode}');
    }
  }

  static Future<void> newGame(void Function(List<int>) onNewGameData) async {
    final response =
        await http.get(Uri.parse('$baseUri/games/new_game'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Response Data: $jsonResponse');
      final digits = List<int>.from(jsonResponse['digits']);

      onNewGameData(digits);
    } else {
      throw Exception(
          'Failed to get new game data. Status code: ${response.statusCode}');
    }
  }

  static Future<void> clearFormula() async {
    final Uri uri = Uri.parse('$baseUri/games/clear_formula');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> requestBody = {'formula': ""};

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('API Call: clear formula');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Response Data: $responseData');
    } else {
      throw Exception(
          'Failed to clear formula. Status code: ${response.statusCode}');
    }
  }

  static Future<void> deleteValue(int index) async {
    final Uri uri = Uri.parse('$baseUri/games/delete_value');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> requestBody = {'index': index};

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    print('API Call: delete index value: $index');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('Response Data: $responseData');
    } else {
      throw Exception(
          'Failed to delete Value. Status code: ${response.statusCode}');
    }
  }
}
