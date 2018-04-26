/// Represents one node in the abstract syntax tree.
abstract class Element {
    List<Element> children;

    String evaluate() {
        String result;

        for (var child in children) {
            result += child.evaluate();
        }

        return result;
    }
}

class PlainText extends Element {
    final String text;

    PlainText(this.text) {
        children = null;
    }

    @override
    String evaluate() => text;
}

enum ConstFunctionType {
    ABC, BEEP, DATE, RET, SPACE, TAB,
    TIME, VER, ZEN
}

class ConstFunction extends Element {
    ConstFunctionType type;

    ConstFunction(this.type);

    @override
    String evaluate() {
        switch (type) {
            case ConstFunctionType.ABC:
                return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                break;
            
            case ConstFunctionType.BEEP:
                return '\a';    // (a)lert/bell character
                break;

            case ConstFunctionType.DATE:
                var now = new DateTime.now();
                return '${now.year}-${now.month}-${now.day}';
                break;

            case ConstFunctionType.RET:
                return '\n';    // Carriage return
                break;

            case ConstFunctionType.SPACE:
                return ' ';
                break;

            case ConstFunctionType.TAB:
                return '\t';
                break;
            
            case ConstFunctionType.TIME:
                var now = new DateTime.now();
                return '${now.hour}-${now.minute}-${now.second}';
                break;

            case ConstFunctionType.VER:
                //TODO
                throw new UnimplementedError();
                break;

            case ConstFunctionType.ZEN:
                return '';
                break;

            default:
                throw new TypeError();
        }
    }
}

class Footnote {
    /// Footnote number, ex. [1]
    int id;

    /// Number of times this footnote has been evaluated.
    int index;

    /// Maximum number of times this footnote is allowed to be evaluated.
    /// If this value is not specified, it should be [0], representing no upper limit for executions.
    int maxExecutions;

    /// Minimum index before this footnot is allowed to be evaluated.
    /// If this value is not specified, it should be [0], representing no restriction.
    int enablePoint;

    Footnote(this.id, [this.maxExecutions = 0, this.enablePoint = 0]) {
        this.index = 0;
    }
}
