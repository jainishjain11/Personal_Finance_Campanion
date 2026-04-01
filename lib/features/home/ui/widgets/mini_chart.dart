import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../features/transactions/models/transaction.dart';

class MiniChart extends StatelessWidget {
  final List<Transaction> transactions;

  const MiniChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) return const SizedBox.shrink();

    // Group last 7 days of expenses
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final List<FlSpot> spots = [];
    double maxAmount = 0;

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      double dailyTotal = 0;
      for (var tx in transactions) {
        if (tx.isExpense &&
            tx.date.year == date.year &&
            tx.date.month == date.month &&
            tx.date.day == date.day) {
          dailyTotal += tx.amount;
        }
      }
      if (dailyTotal > maxAmount) maxAmount = dailyTotal;
      spots.add(FlSpot(6 - i.toDouble(), dailyTotal));
    }

    if (maxAmount == 0) maxAmount = 1;

    return AspectRatio(
      aspectRatio: 2.5,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxAmount * 1.2,
          minX: 0,
          maxX: 6,
          lineTouchData: const LineTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.primary.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
