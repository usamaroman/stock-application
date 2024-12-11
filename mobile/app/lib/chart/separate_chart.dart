import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  final List<List<FlSpot>> dataSets;
  final List<Color> colors;
  final double maxX;
  final List<String> xLabels;

  const CustomLineChart({
    super.key,
    required this.dataSets,
    required this.colors,
    required this.maxX,
    required this.xLabels,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: const LineTouchData(handleBuiltInTouches: true),
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt() - 1;
                if (index >= 0 && index < xLabels.length) {
                  return Text(
                    xLabels[index],
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const SizedBox();
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
              interval: 1,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.black, width: 1),
            left: BorderSide(color: Colors.black, width: 1),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        lineBarsData: _buildLineBarsData(),
        minX: 1,
        maxX: maxX,
        minY: 0,
        maxY: 10,
      ),
    );
  }

  List<LineChartBarData> _buildLineBarsData() {
    return List.generate(dataSets.length, (index) {
      return LineChartBarData(
        isCurved: true,
        color: colors[index],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: dataSets[index],
      );
    });
  }
}
