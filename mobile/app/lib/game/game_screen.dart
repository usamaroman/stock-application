import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class InvestorSimulatorScreen extends StatefulWidget {
  @override
  _InvestorSimulatorScreenState createState() =>
      _InvestorSimulatorScreenState();
}

class _InvestorSimulatorScreenState extends State<InvestorSimulatorScreen> {
  double _balance = 10000.0;
  Map<String, double> _assets = {
    "Акции": 100.0, 
    "Криптовалюта": 200.0, 
    "Недвижимость": 500.0, 
    "Биржа": 1000.0, 
  };
  Map<String, double> _previousPrices = {
    "Акции": 100.0,
    "Криптовалюта": 200.0,
    "Недвижимость": 500.0,
    "Биржа": 1000.0,
  };
  Map<String, int> _investments = {
    "Акции": 0,
    "Криптовалюта": 0,
    "Недвижимость": 0,
    "Биржа": 0,
  };
  Map<String, double> _investedAmount = {
    "Акции": 0.0,
    "Криптовалюта": 0.0,
    "Недвижимость": 0.0,
    "Биржа": 0.0,
  };


  void _simulateMarket() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _assets.forEach((key, value) {
        
          _assets[key] = value * (1 + (Random().nextDouble() - 0.5) * 0.05);
        });
      });
    });
  }


  void _invest(String asset) {
    if (_balance >= _assets[asset]!) {
      setState(() {
        _investments[asset] = _investments[asset]! + 1;
        _balance -= _assets[asset]!;
        _investedAmount[asset] = _investedAmount[asset]! + _assets[asset]!; 
      });
    }
  }

  // Продажа актива
  void _sell(String asset) {
    if (_investments[asset]! > 0) {
      setState(() {
        _investments[asset] = _investments[asset]! - 1;
        _balance += _assets[asset]!; 
        _investedAmount[asset] = _investedAmount[asset]! - _assets[asset]!;
      });
    }
  }


  double _calculatePercentageChange(String asset) {
    double previousPrice = _previousPrices[asset]!;
    double currentPrice = _assets[asset]!;
    double percentageChange = ((currentPrice - previousPrice) / previousPrice) * 100;
    _previousPrices[asset] = currentPrice;


    return percentageChange < 0 ? 0.0 : percentageChange;
  }

 
  double _calculateEarnings(String asset) {
    double currentPrice = _assets[asset]!;
    double invested = _investedAmount[asset]!;
    double earnings = (currentPrice - invested) * _investments[asset]!;

    return earnings < 0 ? 0.0 : earnings;
  }

  @override
  void initState() {
    super.initState();
    _simulateMarket(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Симулятор инвестора')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Баланс: ${_balance.toStringAsFixed(2)} ₽', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Инвестиционные категории',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    // Каждая категория
                    ..._assets.keys.map((asset) {
                      double earnings = _calculateEarnings(asset);
                      double percentageChange = _calculatePercentageChange(asset);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                
                          Text(
                            asset,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text('Цена: ${_assets[asset]!.toStringAsFixed(2)} ₽'),
                          SizedBox(height: 8),
                          Text(
                            'Инвестировано: ${_investments[asset]} шт',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Заработано: ${_calculateEarnings(asset).toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 14),
                          ),


                          SizedBox(height: 16),

                          Text(
                            '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: percentageChange >= 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => _invest(asset),
                                child: Text('Инвестировать'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _sell(asset),
                                child: Text('Продать'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
              
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Как работает симулятор и как понять, можно ли заработать?',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '1. Каждый актив (акции, криптовалюта, недвижимость, биржа) имеет начальную цену. '
                            'Эти цены будут случайным образом изменяться, как на реальном рынке.\n\n'
                            '2. Процентное изменение показывает, насколько цена актива изменилась за последние секунды. '
                            'Положительный процент означает, что актив подорожал, а отрицательный — подешевел.\n\n'
                            '3. Заработок рассчитывается как разница между текущей ценой и ценой, по которой вы вложили деньги в актив. '
                            'Если цена актива выросла, ваш заработок будет положительным.\n\n'
                            '4. Чтобы заработать на инвестициях, важно следить за динамикой рынка. '
                            'Инвестирование в активы с ростом цен может привести к прибыли, но также важно учитывать риски, связанные с падением цен.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
