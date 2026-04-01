import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/providers/currency_formatter.dart';
import 'widgets/transaction_form.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  void _showForm(BuildContext context, [Transaction? tx]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionForm(initialTransaction: tx),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: transactions.isEmpty ? _buildEmptyState(context) : _buildList(context, ref, transactions),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No transactions yet!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text('Tap + to get started.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<Transaction> transactions) {
    // Group by Date
    final Map<String, List<Transaction>> grouped = {};
    for (var tx in transactions) {
      final dateKey = DateFormat('yyyy-MM-dd').format(tx.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(tx);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80), // Fab space
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final key = sortedKeys[index];
        final dayTransactions = grouped[key]!;
        
        DateTime date = DateTime.parse(key);
        String dayHeader = Formatters.dayOfWeek(date);
        
        final today = DateTime.now();
        if (date.year == today.year && date.month == today.month && date.day == today.day) {
          dayHeader = 'Today';
        } else if (date.year == today.year && date.month == today.month && date.day == today.day - 1) {
          dayHeader = 'Yesterday';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                dayHeader,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            ...dayTransactions.map((tx) => _buildTransactionTile(context, ref, tx)),
          ],
        );
      },
    );
  }

  Widget _buildTransactionTile(BuildContext context, WidgetRef ref, Transaction tx) {
    final formatter = ref.watch(currencyFormatterProvider);
    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(transactionListProvider.notifier).deleteTransaction(tx.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transaction deleted')),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tx.isExpense ? Colors.redAccent.withOpacity(0.1) : Colors.green.withOpacity(0.1),
          child: Icon(
            _getIconForCategory(tx.category),
            color: tx.isExpense ? Colors.redAccent : Colors.green,
          ),
        ),
        title: Text(tx.category, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(tx.notes.isNotEmpty ? tx.notes : Formatters.time(tx.date)),
        trailing: Text(
          '${tx.isExpense ? '-' : '+'}${formatter.format(tx.amount)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: tx.isExpense ? null : Colors.green,
          ),
        ),
        onTap: () => _showForm(context, tx),
      ),
    );
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
