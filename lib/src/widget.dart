import 'package:flutter/material.dart';

import 'converter.dart';

class RoundRect extends CustomPainter {
  const RoundRect({
    required this.strokeColor,
    required this.fillColor,
  });

  final Color strokeColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.height * 0.15;
    final paint = Paint()
      ..isAntiAlias = true
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromLTRBR(
      0 + (strokeWidth * 0.5),
      0 + (strokeWidth * 0.5),
      size.width - (strokeWidth * 0.5),
      size.height - (strokeWidth * 0.5),
      Radius.circular(size.height * 0.5),
    );
    canvas.drawRRect(rrect, paint);
    paint.color = fillColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant RoundRect oldDelegate) => false;
}

class Pubkey2LeadingColor extends StatelessWidget {
  const Pubkey2LeadingColor({
    super.key,
    required this.pubkeyHex,
    this.height = 10,
    this.color,
    this.edgeLetterLength = 2,
  });

  final String pubkeyHex;
  final double height;
  final Color? color;
  final int edgeLetterLength;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final col = HexToColors.hexToLeadingColor(pubkeyHex);

    return Row(
      children: [
        CustomPaint(
          // size: Size(height * 3.2, height),
          size: Size(height * 2, height),
          painter: RoundRect(
            strokeColor: color ?? colorScheme.onSurfaceVariant,
            fillColor: col,
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

class WaveformPainter extends CustomPainter {
  const WaveformPainter({
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
    // } else {
    //   const row = 4;
    //   const col = 8;
    //   const pad = 0.0;
    //   final qx = size.width / col;
    //   final qy = size.height / row;
    //   final padx = qx * pad;
    //   final pady = qy * pad;

    //   final paint = Paint()
    //     ..isAntiAlias = false
    //     ..color = color
    //     ..style = PaintingStyle.fill;

    //   for (int yi = 0; yi < row; yi++) {
    //     for (int xi = 0; xi < col; xi++) {
    //       final rect = Rect.fromLTRB(
    //         qx * xi + padx,
    //         qy * yi + pady,
    //         qx * xi + qx - padx,
    //         qy * yi + qy - pady,
    //       );
    //       final norm = data[(yi * col) + xi] * 0.5 + 0.5;
    //       final c = Color.fromARGB(
    //         255,
    //         (255 * norm).toInt(),
    //         (255 * norm).toInt(),
    //         (255 * norm).toInt(),
    //       );
    //       paint.color = c;
    //       canvas.drawRect(rect, paint);
    //     }
    //   }
    // }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) => false;
}

class Pubkey2Waveform extends StatelessWidget {
  const Pubkey2Waveform({
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
    final waveform = HexToColors.pubkeyToWaveform(pubkeyHex, dark);

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
          painter: WaveformPainter(
            data: waveform.data,
            color: waveform.color,
            punch: punch,
          ),
        ),
        Text(
          pubkeyHex.substring(
              pubkeyHex.length - edgeLetterLength, pubkeyHex.length),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

@Deprecated('use Pubkey2Waveform')
class Pubkey2Colors extends StatelessWidget {
  const Pubkey2Colors({
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
    final colors = HexToColors.pubkeyToMonochrome(pubkeyHex);

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

@Deprecated('use Pubkey2Waveform')
class Pubkey2Identicon extends StatelessWidget {
  const Pubkey2Identicon({
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
    final colors = HexToColors.pubkeyToPattern(pubkeyHex);

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
