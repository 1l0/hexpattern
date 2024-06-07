import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:hexpattern/hexpattern.dart';

const double _genericStride = 15;
const double _nestedStride = _genericStride * 0.5;
const double _avatarRadius = _genericStride * 1.34;
const double _reactionBarIconSize = _genericStride;
const double _reactionBarFontSize = _genericStride * 0.75;
const double _reactionBarStride = _genericStride * 0.25;
const int _lessTextLength = 300;

class Card extends StatelessWidget {
  const Card({
    super.key,
    required this.name,
    required this.pubkeyHex,
    required this.text,
    this.imageUrl,
    this.mono = true,
    this.top = false,
  });

  final String name;
  final String pubkeyHex;
  final String text;
  final String? imageUrl;
  final bool mono;
  final bool top;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // if (!top)
        // Divider(
        //   height: 0,
        //   indent: 0,
        //   endIndent: 0,
        //   color: Theme.of(context).colorScheme.outlineVariant,
        // ),
        // const SizedBox(
        //   height: _nestedStride,
        // ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: _nestedStride,
            ),
            AvatarArea(imageUrl: imageUrl),
            const SizedBox(
              width: _nestedStride,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IdentityBar(name: name, pubkeyHex: pubkeyHex),
                  Content(text: text),
                  const SizedBox(
                    height: _nestedStride,
                  ),
                  const ReactionBar(),
                ],
              ),
            ),
            const SizedBox(
              width: _nestedStride,
            ),
          ],
        ),
        const SizedBox(
          height: _nestedStride,
        ),
      ],
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final more = text.length > _lessTextLength;
    var t = text;
    if (more) t = '${text.substring(0, _lessTextLength)}… ';
    return SizedBox(
      width: double.infinity,
      child: SelectableText.rich(
        TextSpan(
          text: t,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          children: [
            if (more)
              WidgetSpan(
                child: Icon(
                  Icons.expand_more,
                  size: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            // TextSpan(
            //   text: 'Show more',
            //   style: TextStyle(
            //     color: Theme.of(context).colorScheme.secondary,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class IdentityBar extends StatelessWidget {
  const IdentityBar({
    super.key,
    required this.name,
    required this.pubkeyHex,
  });

  final String name;
  final String pubkeyHex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(
                width: _nestedStride,
              ),
              PubkeyMonochrome(
                pubkeyHex: pubkeyHex,
                alpha: 128,
              ),
              // PubkeyColors(pubkeyHex: pubkeyHex, alpha: 192),
              const SizedBox(
                width: _nestedStride,
              ),
              Text(
                '16m',
                maxLines: 1,
                style: TextStyle(
                  fontSize: _reactionBarFontSize,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(
        //   width: _nestedStride,
        // ),
        // Icon(
        //   Icons.more_horiz,
        //   size: _reactionBarIconSize,
        //   color: Theme.of(context).colorScheme.onSurfaceVariant,
        // ),
        // const SizedBox(
        //   width: _nestedStride,
        // ),
      ],
    );
  }
}

class AvatarArea extends StatelessWidget {
  const AvatarArea({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: _avatarRadius,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        ),
      ],
    );
  }
}

class ReactionBar extends StatelessWidget {
  const ReactionBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rand = Random(context.hashCode);
    return Wrap(
      spacing: _nestedStride,
      runSpacing: _nestedStride * 0.5,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        if (rand.nextDouble() > 0.85)
          Reaction(
            iconData: Icons.bookmark,
            naked: true,
          ),
        if (rand.nextBool())
          Reaction(
            iconData: Icons.mode_comment_outlined,
            count: rand.nextInt(20),
            naked: true,
          ),
        if (rand.nextBool())
          Reaction(
            iconData: Icons.repeat,
            count: rand.nextInt(3000),
            naked: true,
          ),
        if (rand.nextBool())
          Reaction(
            iconData: Icons.star_outline,
            count: rand.nextInt(5000),
            naked: true,
          ),
        if (rand.nextDouble() > 0.85)
          Reaction(
            iconData: Icons.bolt_outlined,
            count: rand.nextInt(100000),
            message: 'yet another zap for you',
          ),
        AddReaction(iconData: Icons.add),
        AddReaction(iconData: Icons.more_horiz),
      ],
    );
  }
}

class Reaction extends StatelessWidget {
  const Reaction({
    super.key,
    required this.iconData,
    this.count = 0,
    this.naked = false,
    this.message,
  });

  final IconData iconData;
  final int count;
  final bool naked;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final intl.NumberFormat numberFormat = intl.NumberFormat.compact();

    return Container(
      decoration: !naked
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius:
                  const BorderRadius.all(Radius.circular(_nestedStride)))
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: _reactionBarIconSize,
            color: naked
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          if (count > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  _nestedStride * 0.5, 0, _nestedStride, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    numberFormat.format(count),
                    style: TextStyle(
                      fontWeight: message != null ? FontWeight.bold : null,
                      fontSize: _reactionBarFontSize,
                      color: naked
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                  if (message != null)
                    const SizedBox(
                      width: _nestedStride * 0.5,
                    ),
                  if (message != null)
                    Text(
                      message!,
                      style: TextStyle(
                        // fontStyle: FontStyle.italic,
                        fontSize: _reactionBarFontSize,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AddReaction extends StatelessWidget {
  const AddReaction({
    super.key,
    required this.iconData,
  });

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(
        iconData,
        size: _reactionBarIconSize,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () {},
    );
  }
}
