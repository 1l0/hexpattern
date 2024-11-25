import 'package:flutter/material.dart';

class HexConverter {
  static Pattern hexToPattern(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    final List<double> data = [];
    for (int i = 0; i < 8; i++) {
      final v = int.parse(hexKey.substring(i * 8, i * 8 + 8), radix: 16);
      final p = v / 4295032831.0;
      data.add(p);
    }
    final col = (data.length / 2).round();
    final hue = data.sublist(0, col).reduce((v, e) => v + e) % 1.0 * 360.0;
    final sat = data.sublist(col, data.length).reduce((v, e) => v + e) % 1.0;
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
