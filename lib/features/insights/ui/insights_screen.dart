import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../transactions/providers/transaction_provider.dart';
import 'widgets/category_pie_chart.dart';
import 'widgets/weekly_bar_chart.dart';
import 'widgets/smart_projection_card.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Monthly Spending by Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: SizedBox(
                  height: 250,
                  child: CategoryPieChart(transactions: transactions),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SmartProjectionCard(transactions: transactions),
            const SizedBox(height: 32),
            Text(
              'This Week vs Last Week',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: WeeklyBarChart(transactions: transactions),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
