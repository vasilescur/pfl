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

class PlainText extends Element {
    final String text;

    PlainText(this.text) {
        children = null;
    }

    @override
    String evaluate() => text;
}

/// Root node for the AST. Represents the body of the document.
class BodyElement extends Element {}

/// Pointer to a [Footnote].
class Delimiter extends Element {
    int targetId;

    Footnote target;

    Delimiter(this.targetId);

    @override
    String evaluate() {
        return target.evaluate();
    }
}

/// A footnote is an element that
class Footnote extends Element {
    /// Footnote number, ex. [1]
    int id;

    /// Number of times an attempt has been made to evaluate this footnote.
    int index = 0;

    /// Number of times this footnote has actually been evaluated.
    int runIndex = 0;

    /// Maximum number of times this footnote is allowed to be evaluated.
    /// If this value is not specified, it should be [0], representing no upper limit for executions.
    int maxExecutions;

    /// Minimum index before this footnote is allowed to be evaluated.
    /// If this value is not specified, it should be [0], representing no restriction.
    int enablePoint;

    Footnote(this.id, this.maxExecutions, this.enablePoint);

    @override
    String evaluate() {
        this.index++;

        if ((runIndex >= maxExecutions && maxExecutions > 0) || index < enablePoint) {
            // Not allowed to eval
            return '';
        }

        runIndex++;

        String result = '';

        for (var child in children) {
            result += child.evaluate();
        }

        return result;
    }
}
