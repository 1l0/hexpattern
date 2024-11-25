import 'package:flutter/material.dart';

import 'converter.dart';

class PatternPainter extends CustomPainter {
  const PatternPainter({
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
  bool shouldRepaint(covariant PatternPainter oldDelegate) => false;
}

class HexPattern extends StatelessWidget {
  const HexPattern({
    super.key,
    required this.hexKey,
    this.height = 10,
    this.widthFactor = 2.0,
    this.paddingFactor = 0.0,
    this.centerPaddingFactor = 0.0,
    this.color,
    this.edgeLetterLength = 0,
    this.punch = false,
  });

  final String hexKey;
  final double height;
  final double widthFactor;
  final double paddingFactor;
  final double centerPaddingFactor;
  final Color? color;
  final int edgeLetterLength;
  final bool punch;

  @override
  Widget build(BuildContext context) {
    late final Pattern pattern;
    pattern = HexConverter.hexToPattern(hexKey);
    final width = height * widthFactor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          hexKey.substring(0, edgeLetterLength),
          maxLines: 1,
          style: TextStyle(
            fontSize: height,
            color: color ?? pattern.color,
          ),
        ),
        CustomPaint(
          size: Size(width, height),
          painter: PatternPainter(
            data: pattern.data,
            color: color ?? pattern.color,
            padding: paddingFactor,
            centerPadding: centerPaddingFactor,
          ),
        ),
        Text(
          hexKey.substring(hexKey.length - edgeLetterLength, hexKey.length),
          maxLines: 1,
          style: TextStyle(
            fontSize: height,
            color: color ?? pattern.color,
          ),
        ),
      ],
    );
  }
}
