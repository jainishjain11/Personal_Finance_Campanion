import '../models/transaction.dart';
import 'package:uuid/uuid.dart';

class MockService {
  static List<Transaction> generateMockData() {
    final now = DateTime.now();
    final List<Transaction> transactions = [];
    final uuid = const Uuid();

    // Authentic Developer Context
    final List<Map<String, dynamic>> expenses = [
      {'category': 'Utilities', 'notes': 'Vercel Subscription', 'amount': 45.0, 'daysAgo': 2},
      {'category': 'Health', 'notes': 'Hostel Laundry', 'amount': 12.5, 'daysAgo': 0},
      {'category': 'Food', 'notes': 'Office Canteen', 'amount': 14.0, 'daysAgo': 1},
      {'category': 'Food', 'notes': 'Coffee Shop', 'amount': 5.5, 'daysAgo': 1},
      {'category': 'Transport', 'notes': 'Uber to Office', 'amount': 22.0, 'daysAgo': 2},
      {'category': 'Shopping', 'notes': 'Project Components', 'amount': 120.0, 'daysAgo': 4},
      {'category': 'Food', 'notes': 'Late night pizza', 'amount': 18.0, 'daysAgo': 5},
      {'category': 'Utilities', 'notes': 'Internet Bill', 'amount': 60.0, 'daysAgo': 8},
      {'category': 'Health', 'notes': 'Gym Membership', 'amount': 40.0, 'daysAgo': 10},
      {'category': 'Food', 'notes': 'Groceries', 'amount': 85.0, 'daysAgo': 12},
      {'category': 'Shopping', 'notes': 'Steam Game Sale', 'amount': 30.0, 'daysAgo': 15},
      {'category': 'Transport', 'notes': 'Flight Tickets', 'amount': 250.0, 'daysAgo': 20},
      {'category': 'Food', 'notes': 'Office Canteen', 'amount': 11.0, 'daysAgo': 22},
      {'category': 'Food', 'notes': 'Coffee Shop', 'amount': 4.5, 'daysAgo': 23},
      {'category': 'Other', 'notes': 'GitHub Copilot Sub', 'amount': 10.0, 'daysAgo': 25},
      {'category': 'Food', 'notes': 'Groceries', 'amount': 110.0, 'daysAgo': 28},
      {'category': 'Utilities', 'notes': 'Electricity', 'amount': 95.0, 'daysAgo': 29},
    ];

    final List<Map<String, dynamic>> incomes = [
      {'category': 'Salary', 'notes': 'Tech Corp Salary', 'amount': 4200.0, 'daysAgo': 1},
      {'category': 'Freelance', 'notes': 'Upwork Bugfix', 'amount': 150.0, 'daysAgo': 6},
      {'category': 'Investments', 'notes': 'Stock Dividends', 'amount': 45.0, 'daysAgo': 18},
    ];

    for (var exp in expenses) {
      transactions.add(Transaction(
        id: uuid.v4(),
        amount: exp['amount'],
        isExpense: true,
        category: exp['category'],
        notes: exp['notes'],
        date: now.subtract(Duration(days: exp['daysAgo'])),
      ));
    }

    for (var inc in incomes) {
      transactions.add(Transaction(
        id: uuid.v4(),
        amount: inc['amount'],
        isExpense: false,
        category: inc['category'],
        notes: inc['notes'],
        date: now.subtract(Duration(days: inc['daysAgo'])),
      ));
    }

    return transactions;
  }
}
