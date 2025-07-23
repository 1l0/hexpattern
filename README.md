[![pub package](https://img.shields.io/pub/v/hexpattern.svg)](https://pub.dev/packages/hexpattern)

# nostr pubkey shape

- The shape is a variant of the octagon.
- The vertices are derived from parts of the hex pubkey.
  - The first one is `pubkey.substring[0, 8]`, the last one is `pubkey.substring[56, 64]`. Those are convered into numbers and normalized with `0xFFFFFFFF`.

[Live demo](https://1l0.github.io/hexpattern/)
