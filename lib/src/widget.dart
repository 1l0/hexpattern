import 'package:flutter/material.dart';

import 'converter.dart';

class WaveformPainter extends CustomPainter {
  const WaveformPainter({
    required this.data,
    required this.colors,
    this.padding = 0.25,
    this.centerPadding = 0.0,
    this.punch = false,
  }) : assert(data.length == 32 || data.length == 16);

  final List<double> data;
  final List<int> colors;
  final double padding;
  final double centerPadding;
  final bool punch;

  @override
  void paint(Canvas canvas, Size size) {
    if (punch) {
      const row = 4;
      const col = 8;
      final qx = size.width / col;
      final qxh = qx * 0.5;
      final qy = size.height / row;
      final qyh = qy * 0.5;

      final paint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;

      for (int yi = 0; yi < row; yi++) {
        for (int xi = 0; xi < col; xi++) {
          final w = data[(yi * col) + xi] * 0.5 + 0.5;
          canvas.drawCircle(
            Offset(
              qx * xi + qxh,
              qy * yi + qyh,
            ),
            qxh * w,
            paint..color = Color(colors[(yi * col) + xi]),
          );
        }
      }
      return;
    }
    const row = 2;
    final col = (data.length / 2).round();
    final qx = size.width / col;
    final padx = qx * padding * 0.5;
    final cpad = qx * centerPadding * 0.5;
    final baseline = size.height * 0.5;

    final paint = Paint()
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    for (int yi = 0; yi < row; yi++) {
      for (int xi = 0; xi < col; xi++) {
        final norm = data[(yi * col) + xi] * 0.5 + 0.5;
        if (yi == 0) {
          final rect = Rect.fromLTRB(
            qx * xi + padx,
            baseline - (baseline * norm) - cpad,
            qx * xi + qx - padx,
            baseline - cpad,
          );
          canvas.drawRect(
            rect,
            paint..color = Color(colors[(yi * col) + xi]),
          );
        } else {
          final rect = Rect.fromLTRB(
            qx * xi + padx,
            baseline + cpad,
            qx * xi + qx - padx,
            baseline + (baseline * norm) + cpad,
          );
          canvas.drawRect(
            rect,
            paint..color = Color(colors[(yi * col) + xi]),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) => false;
}

class BarChartPainter extends CustomPainter {
  const BarChartPainter({
    required this.data,
    this.padding = 0.25,
    this.centerPadding = 0.0,
    required this.color,
  }) : assert(data.length >= 2);

  final List<double> data;
  final double padding;
  final double centerPadding;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const row = 2;
    final col = (data.length / 2).round();
    final qx = size.width / col;
    final padx = qx * padding * 0.5;
    final cpad = qx * centerPadding * 0.5;
    final baseline = size.height * 0.5;
    final paint = Paint()
      ..isAntiAlias = false
      ..style = PaintingStyle.fill
      ..color = color;

    for (int yi = 0; yi < row; yi++) {
      for (int xi = 0; xi < col; xi++) {
        final norm = data[(yi * col) + xi];
        if (yi == 0) {
          final rect = Rect.fromLTRB(
            qx * xi + padx,
            baseline - (baseline * norm) - cpad,
            qx * xi + qx - padx,
            baseline - cpad,
          );
          canvas.drawRect(
            rect,
            paint,
          );
        } else {
          final rect = Rect.fromLTRB(
            qx * xi + padx,
            baseline + cpad,
            qx * xi + qx - padx,
            baseline + (baseline * norm) + cpad,
          );
          canvas.drawRect(
            rect,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant BarChartPainter oldDelegate) => false;
}

class NostrKeyAsWaveform extends StatelessWidget {
  const NostrKeyAsWaveform({
    super.key,
    required this.hexKey,
    this.height = 10,
    this.widthFactor = 2.0,
    this.paddingFactor = 0.5,
    this.centerPaddingFactor = 0.0,
    this.color,
    this.edgeLetterLength = 0,
    this.punch = false,
    this.half = true,
  });

  final String hexKey;
  final double height;
  final double widthFactor;
  final double paddingFactor;
  final double centerPaddingFactor;
  final Color? color;
  final int edgeLetterLength;
  final bool punch;
  final bool half;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dark = colorScheme.brightness == Brightness.dark;
    late final Waveform waveform;
    if (half) {
      waveform = NostrKeyConverter.hexToWaveformHalf(hexKey, dark);
    } else {
      waveform = NostrKeyConverter.hexToWaveform(hexKey, dark);
    }
    // final width = half ? height * widthFactor * 0.5 : height * widthFactor;
    final width = height * widthFactor;

    return Row(
      children: [
        Text(
          hexKey.substring(0, edgeLetterLength),
          maxLines: 1,
          style: TextStyle(
            fontSize: height,
            color: color ?? waveform.color,
          ),
        ),
        CustomPaint(
          size: Size(width, height),
          painter: BarChartPainter(
            data: waveform.data,
            color: color ?? waveform.color ?? colorScheme.onSurfaceVariant,
            padding: paddingFactor,
            centerPadding: centerPaddingFactor,
            // punch: punch,
          ),
        ),
        Text(
          hexKey.substring(hexKey.length - edgeLetterLength, hexKey.length),
          maxLines: 1,
          style: TextStyle(
            fontSize: height,
            color: color ?? waveform.color,
          ),
        ),
      ],
    );
  }
}

class NostrKeyAsEightColors extends StatelessWidget {
  const NostrKeyAsEightColors({
    super.key,
    required this.hexKey,
    this.height = 15,
  });

  final String hexKey;
  final double height;

  @override
  Widget build(BuildContext context) {
    // final dark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    // final col = NostrKeyConverter.hexToColor(hexKey, dark);
    final col = NostrKeyConverter.hexToEightColors(hexKey);
    return Row(
      children: [
        for (var i = 0; i < 8; i++)
          Text(
            '|',
            // '∣',
            style: TextStyle(
              color: col[i],
              fontWeight: FontWeight.bold,
              fontSize: height,
            ),
          ),
      ],
    );
  }
}

class NostrKeyAsColor extends StatelessWidget {
  const NostrKeyAsColor({
    super.key,
    required this.hexKey,
    this.height = 15,
  });

  final String hexKey;
  final double height;

  @override
  Widget build(BuildContext context) {
    // final dark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    // final col = NostrKeyConverter.hexToColor(hexKey, dark);
    final col = NostrKeyConverter.hexToLeadingColor(hexKey);
    return Text(
      '/',
      style: TextStyle(
        color: col,
        fontWeight: FontWeight.bold,
        fontSize: height,
      ),
    );
  }
}

@Deprecated('version 1')
class WaveformPainterVer1 extends CustomPainter {
  const WaveformPainterVer1({
    required this.data,
    required this.color,
    this.punch = false,
  });

  final List<double> data;
  final Color color;
  final bool punch;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length != 32) {
      return;
    }
    if (!punch) {
      final q = size.width / data.length;
      final baseline = size.height * 0.5;

      final paint = Paint()
        ..isAntiAlias = false
        ..color = color
        ..style = PaintingStyle.fill;

      for (int i = 0; i < data.length; i++) {
        final rect = Rect.fromLTRB(
          q * i,
          baseline,
          q * i + q,
          -baseline * data[i] + baseline,
        );
        canvas.drawRect(rect, paint);
      }
    } else {
      const row = 4;
      const col = 8;
      final qx = size.width / col;
      final qxh = qx * 0.5;
      final qy = size.height / row;
      final qyh = qy * 0.5;

      final paint = Paint()
        ..isAntiAlias = true
        ..color = color
        ..style = PaintingStyle.fill;

      for (int yi = 0; yi < row; yi++) {
        for (int xi = 0; xi < col; xi++) {
          final w = data[(yi * col) + xi] * 0.5 + 0.5;
          canvas.drawCircle(
            Offset(
              qx * xi + qxh,
              qy * yi + qyh,
            ),
            qxh * w,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainterVer1 oldDelegate) => false;
}

@Deprecated('version 1')
class NostrKeyAsWaveformVer1 extends StatelessWidget {
  const NostrKeyAsWaveformVer1({
    super.key,
    required this.pubkeyHex,
    this.height = 10,
    this.color,
    this.edgeLetterLength = 1,
    this.punch = false,
  });

  final String pubkeyHex;
  final double height;
  final Color? color;
  final int edgeLetterLength;
  final bool punch;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dark = colorScheme.brightness == Brightness.dark;
    final waveform = NostrKeyConverter.hexToWaveform(pubkeyHex, dark);

    return Row(
      children: [
        Text(
          pubkeyHex.substring(0, edgeLetterLength),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        CustomPaint(
          // size: Size(height * 3.2, height),
          size: Size(height * 2, height),
          painter: WaveformPainterVer1(
            data: waveform.data,
            color: color ?? colorScheme.onSurface,
            punch: punch,
          ),
        ),
        Text(
          pubkeyHex.substring(
              pubkeyHex.length - edgeLetterLength, pubkeyHex.length),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: color ?? colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

@Deprecated('deprecated')
class NostrKeyAsColors extends StatelessWidget {
  const NostrKeyAsColors({
    super.key,
    required this.pubkeyHex,
    this.height = 5,
    this.edgeLettersColor,
    this.compress = 0,
    this.edgeLetterLength = 1,
  });

  final String pubkeyHex;
  final double height;
  final Color? edgeLettersColor;
  final double compress;
  final int edgeLetterLength;

  @override
  Widget build(BuildContext context) {
    final colors = NostrKeyConverter.hexTomono(pubkeyHex);

    final series = colors
        .map((c) => ColoredBox(
              color: c,
              child: SizedBox(
                width: height * 0.1 / (compress + 1),
                height: height,
              ),
            ))
        .toList(growable: false);

    return Row(
      children: [
        Text(
          pubkeyHex.substring(0, edgeLetterLength),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: edgeLettersColor ??
                Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        ...series,
        Text(
          pubkeyHex.substring(
              pubkeyHex.length - edgeLetterLength, pubkeyHex.length),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: edgeLettersColor ??
                Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

@Deprecated('deprecated')
class NostrKeyAsIdenticon extends StatelessWidget {
  const NostrKeyAsIdenticon({
    super.key,
    required this.pubkeyHex,
    this.height = 5,
    this.edgeLettersColor,
    this.edgeLetterLength = 1,
    this.compress = 0,
  });

  final String pubkeyHex;
  final double height;
  final Color? edgeLettersColor;
  final double compress;
  final int edgeLetterLength;

  @override
  Widget build(BuildContext context) {
    final colors = NostrKeyConverter.hexToPattern(pubkeyHex);

    final series = colors
        .sublist(0, 32)
        .map((c) => ColoredBox(
              color: c ?? const Color.fromARGB(0, 0, 0, 0),
              child: SizedBox(
                width: height * 0.5 / (compress + 1),
                height: height * 0.5 / (compress + 1),
              ),
            ))
        .toList(growable: false);

    return Row(
      children: [
        Text(
          pubkeyHex.substring(0, 1),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: colors[32],
          ),
        ),
        Column(
          children: series.sublist(0, 8),
        ),
        Column(
          children: series.sublist(8, 16),
        ),
        Column(
          children: series.sublist(16, 24),
        ),
        Column(
          children: series.sublist(24, 32),
        ),
        Text(
          pubkeyHex.substring(pubkeyHex.length - 1, pubkeyHex.length),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: colors[33],
          ),
        ),
      ],
    );
  }
}
