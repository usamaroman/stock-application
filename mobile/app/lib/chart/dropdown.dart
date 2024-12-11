import 'package:flutter/material.dart';

class DropdownTimeFilter extends StatefulWidget {
  final Function(String) onSelected;

  const DropdownTimeFilter({super.key, required this.onSelected});

  @override
  State<DropdownTimeFilter> createState() => _DropdownTimeFilterState();
}

class _DropdownTimeFilterState extends State<DropdownTimeFilter> {
  late final List<String> timeRanges;
  String selectedValue = '1 год';

  @override
  void initState() {
    super.initState();
    timeRanges = _generateTimeRanges();
  }

  List<String> _generateTimeRanges() {
    List<String> ranges = [];
    for (int months = 3; months <= 60; months += 3) {
      if (months < 12) {
        ranges.add('$months месяца');
      } else {
        final years = months ~/ 12;
        final remainingMonths = months % 12;
        if (remainingMonths == 0) {
          ranges.add('$years ${_pluralizeYears(years)}');
        } else {
          ranges.add(
              '$years ${_pluralizeYears(years)} $remainingMonths ${_pluralizeMonths(remainingMonths)}');
        }
      }
    }
    return ranges;
  }

  String _pluralizeYears(int years) {
    if (years == 1) {
      return 'год';
    } else if (years >= 2 && years <= 4) {
      return 'года';
    } else {
      return 'лет';
    }
  }

  String _pluralizeMonths(int months) {
    if (months == 1) {
      return 'месяц';
    } else if (months >= 2 && months <= 4) {
      return 'месяца';
    } else {
      return 'месяцев';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      items: timeRanges.map((String range) {
        return DropdownMenuItem<String>(
          value: range,
          child: Text(range),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedValue = newValue;
          });
          widget.onSelected(newValue);
        }
      },
    );
  }
}
