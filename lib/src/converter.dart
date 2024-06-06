import 'dart:ui';

import 'package:flutter/material.dart';

const hex2hue = 1.411764705882353;

class HexToColors {
  static List<Color> pubkeyToColors(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('pubkey length must be 64: ${pubkey.length}');
    }
    List<Color> colors = [];

    final s = pubkey.substring(0, 2);
    colors.add(Color(int.parse('FF$s$s$s', radix: 16)));

    for (int i = 2; i < 62; i = i + 6) {
      final rgb = pubkey.substring(i, i + 6);
      colors.add(Color(int.parse('FF$rgb', radix: 16)));
    }

    final c = pubkey.substring(62, 64);
    colors.add(Color(int.parse('FF$c$c$c', radix: 16)));

    return colors;
  }

  static List<Color> pubkeyToMonochrome(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('pubkey length must be 64: ${pubkey.length}');
    }
    List<Color> colors = [];

    for (int i = 0; i < 64; i = i + 2) {
      final mono = pubkey.substring(i, i + 2);
      colors.add(Color(int.parse('FF$mono$mono$mono', radix: 16)));
    }

    return colors;
  }

  static List<Color> pubkeyToLeadColor(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('pubkey length must be 64: ${pubkey.length}');
    }
    List<Color> colors = [];

    final lead = pubkey.substring(0, 6);
    colors.add(Color(int.parse('FF$lead', radix: 16)));

    for (int i = 6; i < 58; i = i + 2) {
      final mono = pubkey.substring(i, i + 2);
      colors.add(Color(int.parse('FF$mono$mono$mono', radix: 16)));
    }

    final tail = pubkey.substring(58, 64);
    colors.add(Color(int.parse('FF$tail', radix: 16)));

    return colors;
  }
}
