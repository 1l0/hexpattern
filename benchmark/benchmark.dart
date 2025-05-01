import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter/material.dart';
import 'package:hexpattern/hexpattern.dart';

void main() {
  PrefixOnly.main();
  CurrentSpec.main();
  Optimized.main();
  OptimizedSmall.main();
}

const pubkey =
    '3c7d12a6c2f71fe9ca2527216f529a137bb0f2eb018b18f30003933b9532013e';

class CurrentSpec extends BenchmarkBase {
  const CurrentSpec() : super('current spec');
  static void main() {
    const CurrentSpec().report();
  }

  @override
  void run() {
    final _ = HexConverter.hexToColor(pubkey);
  }
}

class PrefixOnly extends BenchmarkBase {
  const PrefixOnly() : super('prefix only');
  static void main() {
    const PrefixOnly().report();
  }

  @override
  void run() {
    final _ = BenchHexConverter.prefixOnly(pubkey);
  }
}

class Optimized extends BenchmarkBase {
  const Optimized() : super('optimized');
  static void main() {
    const Optimized().report();
  }

  @override
  void run() {
    final _ = BenchHexConverter.optimized(pubkey);
  }
}

class OptimizedSmall extends BenchmarkBase {
  const OptimizedSmall() : super('optimized small chunks');
  static void main() {
    const OptimizedSmall().report();
  }

  @override
  void run() {
    final _ = BenchHexConverter.optimizedSmallChunks(pubkey);
  }
}

class BenchHexConverter {
  static Color prefixOnly(String hexKey) {
    final rgb = int.parse(hexKey.substring(0, 6), radix: 16);
    return Color(rgb | 0xFF000000);
  }

  static Color optimized(String hexKey) {
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

  static Color optimizedSmallChunks(String hexKey) {
    final h1 = int.parse(hexKey.substring(0, 4), radix: 16);
    final s1 = int.parse(hexKey.substring(4, 8), radix: 16);
    final h2 = int.parse(hexKey.substring(8, 12), radix: 16);
    final s2 = int.parse(hexKey.substring(12, 16), radix: 16);
    final h3 = int.parse(hexKey.substring(16, 20), radix: 16);
    final s3 = int.parse(hexKey.substring(20, 24), radix: 16);
    final h4 = int.parse(hexKey.substring(24, 28), radix: 16);
    final s4 = int.parse(hexKey.substring(28, 32), radix: 16);
    final h5 = int.parse(hexKey.substring(32, 36), radix: 16);
    final s5 = int.parse(hexKey.substring(36, 40), radix: 16);
    final h6 = int.parse(hexKey.substring(40, 44), radix: 16);
    final s6 = int.parse(hexKey.substring(44, 48), radix: 16);
    final h7 = int.parse(hexKey.substring(48, 52), radix: 16);
    final s7 = int.parse(hexKey.substring(52, 56), radix: 16);
    final h8 = int.parse(hexKey.substring(56, 60), radix: 16);
    final s8 = int.parse(hexKey.substring(60, 64), radix: 16);
    int h = h1 ^ h2 ^ h3 ^ h4 ^ h5 ^ h6 ^ h7 ^ h8;
    int s = s1 ^ s2 ^ s3 ^ s4 ^ s5 ^ s6 ^ s7 ^ s8;
    final hue = h.toDouble() % 360.0;
    final rawSat = s.toDouble() % 100.0 * 0.01;
    final sat = sin(pi * (rawSat * 0.5));
    final color = HSLColor.fromAHSL(1.0, hue, sat, 0.5).toColor();
    return color;
  }
}
