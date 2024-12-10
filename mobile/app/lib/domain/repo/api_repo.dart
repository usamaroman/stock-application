import 'package:app/domain/api_service.dart';

class InvestmentRepository {
  final ApiService apiService;

  InvestmentRepository({required this.apiService});


  Future<Map<String, dynamic>> getInvestments() async {
    try {
      final result = await apiService.getData('investments');
      return result;
    } catch (e) {
      throw Exception('Ошибка при получении инвестиций: $e');
    }
  }

  Future<Map<String, dynamic>> createInvestment(Map<String, dynamic> investmentData) async {
    try {
      final result = await apiService.postData('investments', investmentData);
      return result;
    } catch (e) {
      throw Exception('Ошибка при создании инвестиции: $e');
    }
  }
}
