import 'dart:math';
import 'package:app/chart/chart.dart';
import 'package:app/domain_api/api_service.dart';
import 'package:app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvestmentDetailedScreen extends StatefulWidget {
  final ChartData chartData;
  final double amount;
  final String title;
  final Color color;

  const InvestmentDetailedScreen({
    super.key,
    required this.chartData,
    required this.amount,
    required this.title,
    required this.color,
  });

  @override
  _InvestmentDetailedScreenState createState() =>
      _InvestmentDetailedScreenState();
}

class _InvestmentDetailedScreenState extends State<InvestmentDetailedScreen> {
  final ApiService _apiService = ApiService(baseUrl: 'http://localhost:8080');
  List<double>? _dollarRates;
  bool _isLoading = false;
  String _errorMessage = '';

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  Future<void> _fetchDollarPrediction(int duration) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final rates = await _apiService.fetchDollarPrediction(duration: duration);
      setState(() {
        _dollarRates = rates;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchGoldPrediction(int duration) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final rates = await _apiService.fetchGoldPrediction(duration: duration);
      setState(() {
        _dollarRates = rates;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDollarPrediction(12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Детали инвестиций')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(widget.amount / 4).toStringAsFixed(2)} RUB',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DropdownTimeFilter(
            onSelected: (selectedValue) {
              final now = DateTime.now();
              int duration;

              switch (selectedValue) {
                case '1M':
                  duration = 1;
                  break;
                case '3M':
                  duration = 3;
                  break;
                case '6M':
                  duration = 6;
                  break;
                case '1Y':
                  duration = 12;
                  break;
                case '2Y':
                  duration = 24;
                  break;
                default:
                  duration = 12;
              }

              _fetchDollarPrediction(duration);
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : LineChartSample2(
                        chartData: _dollarRates != null
                            ? convertToChartData(_dollarRates!)
                            : widget.chartData,
                      ),
          ),
        ],
      ),
    );
  }
}

class DropdownTimeFilter extends StatelessWidget {
  final Function(String) onSelected;

  const DropdownTimeFilter({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: '1M',
      items: const [
        DropdownMenuItem(value: '1M', child: Text('1 месяц')),
        DropdownMenuItem(value: '3M', child: Text('3 месяца')),
        DropdownMenuItem(value: '6M', child: Text('6 месяцев')),
        DropdownMenuItem(value: '1Y', child: Text('1 год')),
        DropdownMenuItem(value: '2Y', child: Text('2 года')),
      ],
      onChanged: (value) {
        if (value != null) onSelected(value);
      },
    );
  }
}