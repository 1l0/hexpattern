import 'package:flutter/material.dart';

import 'converter.dart';

class PubkeyColors extends StatelessWidget {
  const PubkeyColors({
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
    final pubkeylen = pubkeyHex.length;
    final colors = HexToColors.pubkeyToColors(pubkeyHex);

    // final strange = ColoredBox(
    //   color: colors[0].withAlpha(alpha),
    //   child: SizedBox(
    //     width: height * 0.618,
    //     height: height,
    //   ),
    // );

    final series = colors
        .getRange(1, 11)
        .map((c) => ColoredBox(
              color: c.withAlpha(alpha),
              child: SizedBox(
                width: height * 0.618,
                height: height,
              ),
            ))
        .toList(growable: false);

    // final charm = ColoredBox(
    //   color: colors[11].withAlpha(alpha),
    //   child: SizedBox(
    //     width: height * 0.618,
    //     height: height,
    //   ),
    // );

    // return Row(
    //   children: [strange, ...series, charm],
    // );
    return Row(
      children: [
        Text(
          pubkeyHex.substring(0, 2),
          maxLines: 1,
          style: TextStyle(
            fontSize: height, // * 1.25,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        ...series,
        Text(
          pubkeyHex.substring(pubkeylen - 2, pubkeylen),
          maxLines: 1,
          style: TextStyle(
            fontSize: height, // * 1.25,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    final pubkeylen = pubkeyHex.length;
    final colors = HexToColors.pubkeyToMonochrome(pubkeyHex);

    final series = colors
        .getRange(1, 31)
        .map((c) => ColoredBox(
              color: c.withAlpha(alpha),
              child: SizedBox(
                width: height * 0.103,
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
            fontSize: height, // * 1.25,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        ...series,
        Text(
          pubkeyHex.substring(pubkeylen - 2, pubkeylen),
          maxLines: 1,
          style: TextStyle(
            fontSize: height, // * 1.25,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class PubkeyLeadColor extends StatelessWidget {
  const PubkeyLeadColor({
    super.key,
    required this.pubkeyHex,
    this.width = 40,
    this.height = 5,
    this.alpha = 255,
  });

  final String pubkeyHex;
  final double width;
  final double height;
  final int alpha;

  @override
  Widget build(BuildContext context) {
    final colors = HexToColors.pubkeyToLeadColor(pubkeyHex);
    debugPrint('${colors.length}');
    final List<ColoredBox> boxes = [
      ColoredBox(
        color: colors[0].withAlpha(alpha),
        child: SizedBox(
          width: width / 11,
          height: height,
        ),
      )
    ];
    final series = colors
        .getRange(1, 24)
        .map((c) => ColoredBox(
              color: c.withAlpha(alpha),
              child: SizedBox(
                width: width / 32,
                height: height,
              ),
            ))
        .toList(growable: true);
    boxes.addAll(series);
    boxes.add(ColoredBox(
      color: colors[27].withAlpha(alpha),
      child: SizedBox(
        width: width / 11,
        height: height,
      ),
    ));
    return Row(
      children: boxes,
    );
  }
}
