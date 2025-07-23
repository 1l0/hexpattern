import 'package:flutter/material.dart';
import 'dart:math';

class HexConverter {
  static Pattern hexToPattern(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    final start = Color(int.parse('FF${hexKey.substring(0, 6)}', radix: 16));
    final end = Color(int.parse('FF${hexKey.substring(58, 64)}', radix: 16));

    const double max = 0xFFFFFFFF + 0.0;
    final List<double> data = [];

    for (int i = 0; i < 8; i++) {
      final v = int.parse(hexKey.substring(i * 8, i * 8 + 8), radix: 16);

      /// add a normal to the data
      data.add(v.toDouble() / max);
    }
    return Pattern(data: data, start: start, end: end);
  }

  @Deprecated('use hexToPattern')
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
    final rawSat = s.toDouble() % 100.0 * 0.01;
    final sat = sin(pi * (rawSat * 0.5));
    final color = HSLColor.fromAHSL(1.0, hue, sat, 0.5).toColor();
    return color;
  }

  @Deprecated('use hexToPattern')
  static Color hexToColorOptimized(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }
    final h1 = int.parse(hexKey.substring(0, 8), radix: 16);
    final s1 = int.parse(hexKey.substring(8, 16), radix: 16);
    final h2 = int.parse(hexKey.substring(16, 24), radix: 16);
    final s2 = int.parse(hexKey.substring(24, 32), radix: 16);
    final h3 = int.parse(hexKey.substring(32, 40), radix: 16);
    final s3 = int.parse(hexKey.substring(40, 48), radix: 16);
    final h4 = int.parse(hexKey.substring(48, 56), radix: 16);
    final s4 = int.parse(hexKey.substring(56, 64), radix: 16);
    int h = h1 ^ h2 ^ h3 ^ h4;
    int s = s1 ^ s2 ^ s3 ^ s4;
    final hue = h.toDouble() % 360.0;
    final rawSat = s.toDouble() % 100.0 * 0.01;
    final sat = sin(pi * (rawSat * 0.5));
    final color = HSLColor.fromAHSL(1.0, hue, sat, 0.5).toColor();
    return color;
  }
}

class Pattern {
  const Pattern({
    required this.data,
    required this.start,
    required this.end,
  });
  final List<double> data;
  final Color start;
  final Color end;
}
