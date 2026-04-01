import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../transactions/models/transaction.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/currency_formatter.dart';
import 'widgets/settings_sheet.dart';
import 'package:intl/intl.dart';
import 'widgets/streak_card.dart';
import 'widgets/mini_chart.dart';
import 'widgets/health_score_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);
    final formatter = ref.watch(currencyFormatterProvider);
    
    double totalBalance = 0;
    double monthIncome = 0;
    double monthExpense = 0;

    final now = DateTime.now();
    for (var tx in transactions) {
      if (tx.isExpense) {
        totalBalance -= tx.amount;
        if (tx.date.year == now.year && tx.date.month == now.month) {
          monthExpense += tx.amount;
        }
      } else {
        totalBalance += tx.amount;
        if (tx.date.year == now.year && tx.date.month == now.month) {
          monthIncome += tx.amount;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const SettingsSheet(),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance Card
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatter.format(totalBalance),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniSummary(context, 'Income', monthIncome, true, formatter),
                        _buildMiniSummary(context, 'Expenses', monthExpense, false, formatter),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Spending Trend Header
            Text(
              '7-Day Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Mini Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MiniChart(transactions: transactions),
              ),
            ),
            
            const SizedBox(height: 24),
            // Streak Card
            StreakCard(transactions: transactions),
            const SizedBox(height: 24),
            // Health Score
            const HealthScoreCard(),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/transactions');
                  },
                  child: const Text('See All'),
                )
              ],
            ),
            const SizedBox(height: 16),
            ..._buildRecentActivity(context, transactions, formatter),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/chat'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
    );
  }

  Widget _buildMiniSummary(BuildContext context, String label, double amount, bool isIncome, NumberFormat formatter) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8), fontSize: 12)),
            Text(formatter.format(amount), style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  List<Widget> _buildRecentActivity(BuildContext context, List<Transaction> transactions, NumberFormat formatter) {
    if (transactions.isEmpty) {
      return [const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No recent activity'),
      ))];
    }
    
    return transactions.take(5).map((tx) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: tx.isExpense ? Colors.redAccent.withOpacity(0.1) : Colors.green.withOpacity(0.1),
          child: Icon(
            _getIconForCategory(tx.category),
            color: tx.isExpense ? Colors.redAccent : Colors.green,
          ),
        ),
        title: Text(tx.category, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(Formatters.shortDate(tx.date)),
        trailing: Text(
          '${tx.isExpense ? '-' : '+'}${formatter.format(tx.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: tx.isExpense ? null : Colors.green,
            fontSize: 16,
          ),
        ),
      );
    }).toList();
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Food': return Icons.fastfood;
      case 'Transport': return Icons.directions_car;
      case 'Utilities': return Icons.bolt;
      case 'Entertainment': return Icons.movie;
      case 'Health': return Icons.medical_services;
      case 'Shopping': return Icons.shopping_bag;
      case 'Salary': return Icons.attach_money;
      case 'Gifts': return Icons.card_giftcard;
      case 'Investments': return Icons.trending_up;
      default: return Icons.category;
    }
  }
}
