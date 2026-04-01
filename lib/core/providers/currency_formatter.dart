import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'currency_provider.dart';

part 'currency_formatter.g.dart';

@riverpod
NumberFormat currencyFormatter(CurrencyFormatterRef ref) {
  final currencyCode = ref.watch(currencyStateProvider);
  
  String symbol = '₹';
  switch (currencyCode) {
    case 'USD': symbol = '\$'; break;
    case 'EUR': symbol = '€'; break;
    case 'GBP': symbol = '£'; break;
    case 'INR': symbol = '₹'; break;
  }

  return NumberFormat.currency(symbol: symbol, decimalDigits: 2);
}
