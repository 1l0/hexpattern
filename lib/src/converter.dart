import 'package:flutter/material.dart';

class HexConverter {
  static Pattern hexToPattern(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    final start = Color(int.parse('FF${hexKey.substring(0, 6)}', radix: 16));
    final end = Color(int.parse('FF${hexKey.substring(58, 64)}', radix: 16));

    const double max = 0xFFFF + 0.0;
    final List<double> data = [];

    for (int i = 0; i < 16; i++) {
      final v = int.parse(hexKey.substring(i * 4, i * 4 + 4), radix: 16);

      /// add a normal to the data
      data.add(v.toDouble() / max);
    }
    return Pattern(data: data, start: start, end: end);
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
