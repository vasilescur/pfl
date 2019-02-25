# Procedural Footnote Language

An interpreter for [Procedural Footnote Language](https://github.com/vasilescur/pfl/wiki/Procedural-Footnote-Language-Specification), written in [Dart](https://www.dartlang.org/).

Please note that this project is still work-in-progress and some features may not work as expected.

## Getting Started

To get started with Procedural Footnote Language, first read the [language specification](https://github.com/vasilescur/pfl/wiki/Procedural-Footnote-Language-Specification).

### Installing

Download the latest stable release of the PFL interpreter from the [Releases section](https://github.com/vasilescur/pfl/releases). Place the `pfl.exe` in a folder added to your `PATH`.

**Important:** The PFL interpreter is currently only available for Windows, and is packaged using [dartbin](https://github.com/filiph/dartbin).

### Usage

To run a PFL program, execute the following command:

```bash
pfl filename.pfl
```

## How it Works

The interpeter uses a loose interpretation of an abstract syntax tree to evaluate the final result of the document.

There is a class heirarchy of elements, each with an overriden `evaluate` method that, by default, evaluates all its children,
concatenates the results, and returns:

```dart
/// Represents one node in the abstract syntax tree.
class Element {
    List<Element> children = new List<Element>();

    String evaluate() {
        String result = '';

        for (var child in children) {
            result += child.evaluate();
        }

        return result;
    }
}
```

Therefore, since the root document is also one of these nodes, evaluation of the entire document is as simple as calling `evaluate` on the root document.

## Sample PFL Programs

#### Simple "Hello, world!"

```
[1]
[PFL1.0]
[1] Hello, world!
[PFLEND]
```

#### Adding two numbers
```
[1][2][3]
[PFL1.0]
[1:0:2] [INPUT]
[2:0:2] [INPUT]
[3] [ADD:[1]:[2]]
[PFLEND]
```

#### Primality test
```
[1][2]
[PFL1.0]
[1:0:2] [INPUT]
[2] [PRIME:[1]]
[PFLEND]
```

#### 99 Bottles of Beer
```
[1][2]
[PFL1.0]
[1:98] [SUB:100:[INDEX:1]] bottles of beer on the wall, [SUB:100:[INDEX:1]] bottles of beer.[RET]Take one down, pass it around, [IF:[GT:[SUB:99:[INDEX:1]]:1]:[SUB:99:[INDEX:1]] bottles:1 bottle] of beer on the wall.[RET][RET][1]
[2] 1 bottle of beer on the wall, 1 bottle of beer.[RET]Take one down and pass it around, no more bottles of beer on the wall.[RET][RET]No more bottles of beer on the wall, no more bottles of beer.[RET]Go to the store and buy some more, 99 bottles of beer on the wall.[RET]
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

### Releases

#### Windows

I built this back when I used Windows, so the release script is a `bat` file. It uses a Go program written by someone
else to bundle the entire Dart VM and the interpreter into one massive `exe` file. I know this is a bad idea. 

#### MacOS, Linux

TODO: Add shebang line to main to allow running with implied interpreter `dart`

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* Daniel Myers, who drafted the [original language specification](http://dmmyers.com/pflspec.html).
