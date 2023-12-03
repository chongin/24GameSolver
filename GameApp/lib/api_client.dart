// api_client.dart
import 'dart:async';

class ApiClient {
  static Future<void> updateValue(int index, String? value) async {
    await Future.delayed(Duration(seconds: 1));

    print('API Call: update_value - Index: $index, Value: $value');

    // You can add your actual API call here
    // For example, using the 'http' package:
    // final response = await http.post('your_api_url', body: {'index': index.toString(), 'value': value});
    // print(response.body);
  }
}
