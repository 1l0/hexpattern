import 'package:flutter/material.dart';

import 'converter.dart';

class Pubkey2Waveform extends StatelessWidget {
  const Pubkey2Waveform({
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
    final colorScheme = Theme.of(context).colorScheme;
    final dark = colorScheme.brightness == Brightness.dark;
    final dots = HexToColors.pubkeyToWaveform(pubkeyHex, dark);

    const boxWidth = 0.1;
    const boxHeight = 0.5;

    final plus = dots
        .map((dot) => dot.weight > 0
            ? ColoredBox(
                color: colorScheme.onSurfaceVariant,
                child: SizedBox(
                  width: height * boxWidth / (compress + 1),
                  height: height * boxHeight * dot.weight.abs(),
                ),
              )
            : SizedBox(
                width: height * boxWidth / (compress + 1),
              ))
        .toList(growable: false);

    final minus = dots
        .map((dot) => dot.weight < 0
            ? ColoredBox(
                color: colorScheme.onSurfaceVariant,
                child: SizedBox(
                  width: height * boxWidth / (compress + 1),
                  height: height * boxHeight * dot.weight.abs(),
                ),
              )
            : SizedBox(
                width: height * boxWidth / (compress + 1),
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
              children: plus,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: minus,
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

class Pubkey2Colors extends StatelessWidget {
  const Pubkey2Colors({
    super.key,
    required this.pubkeyHex,
    this.height = 5,
    this.edgeLettersColor,
    this.compress = 0,
  });

  final String pubkeyHex;
  final double height;
  final Color? edgeLettersColor;
  final double compress;

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
          pubkeyHex.substring(0, 1),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: edgeLettersColor ??
                Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        ...series,
        Text(
          pubkeyHex.substring(pubkeyHex.length - 1, pubkeyHex.length),
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

@Deprecated('use waveform')
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
