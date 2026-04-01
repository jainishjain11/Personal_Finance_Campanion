import 'package:intl/intl.dart';

class Formatters {
  static String currency(double amount) {
    final format = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return format.format(amount);
  }

  static String date(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat('EEEE, MMM d').format(date);
  }

  static String shortDate(DateTime date) {
    return DateFormat('MM/dd').format(date);
  }

  static String time(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }
}
