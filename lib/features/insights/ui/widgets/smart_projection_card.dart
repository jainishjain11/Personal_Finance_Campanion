import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/currency_formatter.dart';
import '../../../../features/transactions/models/transaction.dart';

class SmartProjectionCard extends ConsumerWidget {
  final List<Transaction> transactions;

  const SmartProjectionCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(currencyFormatterProvider);

    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final daysElapsed = now.day == 0 ? 1 : now.day;
    final daysRemaining = daysInMonth - daysElapsed;

    double totalBalance = 0;
    double monthExpense = 0;

    for (var tx in transactions) {
      if (tx.isExpense) {
        totalBalance -= tx.amount;
        if (tx.date.year == now.year && tx.date.month == now.month) {
          monthExpense += tx.amount;
        }
      } else {
        totalBalance += tx.amount;
      }
    }

    final avgDailySpend = monthExpense / daysElapsed;
    final projectedSpend = avgDailySpend * daysRemaining;
    final projectedFinish = totalBalance - projectedSpend;
    
    final isNegative = projectedFinish < 0;

    return Card(
      color: isNegative 
          ? Theme.of(context).colorScheme.errorContainer 
          : Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: isNegative 
                      ? Theme.of(context).colorScheme.onErrorContainer 
                      : Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Monthly Outlook',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isNegative 
                        ? Theme.of(context).colorScheme.onErrorContainer 
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'At your current rate of ${formatter.format(avgDailySpend)}/day, you will finish the month with:',
              style: TextStyle(
                color: isNegative 
                    ? Theme.of(context).colorScheme.onErrorContainer 
                    : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(projectedFinish),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isNegative 
                        ? Theme.of(context).colorScheme.error 
                        : Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
