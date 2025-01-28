import 'package:flutter/material.dart';

class HexConverter {
  static Pattern hexToPattern(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    const double max = 0xFFFFFFFF + 0.0;
    double h = 0.0;
    double s = 0.0;

    final List<double> data = [];
    for (int i = 0; i < 8; i++) {
      final v = int.parse(hexKey.substring(i * 8, i * 8 + 8), radix: 16);

      final p = v.toDouble();

      /// normalized p
      data.add(p / max);

      if (i.isEven) {
        h = ((h + 1.0) * (p + 1.0)) % 360.0;
      } else {
        s = ((s + 1.0) * (p + 1.0)) % 100.0;
      }
    }
    final hue = h;
    final sat = s / 100.0;
    final color = HSLColor.fromAHSL(1.0, hue, sat, 0.5).toColor();

    return Pattern(data: data, color: color);
  }
}

class Pattern {
  const Pattern({
    required this.data,
    required this.color,
  });
  final List<double> data;
  final Color color;
}
