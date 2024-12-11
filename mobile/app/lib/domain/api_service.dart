import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<double>> fetchDollarRates({
    required String fromDate,
    required String toDate,
  }) async {
    final url = Uri.parse('$baseUrl/dollar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "from": fromDate,
        "to": toDate,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as double).toList();
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}
