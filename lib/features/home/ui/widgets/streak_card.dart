import 'package:flutter/material.dart';
import '../../../../features/transactions/models/transaction.dart';

class StreakCard extends StatelessWidget {
  final List<Transaction> transactions;

  const StreakCard({super.key, required this.transactions});

  int _calculateStreak() {
    int streak = 0;
    // Essential categories we still allow in a 'no non-essential spend' streak
    final Set<String> essentials = {'Utilities', 'Health', 'Transport'};

    final Map<String, double> dailySpends = {};
    for (var tx in transactions) {
      if (tx.isExpense && !essentials.contains(tx.category)) {
        final dateKey = '${tx.date.year}-${tx.date.month}-${tx.date.day}';
        dailySpends[dateKey] = (dailySpends[dateKey] ?? 0) + tx.amount;
      }
    }

    DateTime current = DateTime.now();
    while (true) {
      final key = '${current.year}-${current.month}-${current.day}';
      if ((dailySpends[key] ?? 0) == 0) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    int streak = _calculateStreak();
    
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.whatshot,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'No-Spend Streak',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$streak Days going strong!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
