import '../../transactions/models/transaction.dart';
import '../../transactions/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatService {
  static const _greeting = "I'm FinBot, your local financial assistant!\nTry asking me 'What is my balance?' or tell me 'I spent ₹200 on lunch'.";

  Future<String> processMessage(String text, WidgetRef ref) async {
    final lowerText = text.toLowerCase().trim();

    // Query: Balance
    if (lowerText.contains('balance')) {
      return _calculateBalance(ref);
    }
    
    // Query: Spent this week / month
    if (lowerText.contains('spent') && (lowerText.contains('week') || lowerText.contains('month'))) {
      return _calculateSpending(ref, lowerText.contains('week'));
    }

    // Data Entry: "Spent X on Y" or "Got X from Y"
    if (lowerText.startsWith('spent') || lowerText.startsWith('got')) {
      return _processTransactionEntry(text, ref);
    }

    // Fallback
    return _greeting;
  }

  String _calculateBalance(WidgetRef ref) {
    final transactions = ref.read(transactionListProvider);
    double balance = 0;
    for (var tx in transactions) {
      if (tx.isExpense) {
        balance -= tx.amount;
      } else {
        balance += tx.amount;
      }
    }
    return 'Your current balance is ${balance.toStringAsFixed(2)}';
  }

  String _calculateSpending(WidgetRef ref, bool isWeek) {
    final transactions = ref.read(transactionListProvider);
    final now = DateTime.now();
    double spent = 0;

    for (var tx in transactions) {
      if (tx.isExpense) {
        if (isWeek) {
          // Last 7 days
          if (now.difference(tx.date).inDays <= 7) {
            spent += tx.amount;
          }
        } else {
          // Current month
          if (tx.date.year == now.year && tx.date.month == now.month) {
            spent += tx.amount;
          }
        }
      }
    }

    final period = isWeek ? 'in the last 7 days' : 'this month';
    return "You've spent ${spent.toStringAsFixed(2)} $period.";
  }

  String _processTransactionEntry(String text, WidgetRef ref) {
    final isExpense = text.toLowerCase().startsWith('spent');
    
    // Simple regex to extract number: look for digits possibly with decimal
    final amtMatch = RegExp(r'\d+(\.\d+)?').firstMatch(text);
    if (amtMatch == null) {
      return 'I could not find an amount in your message. Please specify the amount (e.g., "Spent 150 on food").';
    }

    final amountStr = amtMatch.group(0)!;
    final amount = double.parse(amountStr);

    // Optional note extraction could go here. For now default to entire string:
    String category = isExpense ? 'Other' : 'Other'; // default
    String note = text;

    // A very loose keyword match for categories
    final lowerText = text.toLowerCase();
    if (lowerText.contains('food') || lowerText.contains('coffee') || lowerText.contains('lunch') || lowerText.contains('canteen')) {
      category = 'Food';
    } else if (lowerText.contains('uber') || lowerText.contains('taxi') || lowerText.contains('flight')) {
      category = 'Transport';
    } else if (lowerText.contains('salary') || lowerText.contains('stipend')) {
      category = 'Salary';
      // If they said "got X from salary", ensure it's logged as income if logic somehow failed
    }

    final tx = Transaction(
      amount: amount,
      isExpense: isExpense,
      category: category,
      notes: note,
      date: DateTime.now(),
    );

    ref.read(transactionListProvider.notifier).addTransaction(tx);

    final action = isExpense ? 'an expense' : 'inflow';
    return "Got it! I've added $action of $amountStr for $category.";
  }
}
