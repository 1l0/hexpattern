import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:hexpattern/hexpattern.dart';

const double _genericStride = 15;
const double _nestedStride = _genericStride * 0.5;
const double _avatarRadius = _genericStride * 1.5;
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
        if (!top)
          Divider(
            height: 0,
            indent: 0,
            endIndent: 0,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        const SizedBox(
          height: _nestedStride,
        ),
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
      child: RichText(
        text: TextSpan(
          text: t,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          children: [
            if (more)
              TextSpan(
                text: 'Show more',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
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
              PubkeyMonochrome(pubkeyHex: pubkeyHex, alpha: 128),
            ],
          ),
        ),
        const SizedBox(
          width: _nestedStride,
        ),
        Text(
          '5/21',
          maxLines: 1,
          style: TextStyle(
            fontSize: _reactionBarFontSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(
          width: _nestedStride,
        ),
        Icon(
          Icons.more_horiz,
          size: _reactionBarIconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(
          width: _nestedStride,
        ),
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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Reaction(iconData: Icons.mode_comment_outlined, count: 0),
              Reaction(iconData: Icons.repeat, count: 1000),
              Reaction(iconData: Icons.bolt_outlined, count: 1000),
              Reaction(iconData: Icons.star_outline, count: 1000),
              Reaction(iconData: Icons.bookmark_outline),
            ],
          ),
        ),
        SizedBox(
          width: _genericStride,
        ),
        Reaction(iconData: Icons.ios_share_outlined),
      ],
    );
  }
}

class Reaction extends StatelessWidget {
  const Reaction({
    super.key,
    required this.iconData,
    this.count = 0,
  });

  final IconData iconData;
  final int count;

  @override
  Widget build(BuildContext context) {
    final intl.NumberFormat numberFormat = intl.NumberFormat.compact();
    return Row(
      children: [
        Icon(
          iconData,
          size: _reactionBarIconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(
          width: _reactionBarStride,
        ),
        Text(
          count != 0 ? numberFormat.format(count) : '',
          style: TextStyle(
            fontSize: _reactionBarFontSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
