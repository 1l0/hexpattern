import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'converter.dart';

class OctagonPainter extends CustomPainter {
  const OctagonPainter({
    required this.data,
    required this.start,
    required this.end,
  }) : assert(data.length >= 2);

  final List<double> data;
  final Color start;
  final Color end;

  // TODO: use canvas.drawVertices? maybe not
  @override
  void paint(Canvas canvas, Size size) {
    final seg = (2.0 / data.length) * math.pi;
    final segHalf = seg * 0.5;
    final distance = size.height * 0.5;
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      // ..color = color
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [start, end],
      );
    final center = Offset(size.width / 2, size.height / 2);
    final zero =
        center + Offset.fromDirection(segHalf, distance * data.elementAt(0));

    Path path = Path();
    path.moveTo(zero.dx, zero.dy);
    for (int i = 1; i < data.length; i++) {
      final offset = center +
          Offset.fromDirection(seg * i + segHalf, distance * data.elementAt(i));
      path.lineTo(offset.dx, offset.dy);
    }
    path.lineTo(zero.dx, zero.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant OctagonPainter oldDelegate) => false;
}

@Deprecated('use OctagonPainter')
class PatternPainter extends CustomPainter {
  const PatternPainter({
    required this.data,
    this.padding = 0.0,
    this.centerPadding = 0.0,
    required this.start,
    required this.end,
  }) : assert(data.length >= 2);

  final List<double> data;
  final double padding;
  final double centerPadding;
  final Color start;
  final Color end;

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
      ..shader = ui.Gradient.linear(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        [start, end],
      );

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
    this.widthFactor = 1.0,
    this.start,
    this.end,
    @Deprecated('will be removed') this.paddingFactor = 0.0,
    @Deprecated('will be removed') this.centerPaddingFactor = 0.0,
    @Deprecated('will be removed') this.edgeLetterLength = 0,
  });

  final String hexKey;
  final double height;
  final double widthFactor;
  final Color? start;
  final Color? end;

  @Deprecated('will be removed')
  final double paddingFactor;
  @Deprecated('will be removed')
  final double centerPaddingFactor;
  @Deprecated('will be removed')
  final int edgeLetterLength;

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
            color: start ?? pattern.start,
          ),
        ),
        CustomPaint(
          size: Size(width, height),
          painter: OctagonPainter(
            data: pattern.data,
            start: start ?? pattern.start,
            end: end ?? pattern.end,
          ),
        ),
        Text(
          hexKey.substring(hexKey.length - edgeLetterLength, hexKey.length),
          maxLines: 1,
          style: TextStyle(
            fontSize: height,
            color: end ?? pattern.end,
          ),
        ),
      ],
    );
  }
}
