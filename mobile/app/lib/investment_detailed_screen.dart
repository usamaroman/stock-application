import 'package:app/chart/chart.dart';
import 'package:app/chart/dropdown.dart';
import 'package:app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InvestmentDetailedScreen extends StatefulWidget {
  final ChartData chartData;
  final double amount; // Добавляем amount как переменную экземпляра
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Детали инвестиций')),
      body: Column(
        children: [
          // Карточка с фоном
          Container(
            padding: const EdgeInsets.all(16),  // Увеличиваем внутренний отступ
            width: MediaQuery.of(context).size.width * 0.9,  // Карточка почти на всю ширину экрана
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              // image: const DecorationImage(
              //   image: AssetImage('assets/images/dollar_background.png'),  // Путь к изображению
              //   fit: BoxFit.cover,  // Картинка будет растягиваться на всю карточку
              //   opacity: 0.1,  // Делаем картинку немного прозрачной, чтобы она не мешала тексту
              // ),
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
                  '${(widget.amount / 4).toStringAsFixed(2)} RUB', // Используем widget.amount
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Дропдаун
          DropdownTimeFilter(
            onSelected: (selectedValue) {
              print('Выбранный диапазон времени: $selectedValue');
              // Добавьте логику для обработки выбранного диапазона
            },
          ),
          const SizedBox(height: 16),
          // График
          Expanded(
            child: LineChartSample2(chartData: widget.chartData), // Используем widget.chartData
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
