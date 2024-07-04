import 'package:flutter/material.dart';

import 'converter.dart';

class PubkeyColors extends StatelessWidget {
  const PubkeyColors({
    super.key,
    required this.pubkeyHex,
    this.height = 5,
    this.edgeLetters = false,
    this.edgeLettersColor,
    this.compress = 0,
  });

  final String pubkeyHex;
  final double height;
  final bool edgeLetters;
  final Color? edgeLettersColor;
  final double compress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dark = colorScheme.brightness == Brightness.dark;
    final colors = HexToColors.pubkeyToAHSL(pubkeyHex, dark);

    final series = colors
        .map((c) => ColoredBox(
              color: c,
              child: SizedBox(
                width: height / (compress + 1),
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
            fontSize: height, // * 1.25,
            color: edgeLettersColor ??
                Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        ...series,
        Text(
          pubkeyHex.substring(pubkeyHex.length - 1, pubkeyHex.length),
          maxLines: 1,
          style: TextStyle(
            fontSize: height, // * 1.25,
            color: edgeLettersColor ??
                Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class PubkeyMonochrome extends StatelessWidget {
  const PubkeyMonochrome({
    super.key,
    required this.pubkeyHex,
    this.height = 8,
    this.alpha = 255,
  });

  final String pubkeyHex;
  final double height;
  final int alpha;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).colorScheme.brightness == Brightness.light;
    // final pubkeylen = pubkeyHex.length;
    final colors = HexToColors.pubkeyToMonochrome(pubkeyHex);

    final series = colors
        .getRange(0, 32)
        //.getRange(1, 31)
        .map((c) => ColoredBox(
              color: light
                  ? c
                      .withRed(255 - c.red)
                      .withGreen(255 - c.green)
                      .withBlue(255 - c.blue)
                      .withAlpha(alpha)
                  : c.withAlpha(alpha),
              child: SizedBox(
                width: height * 0.206,
                //width: height * 0.103,
                height: height,
              ),
            ))
        .toList(growable: false);

    return Row(
      children: [
        // Text(
        //   pubkeyHex.substring(0, 2),
        //   maxLines: 1,
        //   style: TextStyle(
        //     fontSize: height, // * 1.25,
        //     color: Theme.of(context).colorScheme.onSurfaceVariant,
        //   ),
        // ),
        ...series,
        // Text(
        //   pubkeyHex.substring(pubkeylen - 2, pubkeylen),
        //   maxLines: 1,
        //   style: TextStyle(
        //     fontSize: height, // * 1.25,
        //     color: Theme.of(context).colorScheme.onSurfaceVariant,
        //   ),
        // ),
      ],
    );
  }
}
