import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'converter.dart';

class PubkeyColors extends StatelessWidget {
  const PubkeyColors({
    super.key,
    required this.pubkeyHex,
    // this.width = 27 * 1.618,
    // this.height = 4,
    this.width = 35,
    this.height = 5,
  });

  final String pubkeyHex;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = HexToColors.pubkeyToColors(pubkeyHex);
    final series = colors
        .getRange(0, 10)
        .map((c) => ColoredBox(
              color: c,
              child: SizedBox(
                width: width / 10,
                height: height * 2 / 3,
              ),
            ))
        .toList(growable: false);
    final strange = ColoredBox(
      color: colors[10],
      child: SizedBox(
        width: width / 2,
        height: height / 3,
      ),
    );
    final charm = ColoredBox(
      color: colors[11],
      child: SizedBox(
        width: width / 2,
        height: height / 3,
      ),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: series,
        ),
        Row(
          children: [
            strange,
            charm,
          ],
        ),
      ],
    );
  }
}

class PubkeyMonochrome extends StatelessWidget {
  const PubkeyMonochrome({
    super.key,
    required this.pubkeyHex,
    // this.width = 27 * 1.618,
    // this.height = 4,
    this.width = 30,
    this.height = 8,
  });

  final String pubkeyHex;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    var pubkeylen = pubkeyHex.length;
    final colors = HexToColors.pubkeyToMonochrome(pubkeyHex);
    final series = colors
        .getRange(1, 31)
        .map((c) => ColoredBox(
              color: c,
              child: SizedBox(
                width: width / 32,
                height: height,
              ),
            ))
        .toList(growable: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pubkeyHex.substring(0, 2),
              maxLines: 1,
              style: TextStyle(
                fontSize: height * 1.25,
              ),
            ),
            ...series,
            Text(
              pubkeyHex.substring(pubkeylen - 2, pubkeylen),
              maxLines: 1,
              style: TextStyle(
                fontSize: height * 1.25,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PubkeyLeadColor extends StatelessWidget {
  const PubkeyLeadColor({
    super.key,
    required this.pubkeyHex,
    // this.width = 27 * 1.618,
    // this.height = 4,
    this.width = 35,
    this.height = 5,
  });

  final String pubkeyHex;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = HexToColors.pubkeyToLeadColor(pubkeyHex);
    debugPrint('${colors.length}');
    final List<ColoredBox> boxes = [
      ColoredBox(
        color: colors[0],
        child: SizedBox(
          width: width / 11,
          height: height,
        ),
      )
    ];
    final series = colors
        .getRange(1, 30)
        .map((c) => ColoredBox(
              color: c,
              child: SizedBox(
                width: width / 32,
                height: height,
              ),
            ))
        .toList(growable: true);
    boxes.addAll(series);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: boxes,
        ),
      ],
    );
  }
}
