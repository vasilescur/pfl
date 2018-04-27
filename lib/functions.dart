import 'package:pfl/elements.dart';
import 'package:pfl/PflProgram.dart';
import 'package:pfl/errors.dart';


// ################# ParamFunctions ################# //

abstract class ParamFunction extends Element {
    List<Element> parameters;
}

/// Adds two parameters.
class AddFunction extends ParamFunction {
    @override
    String evaluate() {
        int a = int.parse(parameters[0].evaluate());
        int b = int.parse(parameters[1].evaluate());

        return (a + b).toString();
    }
}

/// Performs boolean [AND] on two parameters.
class AndFunction extends ParamFunction {
    @override
    String evaluate() {
        String a = parameters[0].evaluate();
        String b = parameters[1].evaluate();

        return a == 'true' && b == 'true' ? 'true' : 'false';
    }
}

/// Returns the ASCII character for a given hexadecimal value (one parameter).
class AsciiFunction extends ParamFunction {
    @override
    String evaluate() {
        return new String.fromCharCode(int.parse(parameters[0].evaluate(), radix: 16));
    }
}

/// Returns [true] if the left parameter is greater than the right parameter.
class GTFunction extends ParamFunction {
    @override
    String evaluate() {
        String a = parameters[0].evaluate();
        String b = parameters[1].evaluate();

        return int.parse(a) > int.parse(b) ? 'true' : 'false';
    }
}

/// Returns the hexadecimal representation of a given ASCII character (one parameter).
class HexFunction extends ParamFunction {
    @override
    String evaluate() {
        return parameters[0].evaluate().codeUnitAt(0).toRadixString(16);
    }
}

/// Single-branch IF statement (two params).
class IfFunction extends ParamFunction {
    @override
    String evaluate() {
        String a = parameters[0].evaluate();

        if (a == 'true') {
            return parameters[1].evaluate();
        } else {
            return '';
        }
    }
}

/// Double-brach IF statement (if-else) (three params).
class IfElseFunction extends ParamFunction {
    @override
    String evaluate() {
        String a = parameters[0].evaluate();
        
        if (a == 'true') {
            return parameters[1].evaluate();
        } else {
            return parameters[2].evaluate();
        }
    }
}

/// Returns the number of times a footnote has been evaluated.
class IndexFunction extends ParamFunction {

    List<Footnote> footnotes = null;

    void passFootnotes(List<Footnote> footnotes) {
        this.footnotes = footnotes;
    }

    @override
    String evaluate() {
        int footnoteId = int.parse(parameters[0].evaluate());

        var targetFootnote = footnotes
                .firstWhere((footnote) => footnote.id == footnoteId, orElse: null);

        if (targetFootnote == null) {
            throw new FunctionError(0);
        }

        return targetFootnote.runIndex.toString();
    }
}

/// Returns [true] if the two parameters are equal.
class IsFunction extends ParamFunction {
    @override
    String evaluate() {
        String a = parameters[0].evaluate();
        String b = parameters[1].evaluate();

        return a == b ? 'true' : 'false';
    }
}

/// Returns the length of the text in its one parameter.
class LenFunction extends ParamFunction {
    @override
    String evaluate() {
        return parameters[0].evaluate().length.toString();
    }
}

/// Returns [true] if the left parameter is less than the right parameter.
class LTFunction extends ParamFunction {
    @override
    String evaluate() {
        String a = parameters[0].evaluate();
        String b = parameters[1].evaluate();

        return int.parse(a) < int.parse(b) ? 'true' : 'false';
    }
}

/// Returns the inverse of the input (boolean [NOT]).
class NotFunction extends ParamFunction {
    @override
    String evaluate() {
        return parameters[0].evaluate() == 'true' ? 'false' : 'true';
    }
}

/// Performs boolean [OR] on two parameters.
class OrFunction extends ParamFunction {
    @override
    String evaluate() {
        String a = parameters[0].evaluate();
        String b = parameters[1].evaluate();

        return a == 'true' || b == 'true' ? 'true' : 'false';
    }
}

/// Returns the English ordinal number representing the input.
/// For example, [1] yields ['first'], [2] yields ['second'], etc..
class OrdFunction extends ParamFunction {
    @override
    String evaluate() {
        int number = int.parse(parameters[0].evaluate());

        List<String> suffixes = [
            'th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th'
        ];

        switch (number % 100) {
            case 11:
            case 12:
            case 13:
                return number.toString() + 'th';

            default:
                return number.toString() + suffixes[number % 10];
        }
    }
}

/// Subtracts two parameters.
class SubFunction extends ParamFunction {
    @override
    String evaluate() {
        int a = int.parse(parameters[0].evaluate());
        int b = int.parse(parameters[1].evaluate());

        return (a - b).toString();
    }
}

/// Performs boolean [XOR] on two parameters.
class XorFunction extends ParamFunction {
    @override
    String evaluate() {
        String aStr = parameters[0].evaluate();
        String bStr = parameters[1].evaluate();

        bool a = aStr == 'true' ? true : false;
        bool b = bStr == 'true' ? true : false;

        return !(a && b) && (a || b) == true ? 'true' : 'false';
    }
}


// ################# ConstFunctions ################# //

/// A constant function. Represents a simple-substitution delimiter.
class ConstFunction extends Element {
    String type;

    ConstFunction(this.type);

    @override
    String evaluate() {
        switch (type) {
            case 'ABC':
                return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
                break;

            case 'BEEP':
                return '\a';    // (a)lert/bell character
                break;

            case 'DATE':
                var now = new DateTime.now();
                return '${now.year}-${now.month}-${now.day}';
                break;

            case 'FALSE':
                return 'false';
                break;

            case 'HS':
                return 'Hi, Sherry!';
                break;

            case 'RET':
                return '\n';    // Carriage return
                break;

            case 'SPACE':
                return ' ';
                break;

            case 'TAB':
                return '\t';
                break;

            case 'TIME':
                var now = new DateTime.now();
                return '${now.hour}-${now.minute}-${now.second}';
                break;

            case 'TRUE':
                return 'true';
                break;

            case 'VER':
                return PflProgram.pflVersion;
                break;

            case 'ZEN':
                return '';
                break;

            default:
                throw new TypeError();
        }
    }
}