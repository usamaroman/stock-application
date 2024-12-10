import 'package:fl_chart/fl_chart.dart';

class ChartData {
  final List<FlSpot> points; // Точки графика
  final String xAxisLabel; // Подпись для оси X
  final String yAxisLabel; // Подпись для оси Y
  final double minX; // Минимальное значение по X
  final double maxX; // Максимальное значение по X
  final double minY; // Минимальное значение по Y
  final double maxY; // Максимальное значение по Y

  ChartData({
    required this.points,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });
}
