import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'currency_provider.g.dart';

@riverpod
class CurrencyState extends _$CurrencyState {
  late Box _box;

  @override
  String build() {
    _box = Hive.box('settings');
    return _box.get('currency', defaultValue: 'INR') as String;
  }

  void setCurrency(String newCurrency) {
    _box.put('currency', newCurrency);
    state = newCurrency;
  }
}
