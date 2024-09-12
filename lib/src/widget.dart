import 'package:flutter/material.dart';

import 'converter.dart';

class Waveform extends CustomPainter {
  const Waveform({
    required this.data,
    required this.color,
  });

  final List<double> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      return;
    }
    final paint = Paint()
      ..isAntiAlias = false
      ..color = color
      ..style = PaintingStyle.fill;

    final q = size.width / data.length;
    final baseline = size.height * 0.5;
    for (int i = 0; i < data.length; i++) {
      final rect = Rect.fromLTRB(
        q * i,
        baseline,
        q * i + q,
        -baseline * data[i] + baseline,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant Waveform oldDelegate) => false;
}

class Pubkey2Waveform extends StatelessWidget {
  const Pubkey2Waveform({
    super.key,
    required this.pubkeyHex,
    this.height = 10,
    this.color,
    this.edgeLetterLength = 1,
  });

  final String pubkeyHex;
  final double height;
  final Color? color;
  final int edgeLetterLength;

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
          size: Size(height * 3.2, height),
          painter: Waveform(
            data: waveform,
            color: color ?? colorScheme.onSurfaceVariant,
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
class Pubkey2WaveformLowPerf extends StatelessWidget {
  const Pubkey2WaveformLowPerf({
    super.key,
    required this.pubkeyHex,
    this.height = 5,
    this.edgeLettersColor,
    this.edgeLetterLength = 1,
  });

  final String pubkeyHex;
  final double height;
  final Color? edgeLettersColor;
  final int edgeLetterLength;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dark = colorScheme.brightness == Brightness.dark;
    final waveform = HexToColors.pubkeyToWaveform(pubkeyHex, dark);

    const boxWidth = 0.1;
    const boxHeight = 0.5;

    final posi = waveform
        .map((v) => v > 0
            ? ColoredBox(
                color: colorScheme.onSurfaceVariant,
                child: SizedBox(
                  width: height * boxWidth,
                  height: height * boxHeight * v.abs(),
                ),
              )
            : SizedBox(
                width: height * boxWidth,
              ))
        .toList(growable: false);

    final nega = waveform
        .map((v) => v < 0
            ? ColoredBox(
                color: colorScheme.onSurfaceVariant,
                child: SizedBox(
                  width: height * boxWidth,
                  height: height * boxHeight * v.abs(),
                ),
              )
            : SizedBox(
                width: height * boxWidth,
              ))
        .toList(growable: false);

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
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: posi,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: nega,
            ),
          ],
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
