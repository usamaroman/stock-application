import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  final String title;
  final String content;

  const ArticleScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Image at the top of the article
            Image.asset(
                'assets/images/investment_intro.jpg'), // Add an image to introduce the topic

            const SizedBox(height: 16),

            // Content of the article with styled text and headings

            const Text(
              'Если удачно вложить деньги, можно увеличить капитал в несколько раз. Например, в 2008 году стоимость акции Volkswagen выросла с 211 евро до 1000 евро меньше чем за два дня.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Image.asset(
                'assets/images/investment_growth.jpg'), // A relevant image about stock growth

            const SizedBox(height: 16),

            const Text(
              'Но капитал можно и потерять — например, в мае 2022 года акции социальной сети Snap подешевели с 22,5 до 12,7 доллара за день.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Another image that illustrates the risks of investment
            Image.asset('assets/images/investment_risk.jpg'),

            const SizedBox(height: 16),

            const Text(
              'Инвестиции — это вложение денег для получения дохода. Вкладывать деньги можно в недвижимость, в бизнес, в депозиты или в инструменты финансового рынка.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            const Text(
              'Инвестиции могут быть разных типов: государственные, корпоративные или индивидуальные. Например, государство может инвестировать в отрасли, бизнес — в новые производства, а обычный человек может инвестировать в недвижимость или на депозит.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Add an image that reflects financial tools or instruments (e.g., stock, bond)
            Image.asset('assets/images/financial_instruments.jpg'),

            const SizedBox(height: 16),

            const Text(
              'Инвестиции используют, чтобы защититься от инфляции и заработать. Инфляция — это обесценивание денег. Например, по итогам 2022 года инфляция в России составила 11,09%.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Conclusion or call to action
            const Text(
              'Итак, инвестиции — это важный способ увеличения капитала и защиты от инфляции. В следующей статье мы расскажем о наиболее популярных финансовых инструментах и их рисках.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
