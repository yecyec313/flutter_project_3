import 'package:intl/intl.dart';

// ignore: camel_case_extensions
extension priceLabel on int {
  String get withPriceLabel => this > 0 ? '$jodaBcomma تومان' : "رایگان";
  String get jodaBcomma {
    final number = NumberFormat.decimalPattern();
    return number.format(this);
  }
}
