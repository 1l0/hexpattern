# NUD: Pubkey to waveform

This NUD defines how to convert pubkey to waveform.

![pubkey to colors](https://github.com/1l0/hexpattern/blob/master/images/pubkey_waveform.png?raw=true)

[Live demo](https://1l0.github.io/hexpattern/)

## Why?

- `npub` is nonsense to display.
  - too long.
- `npub1bla...bla` is nonsense to display.
  - `npub1` takes too much space.
  - `...` means nothing.

## Specs

- Uses hex pubkey.
- Converts 64 characters into 32 scalars.
  - Splits 64 with 2 length chunks.
  - Converts each chunk into a scalar.
    - `0 ~ 255` to `-1.0 ~ 1.0`

