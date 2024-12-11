import 'package:flutter/material.dart';

class ArticleScreen2 extends StatelessWidget {
  final String title;
  final String content;

  const ArticleScreen2({Key? key, required this.title, required this.content})
      : super(key: key);

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

            // Content of the article with styled text and headings

            Text('Диверсификация портфеля является базовым принципом основ инвестиций, который позволяет снизить риски и улучшить потенциальные финансовые результаты. Этот процесс включает в себя распределение инвестиций между различными активами и рынками для минимизации воздействия негативных событий на один актив или сектор.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Image.asset(
                'assets/images/diversion.jpg'), // A relevant image about stock growth

            const SizedBox(height: 16),

            Text(
              'Диверсификация портфеля означает не просто владение множеством активов, но и распределение инвестиций таким образом, чтобы они не зависели друг от друга. Это означает, что при снижении стоимости одних активов, другие могут сохранять свою стоимость или даже увеличиваться в цене, что снижает общий уровень риска портфеля.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Another image that illustrates the risks of investment
            Image.asset('assets/images/diversion2.jpg'),

            const SizedBox(height: 16),

            Text(
              'Путь каждого инвестора уникален, но существуют распространенные ошибки, которые часто совершают начинающие инвесторы. Понимание и избегание этих ошибок может значительно улучшить шансы на успех в инвестициях.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            Text(
              'Одна из самых больших ошибок — вход в инвестиции без должной подготовки. Важно провести время, изучая основы инвестиций, различные классы активов и рыночные условия перед тем, как начать инвестировать. Многие новички склонны недооценивать риски, связанные с инвестициями. Важно понимать, что все инвестиции подразумевают определенный уровень риска и необходимо уметь его оценивать и только после этого принимать решение.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Add an image that reflects financial tools or instruments (e.g., stock, bond)
            Image.asset('assets/images/diversion3.jpg'),

            const SizedBox(height: 16),

            Text(
              'Решения, основанные на эмоциях, часто приводят к плохим инвестиционным результатам. Инвесторы должны стремиться к объективному и аналитическому подходу, избегая панических продаж или чрезмерно оптимистичных покупок на пике рынка.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Conclusion or call to action
            Text(
              'Подведем итоги и выделим ключевые моменты, которые могут помочь в этом увлекательной, но сложной отрасли. Как мы уже писали ранее, инвестирование это не только способ увеличения капитала, но и средство достижения личных и финансовых целей.',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
