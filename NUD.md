# NUD: Pubkey to colors

This NUD defines how to convert pubkey to colors.

![pubkey to colors](https://github.com/1l0/hexpattern/blob/master/images/pubkey2colors.png?raw=true)

[Live demo](https://1l0.github.io/hexpattern/)

## Why?

- `npub` is nonsense to display.
  - too long.
- `npub1bla...bla` is nonsense to display.
  - `npub1` takes too much space.
  - `...` means nothing.

## Specs

- Uses hex pubkey.
- Converts 64 characters to 8 colors.
  - Splits 64 with 8 length chunks.
  - Converts each 2 in 8 into
    - Alpha (0-255 -> 0.0-1.0)
    - Hue (0-255 -> 0.0-360.0)
    - Saturation (0-255 -> 0.0-1.0)
    - Light (0-255 -> 0.0-1.0)
- Supports dark and light theme.
  - When Light is 1.0, flip the Light for light theme (0.0).
