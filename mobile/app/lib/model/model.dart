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

ChartData convertToChartData(List<double> dollarRates) {
  List<FlSpot> points = [];
  for (int i = 0; i < dollarRates.length; i++) {
    points.add(FlSpot(i.toDouble(), dollarRates[i]));
  }

  double minX = 0;
  double maxX = dollarRates.length.toDouble();
  double minY = dollarRates.reduce((value, element) => value < element ? value : element);
  double maxY = dollarRates.reduce((value, element) => value > element ? value : element);

  return ChartData(
    points: points,
    xAxisLabel: 'Дата', // Например, здесь можно поставить метки времени для оси X
    yAxisLabel: 'Курс доллара',
    minX: minX,
    maxX: maxX,
    minY: minY,
    maxY: maxY,
  );
}
