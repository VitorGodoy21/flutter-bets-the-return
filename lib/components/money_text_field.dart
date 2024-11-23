import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bets_the_return/Util/double_utils.dart';

class MoneyTextField extends StatefulWidget {
  double value;

  MoneyTextField({required this.value, super.key});

  @override
  State<MoneyTextField> createState() => _MoneyTextFieldState();
}

class _MoneyTextFieldState extends State<MoneyTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller.text = widget.value.toBRL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number, // Aceita apenas números
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Aceita apenas dígitos
          MoneyInputFormatter(),
        ],
        decoration: InputDecoration(
          labelText: 'Digite o valor',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

// Custom TextInputFormatter para formatação de dinheiro
class MoneyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    String cleaned = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (cleaned.isEmpty) {
      return const TextEditingValue();
    }

    String formatted;
    if (cleaned.length == 1) {
      formatted = '0,0$cleaned';
    } else if (cleaned.length == 2) {
      formatted = '0,$cleaned';
    } else {
      String wholePart = cleaned.substring(0, cleaned.length - 2);
      String decimalPart = cleaned.substring(cleaned.length - 2);

      wholePart = wholePart.isNotEmpty ? wholePart : '0';

      formatted = '$wholePart,$decimalPart';
      while (formatted.startsWith("0") && formatted.length > 4) {
        formatted = formatted.substring(1);
      }
    }

    formatted = 'R\$ $formatted';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
