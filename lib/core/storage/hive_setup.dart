import 'package:hive_flutter/hive_flutter.dart';
import '../../features/transactions/models/transaction.dart';

class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) {
       Hive.registerAdapter(TransactionAdapter());
    }
    
    // Open boxes
    await Hive.openBox<Transaction>('transactions');
    await Hive.openBox('settings');
  }
}
