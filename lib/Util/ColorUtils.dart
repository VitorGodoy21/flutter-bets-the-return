import 'package:flutter/material.dart';

extension ColorUtilsExtension on Color {
  Color profitColor(double profit) {
    if (profit > 0) {
      return Colors.green;
    } else if (profit < 0) {
      return Colors.red;
    }
    return Colors.yellow;
  }
}

class ColorUtils {
  static Color profitColor(double profit) {
    if (profit > 0) {
      return Colors.green;
    } else if (profit < 0) {
      return Colors.red;
    }
    return Colors.yellow;
  }
}
