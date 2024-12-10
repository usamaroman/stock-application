import 'dart:convert';

class ChartRequest {
  final int duration;
  final double partAmount;

  ChartRequest({
    required this.duration,
    required this.partAmount,
  });

  // Фабричный конструктор для создания объекта из JSON
  factory ChartRequest.fromJson(Map<String, dynamic> json) {
    return ChartRequest(
      duration: json['duration'],
      partAmount: json['part_amount'],
    );
  }

  // Метод для сериализации объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'part_amount': partAmount,
    };
  }

  @override
  String toString() {
    return 'ChartRequest{duration: $duration, partAmount: $partAmount}';
  }
}

