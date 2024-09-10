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

  static List<Color> pubkeyToMonochrome(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('pubkey length must be 64: ${pubkey.length}');
    }
    final colors = List.generate(32, (i) {
      final c = pubkey.substring(i * 2, i * 2 + 2);
      return Color(int.parse('FF$c$c$c', radix: 16));
    }, growable: false);

    return colors;
  }
}
