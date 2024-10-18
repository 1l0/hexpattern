import 'package:flutter/material.dart';

const hexTonormal = 0.00392156862745;
const hexTohue = 1.411764705882352;
const maxInt32 = 4294967295;
const maxHex3Int = 16777215;
const maxHex2Int = 65535;
const hex2IntToHue = 0.005493247882811;
const max32ToHue = 0.000000083819032;
const hex2IntToSat = 0.000015259021897;

class NostrKeyConverter {
  static Color hexToLeadingColor(String hex) {
    if (hex.length != 64) {
      throw Exception('key length must be 64: ${hex.length}');
    }
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

  static List<Color> hexToEightColors(String hex) {
    if (hex.length != 64) {
      throw Exception('key length must be 64: ${hex.length}');
    }
    return List<Color>.generate(8, (i) {
      final hue1 = int.parse(hex.substring(i * 8 + 0, i * 8 + 8), radix: 16);
      // return ((c1 + c2) % maxInt32).toDouble() * int32ToHue;
      return HSLColor.fromAHSL(1.0, hue1.toDouble() * max32ToHue, 1.0, 0.5)
          .toColor();
    }, growable: false);
  }

  static List<Color?> hexToPattern(String pubkey) {
    if (pubkey.length != 64) {
      throw Exception('key length must be 64: ${pubkey.length}');
    }

    final hues = List<double>.generate(4, (i) {
      final c1 = int.parse(pubkey.substring(i * 16 + 0, i * 16 + 8), radix: 16);
      final c2 =
          int.parse(pubkey.substring(i * 16 + 8, i * 16 + 16), radix: 16);
      return ((c1 + c2) % maxInt32).toDouble() * max32ToHue;
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

  // Hue only
  static Color hexToColor(String hexKey, bool dark) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    double sum = 0.0;
    for (int i = 0; i < 64; i += 2) {
      final c = hexKey.substring(i, i + 2);
      final hue = int.parse(c, radix: 16) * hexTohue;
      sum += hue;
    }

    final modHue = (sum % 360.0);

    final light = dark ? 0.5 : 0.3333333;

    return HSLColor.fromAHSL(1.0, modHue, 1.0, light).toColor();
  }

  static WaveForm hexToWaveform(String hexKey, bool dark) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    final List<double> data = [];
    double sum = 0.0;
    for (int i = 0; i < 64; i += 2) {
      final c = hexKey.substring(i, i + 2);
      final v = int.parse(c, radix: 16);

      final p = (v / 128.0) - 1.0;
      data.add(p);

      sum += p;
    }
    final hue = (sum.abs() * 360.0) % 360.0;
    final light = dark ? 0.5 : 0.45;
    final col = HSLColor.fromAHSL(1.0, hue, 1.0, light).toColor();

    return WaveForm(data: data, color: col);
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
