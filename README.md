# Procedural Footnote Language

An interpreter for [Procedural Footnote Language](http://dmmyers.com/pflspec.html), written in [Dart](https://www.dartlang.org/).

Please note that this project is still work-in-progress and some features may not work as expected.

## Getting Started

To get started with Procedural Footnote Language, first read the [language description](http://dmmyers.com/pflspec.html).

### Installing

Download the latest stable release of the PFL interpreter from the [Releases section](https://github.com/vasilescur/pfl/releases). Place the `pfl.exe` in a folder added to your `PATH`.

**Important:** The PFL interpreter is currently only available for Windows, and is packaged using [dartbin](https://github.com/filiph/dartbin).

### Usage

To run a PFL program, execute the following command:

```bash
pfl filename.pfl
```

### Sample PFL Programs

#### Simple "Hello, world!"

```
[1]
[PFL1.0]
[1] Hello, world!
[PFLEND]
```

#### The Twelve Days of Christmas

```
The Twelve Days of Christmas[1][2][5][6][7][8][9][10][11][12][13][14][15]
[PFL1.0]
[1:12] [RET][RET]On the [ORD:[INDEX:1]] day of Christmas my true love gave to me[RET]
[2] [IF:[IS:[INDEX:2]:1]:[4]:[3]]
[3] and [4]
[4] a partridge in a pear tree[RET][1]
[5] Two turtle doves[RET][2]
[6] Three french hens[RET][5]
[7] Four calling birds[RET][6]
[8] FIVE GOLDEN RINGS[BEEP][RET][7]
[9] Six geese a laying[RET][8]
[10] Seven swans a swimming[RET][9]
[11] Eight maids a milking[RET][10]
[12] Nine ladies dancing[RET][11]
[13] Ten lords a leaping[RET][12]
[14] Eleven pipers piping[RET][13]
[15] Twelve drummers drumming[RET][14]
[PFLEND]
```

A few more examples can be found in the `examples` directory.

## Development

### Prerequisites

* Dart SDK - [install](https://www.dartlang.org/tools/sdk#install)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* Daniel Myers, who drafted the initial language specification
