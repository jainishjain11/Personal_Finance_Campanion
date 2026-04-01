import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/transaction_repository.dart';
import '../models/transaction.dart';
import '../data/mock_service.dart';

part 'transaction_provider.g.dart';

@riverpod
class TransactionList extends _$TransactionList {
  late final TransactionRepository _repository;

  @override
  List<Transaction> build() {
    _repository = TransactionRepository();
    return _repository.getAllTransactions();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.addTransaction(transaction);
    state = _repository.getAllTransactions();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _repository.updateTransaction(transaction);
    state = _repository.getAllTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    state = _repository.getAllTransactions();
  }

  Future<void> loadMockData() async {
    final mockData = MockService.generateMockData();
    // clear all
    for (var tx in state) {
      await _repository.deleteTransaction(tx.id);
    }
    for (var tx in mockData) {
      await _repository.addTransaction(tx);
    }
    state = _repository.getAllTransactions();
  }
}
