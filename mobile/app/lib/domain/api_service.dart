import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ApiService {
  Future<Map<String, dynamic>> getData(String endpoint);
  Future<Map<String, dynamic>> postData(String endpoint, Map<String, dynamic> data);
}

class ApiClient implements ApiService {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  @override
  Future<Map<String, dynamic>> getData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Ошибка при загрузке данных');
    }
  }

  @override
  Future<Map<String, dynamic>> postData(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Ошибка при отправке данных');
    }
  }

  
}
