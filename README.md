[![pub package](https://img.shields.io/pub/v/hexpattern.svg)](https://pub.dev/packages/hexpattern)

# hexpattern

[![pubkey to mono](https://github.com/1l0/hexpattern/blob/master/images/pubkey2mono.png?raw=true)](https://1l0.github.io/hexpattern/)

A reference implementation of Nostr pubkey to colors.

[Live demo](https://1l0.github.io/hexpattern/)

## Why?

- `npub` is nonsense to display.
  - too long.
- `npub1bla...bla` is nonsense to display.
  - `npub1` takes too much space.
  - `...` means nothing.

## Specs

- Uses hex pubkey.
- Converts 64 characters into 32 monochrome colors.
  - Splits 64 with 2 length chunks.
  - Converts each chunk into monochrome color.
    - `00` -> black, `ff` -> white

