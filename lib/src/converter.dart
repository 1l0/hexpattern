import 'package:flutter/material.dart';

const hexTonormal = 0.00392156862745;
const hexTohue = 1.411764705882352;
const maxHex4Int = 4294967295;
const maxHex3Int = 16777215;
const maxHex2Int = 65535;
const hex2IntToHue = 0.005493247882811;
const hex4IntToHue = 0.000000083819032;
const hex2IntToSat = 0.000015259021897;

class NostrKeyConverter {
  static Color hexToLeadingColor(String hex) {
    final c = hex.substring(0, 6);
    return Color(int.parse('FF$c', radix: 16));
  }

  static List<Color> hexTomono(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('key length must be 64: ${pubkey.length}');
    }
    final colors = List.generate(32, (i) {
      final c = pubkey.substring(i * 2, i * 2 + 2);
      return Color(int.parse('FF$c$c$c', radix: 16));
    }, growable: false);

    return colors;
  }

  static List<Color?> hexToPattern(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('key length must be 64: ${pubkey.length}');
    }

    final hues = List<double>.generate(4, (i) {
      final c1 = int.parse(pubkey.substring(i * 16 + 0, i * 16 + 8), radix: 16);
      final c2 =
          int.parse(pubkey.substring(i * 16 + 8, i * 16 + 16), radix: 16);
      return ((c1 + c2) % maxHex4Int).toDouble() * hex4IntToHue;
    }, growable: false);

    final pattern = List<Color?>.generate(34, (i) {
      switch (i) {
        case 32:
          return HSLColor.fromAHSL(1.0, hues[0], 1.0, 0.5).toColor();
        case 33:
          return HSLColor.fromAHSL(1.0, hues[3], 1.0, 0.5).toColor();
      }
      final v = int.parse(pubkey.substring(i, i + 2), radix: 16);
      if (v <= 128) {
        return null;
      }
      switch (i) {
        case < 8:
          return HSLColor.fromAHSL(1.0, hues[0], 1.0, 0.5).toColor();
        case < 16:
          return HSLColor.fromAHSL(1.0, hues[1], 1.0, 0.5).toColor();
        case < 24:
          return HSLColor.fromAHSL(1.0, hues[2], 1.0, 0.5).toColor();
      }
      return HSLColor.fromAHSL(1.0, hues[3], 1.0, 0.5).toColor();
    }, growable: false);

    return pattern;
  }

  static WaveForm hexToWaveform(String pubkey, bool dark) {
    if (pubkey.length != 64) {
      throw Exception('key length must be 64: ${pubkey.length}');
    }

    final c1 = int.parse(pubkey.substring(0, 8), radix: 16);
    final c2 = int.parse(pubkey.substring(8, 16), radix: 16);
    final c3 = int.parse(pubkey.substring(16, 24), radix: 16);
    final c4 = int.parse(pubkey.substring(24, 32), radix: 16);
    final c5 = int.parse(pubkey.substring(32, 40), radix: 16);
    final c6 = int.parse(pubkey.substring(40, 48), radix: 16);
    final c7 = int.parse(pubkey.substring(48, 56), radix: 16);
    final c8 = int.parse(pubkey.substring(56, 64), radix: 16);
    final hue = ((c1 + c2 + c3 + c4) % maxHex2Int).toDouble() * hex2IntToHue;
    final sat = ((c5 + c6 + c7 + c8) % maxHex2Int).toDouble() * hex2IntToSat;
    final color = HSLColor.fromAHSL(1.0, hue, sat, 0.5).toColor();

    final data = List<double>.generate(32, (i) {
      final target = pubkey.substring(i * 2, i * 2 + 2);
      final v = int.parse(target, radix: 16).toDouble();
      return (v / 128.0) - 1.0;
    }, growable: false);

    return WaveForm(data: data, color: color);
  }

  static List<Color> hexToHS(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('key length must be 64: ${pubkey.length}');
    }
    final colors = List<Color>.generate(16, (i) {
      final h = int.parse(pubkey.substring(i * 4 + 0, i * 4 + 2), radix: 16)
              .toDouble() *
          hexTohue;
      final s = int.parse(pubkey.substring(i * 4 + 2, i * 4 + 4), radix: 16)
              .toDouble() *
          hexTonormal;
      return HSLColor.fromAHSL(1.0, h, s, 0.5).toColor();
    }, growable: false);

    return colors;
  }

  static List<Color> hexToAHSL(String pubkey, bool dark) {
    if (pubkey.length != 64) {
      throw Exception('key length must be 64: ${pubkey.length}');
    }
    final colors = List<Color>.generate(8, (i) {
      final a = int.parse(pubkey.substring(i * 8 + 0, i * 8 + 2), radix: 16)
              .toDouble() *
          hexTonormal;
      final h = int.parse(pubkey.substring(i * 8 + 2, i * 8 + 4), radix: 16)
              .toDouble() *
          hexTohue;
      final s = int.parse(pubkey.substring(i * 8 + 4, i * 8 + 6), radix: 16)
              .toDouble() *
          hexTonormal;
      final l = int.parse(pubkey.substring(i * 8 + 6, i * 8 + 8), radix: 16)
              .toDouble() *
          hexTonormal;
      if (dark) return HSLColor.fromAHSL(a, h, s, l).toColor();
      return HSLColor.fromAHSL(a, h, s, 1.0 - l).toColor();
    }, growable: false);

    return colors;
  }
}

class WaveForm {
  const WaveForm({
    required this.data,
    required this.color,
  });
  final List<double> data;
  final Color color;
}
