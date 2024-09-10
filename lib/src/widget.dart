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

class PubkeyMonochrome extends StatelessWidget {
  const PubkeyMonochrome({
    super.key,
    required this.pubkeyHex,
    this.height = 8,
    this.intensity = 1.0,
    this.edgeLettersColor,
    this.compress = 0,
  });

  final String pubkeyHex;
  final double height;
  final double intensity;
  final Color? edgeLettersColor;
  final double compress;

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    // final dark = colorScheme.brightness == Brightness.dark;
    final colors = HexToColors.pubkeyToMonochrome(pubkeyHex);

    final series = colors
        .map((c) => ColoredBox(
              color: c,
              child: SizedBox(
                width: height * 0.185 / (compress + 1),
                height: height,
              ),
            ))
        .toList(growable: false);

    // final series = colors
    //     .map((c) => ColoredBox(
    //           color: dark
    //               ? c
    //               : c
    //                   .withRed(((255 - c.red) * intensity).toInt())
    //                   .withGreen(((255 - c.green) * intensity).toInt())
    //                   .withBlue(((255 - c.blue) * intensity).toInt()),
    //           child: SizedBox(
    //             width: height * 0.185 / (compress + 1),
    //             height: height,
    //           ),
    //         ))
    //     .toList(growable: false);

    return Row(
      children: [
        Text(
          pubkeyHex.substring(0, 2),
          maxLines: 1,
          style: TextStyle(
            fontSize: height * 1.13,
            color: edgeLettersColor ??
                Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        ...series,
        Text(
          pubkeyHex.substring(pubkeyHex.length - 2, pubkeyHex.length),
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
