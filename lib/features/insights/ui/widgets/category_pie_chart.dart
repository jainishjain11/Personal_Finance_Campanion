import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../features/transactions/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/currency_formatter.dart';

class CategoryPieChart extends StatefulWidget {
  final List<Transaction> transactions;

  const CategoryPieChart({super.key, required this.transactions});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Filter to current month expenses
    final now = DateTime.now();
    final monthExpenses = widget.transactions.where((tx) => 
        tx.isExpense && tx.date.year == now.year && tx.date.month == now.month).toList();

    if (monthExpenses.isEmpty) {
      return const Center(child: Text('No expenses this month'));
    }

    final Map<String, double> categoryTotals = {};
    for (var tx in monthExpenses) {
      categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    // Sort categories
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalAmount = monthExpenses.fold(0.0, (sum, tx) => sum + tx.amount);

    final colors = [
      Colors.blue, Colors.red, Colors.orange, Colors.green, Colors.purple, Colors.cyan, Colors.yellow
    ];

    return Consumer(
      builder: (context, ref, _) {
        final formatter = ref.watch(currencyFormatterProvider);
        return Row(
          children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: List.generate(sortedCategories.length, (i) {
                final isTouched = i == touchedIndex;
                final fontSize = isTouched ? 20.0 : 14.0;
                final radius = isTouched ? 60.0 : 50.0;
                final entry = sortedCategories[i];
                final percentage = (entry.value / totalAmount) * 100;

                return PieChartSectionData(
                  color: colors[i % colors.length],
                  value: entry.value,
                  title: isTouched ? formatter.format(entry.value) : '${percentage.toStringAsFixed(1)}%',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
                  ),
                );
              }),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: colors[index % colors.length]),
                    const SizedBox(width: 8),
                    Expanded(child: Text(sortedCategories[index].key, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
      },
    );
  }
}
