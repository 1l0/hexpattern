import 'dart:ui';

import 'package:flutter/material.dart';

const hex2normal = 0.00392156862745;
const hex2hue = 1.411764705882352;

class HexToColors {
  static List<Color> pubkeyToAHSL(String pubkey, bool dark) {
    if (pubkey.length != 64) {
      throw Exception('pubkey length must be 64: ${pubkey.length}');
    }
    final colors = List<Color>.generate(8, (i) {
      final a = int.parse(pubkey.substring(i * 8 + 0, i * 8 + 2), radix: 16)
              .toDouble() *
          hex2normal;
      final h = int.parse(pubkey.substring(i * 8 + 2, i * 8 + 4), radix: 16)
              .toDouble() *
          hex2hue;
      final s = int.parse(pubkey.substring(i * 8 + 4, i * 8 + 6), radix: 16)
              .toDouble() *
          hex2normal;
      final l = int.parse(pubkey.substring(i * 8 + 6, i * 8 + 8), radix: 16)
              .toDouble() *
          hex2normal;
      if (dark) return HSLColor.fromAHSL(a, h, s, l).toColor();
      return HSLColor.fromAHSL(a, h, s, 1.0 - l).toColor();
    }, growable: false);

    return colors;
  }

  static List<Color> pubkeyToARGB(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('pubkey length must be 64: ${pubkey.length}');
    }
    final colors = List.generate(8, (i) {
      final argb = pubkey.substring(i * 8, i * 8 + 8);
      return Color(int.parse(argb, radix: 16));
    }, growable: false);

    return colors;
  }

  static List<Color> pubkeyToColors(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('pubkey length must be 64: ${pubkey.length}');
    }
    // List<Color> colors = [];

    // final s = pubkey.substring(0, 2);
    // colors.add(Color(int.parse('FF$s$s$s', radix: 16)));

    // for (int i = 2; i < 62; i = i + 6) {
    //   final rgb = pubkey.substring(i, i + 6);
    //   colors.add(Color(int.parse('FF$rgb', radix: 16)));
    // }

    // final c = pubkey.substring(62, 64);
    // colors.add(Color(int.parse('FF$c$c$c', radix: 16)));

    // for (int i = 0; i < 60; i = i + 6) {
    //   final rgb = pubkey.substring(i, i + 6);
    //   colors.add(Color(int.parse('FF$rgb', radix: 16)));
    // }
    final colors = List.generate(10, (i) {
      final rgb = pubkey.substring(i * 6, i * 6 + 6);
      return Color(int.parse('FF$rgb', radix: 16));
    }, growable: false);

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
