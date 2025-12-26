import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'converter.dart';

class OscilloscopePainter extends CustomPainter {
  const OscilloscopePainter({
    required this.data,
    required this.start,
    required this.end,
    required this.strokeWeight,
  }) : assert(data.length >= 2);

  final List<double> data;
  final Color start;
  final Color end;
  final double strokeWeight;

  @override
  void paint(Canvas canvas, Size size) {
    final sep = (data.length / 2).round();
    final rawScale = math.min(size.width, size.height);
    final strokeWidth = rawScale / sep * strokeWeight;
    final scale = rawScale - strokeWidth * 2;
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter
      ..strokeMiterLimit = 10.0
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [start, end],
      );
    final epoch = Offset(
      data.elementAt(0) * scale + strokeWidth,
      data.elementAt(sep) * scale + strokeWidth,
    );
    Path path = Path();
    path.moveTo(epoch.dx, epoch.dy);
    for (int i = 1; i < sep; i++) {
      final offset = Offset(
        data.elementAt(i) * scale + strokeWidth,
        data.elementAt(i + sep) * scale + strokeWidth,
      );
      path.lineTo(offset.dx, offset.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant OscilloscopePainter oldDelegate) => false;
}

class HexPattern extends StatelessWidget {
  const HexPattern({
    super.key,
    required this.hexKey,
    this.height = 10,
    this.widthFactor = 1.0,
    this.strokeWeight = 0.1,
    this.start,
    this.end,
  });

  final String hexKey;
  final double height;
  final double widthFactor;
  final double strokeWeight;
  final Color? start;
  final Color? end;

  @override
  Widget build(BuildContext context) {
    late final Pattern pattern;
    pattern = HexConverter.hexToPattern(hexKey);
    final width = height * widthFactor;

    return CustomPaint(
      size: Size(width, height),
      painter: OscilloscopePainter(
        data: pattern.data,
        start: start ?? pattern.start,
        end: end ?? pattern.end,
        strokeWeight: strokeWeight,
      ),
    );
  }
}
