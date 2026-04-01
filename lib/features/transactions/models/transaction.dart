import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart'; // We will run build_runner for this

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final bool isExpense;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String notes;

  Transaction({
    String? id,
    required this.amount,
    required this.isExpense,
    required this.category,
    required this.date,
    this.notes = '',
  }) : id = id ?? const Uuid().v4();

  Transaction copyWith({
    String? id,
    double? amount,
    bool? isExpense,
    String? category,
    DateTime? date,
    String? notes,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      isExpense: isExpense ?? this.isExpense,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}
