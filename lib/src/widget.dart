import 'package:flutter/material.dart';

import 'converter.dart';

@Deprecated('use Pubkey2Colors')
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
                width: height * 0.2 / (compress + 1),
                height: height,
              ),
            ))
        .toList(growable: false);

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
