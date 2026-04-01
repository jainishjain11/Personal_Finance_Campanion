import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../features/transactions/models/transaction.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<Transaction> transactions;

  const WeeklyBarChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Current Week vs Last Week
    final now = DateTime.now();
    final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

    // Array for exactly 7 days (Mon-Sun)
    List<double> thisWeekSpends = List.filled(7, 0.0);
    List<double> lastWeekSpends = List.filled(7, 0.0);

    double maxSpend = 0;

    for (var tx in transactions) {
      if (!tx.isExpense) continue;

      if (tx.date.isAfter(startOfThisWeek.subtract(const Duration(days: 1))) &&
          tx.date.isBefore(startOfThisWeek.add(const Duration(days: 7)))) {
        final idx = tx.date.weekday - 1;
        thisWeekSpends[idx] += tx.amount;
        if (thisWeekSpends[idx] > maxSpend) maxSpend = thisWeekSpends[idx];
      } else if (tx.date.isAfter(startOfLastWeek.subtract(const Duration(days: 1))) &&
          tx.date.isBefore(startOfLastWeek.add(const Duration(days: 7)))) {
        final idx = tx.date.weekday - 1;
        lastWeekSpends[idx] += tx.amount;
        if (lastWeekSpends[idx] > maxSpend) maxSpend = lastWeekSpends[idx];
      }
    }

    if (maxSpend == 0) maxSpend = 1;

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxSpend * 1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
                  String text;
                  switch (value.toInt()) {
                    case 0: text = 'M'; break;
                    case 1: text = 'T'; break;
                    case 2: text = 'W'; break;
                    case 3: text = 'T'; break;
                    case 4: text = 'F'; break;
                    case 5: text = 'S'; break;
                    case 6: text = 'S'; break;
                    default: text = ''; break;
                  }
                  return Padding(padding: const EdgeInsets.only(top: 8), child: Text(text, style: style));
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: lastWeekSpends[i],
                  color: Colors.grey.withOpacity(0.5),
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: thisWeekSpends[i],
                  color: Theme.of(context).colorScheme.primary,
                  width: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
