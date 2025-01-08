import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:flutter/material.dart';
import 'package:hexpattern/hexpattern.dart';

void main() {
  EightFloats.main();
  ThirtyTwoInts.main();
  exit(0);
}

const pubkey =
    '3c7d12a6c2f71fe9ca2527216f529a137bb0f2eb018b18f30003933b9532013e';

class EightFloats extends BenchmarkBase {
  const EightFloats() : super('8 floats');
  static void main() {
    const EightFloats().report();
  }

  @override
  void setup() {}

  @override
  void run() {
    HexConverter.hexToColor(pubkey);
  }

  @override
  void teardown() {}
}

class ThirtyTwoInts extends BenchmarkBase {
  const ThirtyTwoInts() : super('32 ints');
  static void main() {
    const ThirtyTwoInts().report();
  }

  @override
  void setup() {}

  @override
  void run() {
    HexBenchConverter.hexToColor(pubkey);
  }

  @override
  void teardown() {}
}

// TODO
class HexBenchConverter {
  static Color hexToColor(String hexKey) {
    if (hexKey.length != 64) {
      throw Exception('key length must be 64: ${hexKey.length}');
    }

    const double force = 1000.0;

    const double bit16Max = 4295032831.0;
    double h = 0;
    double s = 0;

    for (int i = 0; i < 32; i++) {
      /// 16-bit int
      final v = int.parse(hexKey.substring(i * 2, i * 2 + 2), radix: 16);

      /// normalized v * force
      final p = v / bit16Max * force;

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
