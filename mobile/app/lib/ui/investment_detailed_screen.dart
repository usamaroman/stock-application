import 'dart:math';
import 'package:app/chart/chart.dart';
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
  // Закомментировано всё, что связано с API
  // final ApiService _apiService = ApiService();
  List<double>? _dollarRates;
  bool _isLoading = false;
  String _errorMessage = '';

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

void _generateMockData(String from, String to) async {
  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });

  try {
    final random = Random();
    double previousRate = 70.0; // начальная цена
    List<double> mockData = [];

  
    for (int i = 0; i < 30; i++) {

      double change = (random.nextDouble() - 0.5) * 1.0; 
      double newRate = (previousRate + change).clamp(65.0, 75.0); 
      mockData.add(newRate);
      previousRate = newRate;
    }

    setState(() {
      _dollarRates = mockData;
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
    // Инициализация с моковыми данными
    _generateMockData('2024-01-01', '2024-12-31');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Детали инвестиций')),
      body: Column(
        children: [
          // Карточка с фоном
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
          // Дропдаун
          DropdownTimeFilter(
            onSelected: (selectedValue) {
              final now = DateTime.now();
              String fromDate;
              String toDate = _formatDate(now); // формируем текущую дату

              switch (selectedValue) {
                case '1M':
                  fromDate = _formatDate(DateTime(now.year, now.month - 1, now.day));
                  break;
                case '3M':
                  fromDate = _formatDate(DateTime(now.year, now.month - 3, now.day));
                  break;
                case '6M':
                  fromDate = _formatDate(DateTime(now.year, now.month - 6, now.day));
                  break;
                case '1Y':
                  fromDate = _formatDate(DateTime(now.year - 1, now.month, now.day));
                  break;
                case '2Y':
                  fromDate = _formatDate(DateTime(now.year - 2, now.month, now.day));
                  break;
                default:
                  fromDate = toDate;
              }

              // Генерация моковых данных
              _generateMockData(fromDate, toDate);
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Текст о графике, например: курс изменился на 2%.',
              style: TextStyle(fontSize: 16),
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
