import 'package:flutter/material.dart';

class HexConverter {
  static Pattern hexToPattern(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    const double max = 0xFFFFFFFF + 0.0;
    int h = 0;
    int s = 0;
    final List<double> data = [];

    for (int i = 0; i < 8; i++) {
      final v = int.parse(hexKey.substring(i * 8, i * 8 + 8), radix: 16);

      /// add a normal to the data
      data.add(v.toDouble() / max);

      if (i.isEven) {
        h ^= v;
      } else {
        s ^= v;
      }
    }
    final hue = h.toDouble() % 360.0;
    final sat = s.toDouble() % 100.0 * 0.01;
    final color = HSLColor.fromAHSL(1.0, hue, sat, 0.5).toColor();

    return Pattern(data: data, color: color);
  }

  static Color hexToColor(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }
    int h = 0;
    int s = 0;
    for (int i = 0; i < 8; i++) {
      final v = int.parse(hexKey.substring(i * 8, i * 8 + 8), radix: 16);
      if (i.isEven) {
        h ^= v;
      } else {
        s ^= v;
      }
    }
    final hue = h.toDouble() % 360.0;
    final sat = s.toDouble() % 100.0 * 0.01;
    final color = HSLColor.fromAHSL(1.0, hue, sat, 0.5).toColor();
    return color;
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
