import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:hexpattern/hexpattern.dart';

const double _genericStride = 15;
const double _nestedStride = 7.5;
const double _reactionBarIconSize = 20;
const double _reactionBarFontSize = 10;

class Card extends StatelessWidget {
  Card({
    super.key,
    required this.name,
    required this.pubkeyHex,
    required this.text,
    this.imageUrl,
    this.mono = true,
    this.secondaryColor = const Color.fromARGB(255, 134, 134, 134),
  });

  final String name;
  final String pubkeyHex;
  final String text;
  final String? imageUrl;
  final bool mono;
  final Color? secondaryColor;
  final intl.NumberFormat numberFormat = intl.NumberFormat.compact();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: double.infinity,s
      child: Column(
        children: [
          const SizedBox(
            height: _genericStride,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _genericStride),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                text,
              ),
            ),
          ),
          const SizedBox(
            height: _genericStride,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: _nestedStride, right: _nestedStride),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: _nestedStride, bottom: _genericStride),
                  child: CircleAvatar(
                    radius: _genericStride * 1.25,
                    backgroundImage:
                        imageUrl != null ? NetworkImage(imageUrl!) : null,
                  ),
                ),
                // const SizedBox(
                //   width: _nestedStride,
                // ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: _nestedStride, right: _nestedStride),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          height: _nestedStride * 0.25,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 0.67,
                              child: PubkeyMonochrome(pubkeyHex: pubkeyHex),
                            ),
                            const SizedBox(
                              width: _nestedStride,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: _nestedStride * 0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.mode_comment_outlined,
                            size: _reactionBarIconSize,
                            color: secondaryColor,
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: _reactionBarFontSize,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: _nestedStride * 1.5,
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.repeat,
                            size: _reactionBarIconSize,
                            color: secondaryColor,
                          ),
                          Text(
                            numberFormat.format(1000),
                            style: TextStyle(
                              fontSize: _reactionBarFontSize,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: _nestedStride * 1.5,
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.electric_bolt_outlined,
                            size: _reactionBarIconSize,
                            color: secondaryColor,
                          ),
                          Text(
                            numberFormat.format(1000),
                            style: TextStyle(
                              fontSize: _reactionBarFontSize,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: _nestedStride * 1.5,
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.favorite_outline,
                            size: _reactionBarIconSize,
                            // color: Color.fromARGB(124, 255, 0, 0),
                            color: secondaryColor,
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: _reactionBarFontSize,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: _nestedStride * 1.5,
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.more_vert,
                            size: _reactionBarIconSize,
                            color: secondaryColor,
                          ),
                          Text(
                            '4h',
                            style: TextStyle(
                              fontSize: _reactionBarFontSize,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: _genericStride,
          // ),
          // const SizedBox(height: 10),
          Divider(
            height: 0,
            indent: 0,
            endIndent: 0,
            color: Theme.of(context).colorScheme.outline,
          ),
        ],
      ),
    );
  }
}

const sampleText =
    "t is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', \nmaking it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).";
