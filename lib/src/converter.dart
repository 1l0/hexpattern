import 'package:flutter/material.dart';

class HexConverter {
  static Pattern hexToPattern(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    const double force = 1000.0;

    const double max = 4294967295.0;
    double h = 0;
    double s = 0;

    final List<double> data = [];
    for (int i = 0; i < 8; i++) {
      final v = int.parse(hexKey.substring(i * 8, i * 8 + 8), radix: 16);

      /// normalized v
      final p = v / max;

      data.add(p);

      if (i.isEven) {
        h += p * force;
      } else {
        s += p * force;
      }
    }
    final hue = (h * h) % 1.0 * 360.0;
    final sat = (s * s) % 1.0;
    final color = HSLColor.fromAHSL(1.0, hue, sat, 0.5).toColor();

    return Pattern(data: data, color: color);
  }

  static Color hexToColor(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    const double force = 1000.0;

    const double max = 4294967295.0;
    double h = 0;
    double s = 0;

    for (int i = 0; i < 8; i++) {
      final v = int.parse(hexKey.substring(i * 8, i * 8 + 8), radix: 16);

      /// normalized v * force
      final p = v / max * force;

      if (i.isEven) {
        h += p;
      } else {
        s += p;
      }
    }

    final hue = (h * h) % 1.0 * 360.0;
    final sat = (s * s) % 1.0;
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
