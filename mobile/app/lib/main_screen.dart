import 'package:app/bottom_sheet.dart';
import 'package:app/investment_detailed_screen.dart';
import 'package:app/model/model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:app/article_screen.dart';
import 'package:app/article_screen2.dart';

class InvestmentHomeScreen extends StatefulWidget {
  const InvestmentHomeScreen({super.key});

  @override
  State<InvestmentHomeScreen> createState() => _InvestmentHomeScreenState();
}

class _InvestmentHomeScreenState extends State<InvestmentHomeScreen> {
  double _portfolioAmount = 0;
  final List<Map<String, dynamic>> _investmentCards = [
    {
      'title': 'Акции',
      'subtitle': 'Индекс МосБиржи (ММВБ)',
      'color': Colors.blue
    },
    {'title': 'Облигации', 'subtitle': 'RGBI МосБиржа', 'color': Colors.teal},
    {'title': 'Валюта', 'subtitle': 'По курсу ЦБ', 'color': Colors.orange},
    {
      'title': 'Золото',
      'subtitle': 'Индекс Золото (Банк России)',
      'color': Colors.amber
    },
  ];

  final List<Map<String, String>> _articles = [
    {
      'title': 'Какие бывают инвестиции',
      'content':
          'Если удачно вложить деньги, можно увеличить капитал в несколько раз...'
    },
    {
      'title': 'Диверсификация портфеля',
      'content':
          'Диверсификация портфеля является базовым принципом основ инвестиций...'
    },
  ];

  final ChartData myChartData = ChartData(
    points: [
      const FlSpot(0, 3),
      const FlSpot(2.6, 2),
      const FlSpot(4.9, 5),
      const FlSpot(6.8, 3.1),
      const FlSpot(8, 4),
      const FlSpot(9.5, 3),
      const FlSpot(11, 4),
    ],
    xAxisLabel: 'Месяцы',
    yAxisLabel: 'Доходы',
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
  );

  void _addInvestment(double amount) {
    setState(() {
      _portfolioAmount += amount;
    });

    // отправить данные на сервер
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добро пожаловать!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Общая сумма инвестиций',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'RUB ${_portfolioAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showInvestmentBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green, // Button text color
                      backgroundColor: Colors.white, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                    child: const Text('Инвестировать'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Стратегии',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Смотреть все'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _investmentCards.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index < _investmentCards.length) {
                    final card = _investmentCards[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvestmentDetailedScreen(
                              chartData: myChartData,
                              amount: _portfolioAmount,
                              title: card['title'],
                              color: card['color'],
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 160,
                        child: _buildStrategyCard(
                          card['title'],
                          card['subtitle'],
                          card['color'],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      width: 160,
                      child: _buildAddInvestmentCard(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            // Guides Section
            // Guides Section
            const Text(
              'Гайды',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              children: _articles.asMap().entries.map((entry) {
                final index = entry.key; // Индекс статьи
                final article = entry.value; // Содержимое статьи
                return _buildGuideTile(
                  article['title']!,
                  'Нажмите чтобы узнать подробнее...', // Краткое описание
                  article['content']!,
                  index, // Передаем индекс статьи
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Продукт'),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), label: 'Транзакции'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Аккаунт'),
        ],
      ),
    );
  }

  // Widget _buildStrategyCard(String title, String subtitle, Color color) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: color.withOpacity(0.2),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       children: [
  //         Icon(Icons.monetization_on, size: 40, color: color),
  //         const SizedBox(height: 8),
  //         Text(
  //           title,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           subtitle,
  //           style: const TextStyle(color: Colors.grey),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStrategyCard(String title, String returnRate, Color color) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.monetization_on, size: 40, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 4),
          Text(
            returnRate,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildAddInvestmentCard() {
    return GestureDetector(
      onTap: _addCustomInvestmentCard,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.black, size: 32),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {},
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Продукт'),
        BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Транзакции'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Аккаунт'),
      ],
    );
  }

  void _showInvestmentBottomSheet(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Введите сумму',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Введите сумму',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.monetization_on),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final investment = double.tryParse(_controller.text);
                  if (investment != null) {
                    _addInvestment(investment);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Подтвердить инвестирование',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _addCustomInvestmentCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController subtitleController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Добавить тип инвестиции'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _investmentCards.add({
                    'title': titleController.text,
                    'subtitle': subtitleController.text,
                    'color': Colors.grey,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGuideTile(
  String title, String subtitle, String content, int index) {
  // List of image URLs corresponding to each article
  List<String> imageUrls = [
    'https://248006.selcdn.ru/main/iblock/5c7/5c77a418f946679b5018012a12a565a4/5decd0995a033381b90522db11a85561.jpg',  // Image for the first article
    'https://static.ifxdb.com/static-content/607/PX241_800.jpg',  // Image for the second article
    // Add more images for other articles if needed
  ];

  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage(imageUrls[index]),  // Get image for the specific article
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(
      subtitle,
      style: const TextStyle(color: Colors.grey),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {
      if (index == 0) {
        // Первая статья открывает ArticleScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ArticleScreen(title: title, content: content),
          ),
        );
      } else if (index == 1) {
        // Вторая статья открывает ArticleScreen2
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ArticleScreen2(title: title, content: content),
          ),
        );
      }
    },
  );
}

// Widget _buildGuideTile(BuildContext context, String title, String content) {
//   return ListTile(
//     contentPadding: EdgeInsets.zero,
//     leading: const CircleAvatar(
//       backgroundColor: Colors.blueAccent,
//       radius: 24,
//     ),
//     title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//     subtitle: Text(
//       content,
//       style: const TextStyle(color: Colors.grey),
//       maxLines: 2,
//       overflow: TextOverflow.ellipsis,
//     ),
//     trailing: const Icon(Icons.chevron_right),
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ArticleScreen(title: title, content: content),
//         ),
//       );
//     },
//   );
// }
}