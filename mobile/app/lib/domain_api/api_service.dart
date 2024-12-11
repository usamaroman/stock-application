import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> sendInvestmentData({
    required double amount,
  }) async {
    final url = Uri.parse('$baseUrl/investment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "amount": amount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send investment data: ${response.statusCode}');
    }
  }

  Future<List<double>> fetchAllInvestments() async {
    final url = Uri.parse('$baseUrl/investments');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as double).toList();
    } else {
      throw Exception('Failed to fetch investments: ${response.statusCode}');
    }
  }

  Future<List<double>> fetchGoldPrediction({required int duration}) async {
    final url = Uri.parse('$baseUrl/calculate_gold');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"duration": duration}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as double).toList();
    } else {
      throw Exception('Failed to fetch gold prediction: ${response.statusCode}');
    }
  }

  Future<List<double>> fetchDollarPrediction({required int duration}) async {
    final url = Uri.parse('$baseUrl/calculate_dollar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"duration": duration}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => e as double).toList();
    } else {
      throw Exception('Failed to fetch dollar prediction: ${response.statusCode}');
    }
  }
}

