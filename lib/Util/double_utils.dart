import 'package:intl/intl.dart';

extension DoubleUtilsExtension on double {
  String toBRL() {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return formatter.format(this);
  }
}
