import 'package:app/separate_chart.dart';
import 'package:app/main_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  String _selectedTimeFrame = '1M';

  final Map<String, List<List<FlSpot>>> _timeFrameData = {
    '1M': [
      [const FlSpot(1, 2), const FlSpot(2, 3), const FlSpot(3, 5), const FlSpot(4, 4)],
      [const FlSpot(1, 1), const FlSpot(2, 4), const FlSpot(3, 3), const FlSpot(4, 6)],
      [const FlSpot(1, 5), const FlSpot(2, 6), const FlSpot(3, 7), const FlSpot(4, 3)],
      [const FlSpot(1, 3), const FlSpot(2, 2), const FlSpot(3, 4), const FlSpot(4, 5)],
    ],
    '6M': [
      [const FlSpot(1, 2), const FlSpot(2, 3), const FlSpot(3, 5), const FlSpot(6, 4)],
      [const FlSpot(1, 1), const FlSpot(2, 4), const FlSpot(3, 3), const FlSpot(6, 7)],
      [const FlSpot(1, 3), const FlSpot(2, 2), const FlSpot(3, 4), const FlSpot(6, 5)],
      [const FlSpot(1, 4), const FlSpot(2, 5), const FlSpot(3, 7), const FlSpot(6, 6)],
    ],
    '1Y': [
      [const FlSpot(1, 5), const FlSpot(6, 7), const FlSpot(12, 8)],
      [const FlSpot(1, 4), const FlSpot(6, 6), const FlSpot(12, 9)],
      [const FlSpot(1, 3), const FlSpot(6, 4), const FlSpot(12, 5)],
      [const FlSpot(1, 2), const FlSpot(6, 3), const FlSpot(12, 4)],
    ],
  };

  double _getMaxX() {
    switch (_selectedTimeFrame) {
      case '6M':
        return 6.0;
      case '1Y':
        return 12.0;
      default:
        return 4.0;
    }
  }

  List<String> _getXAxisLabels() {
    switch (_selectedTimeFrame) {
      case '6M':
        return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
      case '1Y':
        return ['Jan', 'Mar', 'May', 'Jul', 'Sep', 'Nov'];
      default:
        return ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphs'),
        actions: [
          DropdownButton<String>(
            value: _selectedTimeFrame,
            dropdownColor: Colors.white,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            items: _timeFrameData.keys.map((String timeFrame) {
              return DropdownMenuItem<String>(
                value: timeFrame,
                child: Text(timeFrame),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedTimeFrame = newValue;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomLineChart(
          dataSets: _timeFrameData[_selectedTimeFrame]!,
          colors: const [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.purple,
          ],
          maxX: _getMaxX(),
          xLabels: _getXAxisLabels(),
        ),
      ),
    );
  }
}