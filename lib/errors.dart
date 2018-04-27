abstract class PflError implements Exception {
    int lineNumber; //TODO
    String errType();

    PflError(this.lineNumber);

    String getMessage() {
        if (lineNumber > 0) {
            return '${errType()} on line $lineNumber';
        } else if (lineNumber == 0) {
            return '${errType()}';
        } else if (lineNumber == -1) {
            return '${errType()} in body';
        } else {
            return 'Error';
        }
    }
}

/// Occurs when a footnote was found in the FOOTNOTES section
/// that was not properly formed.
class ImproperFootnoteAlert extends PflError {
    String errType() => "Improper Footnote Alert";
    ImproperFootnoteAlert(int lineNumber) : super(lineNumber);
}

/// Occurs when a delimiter was found in either the BODY or the
/// FOOTNOTES section that was not properly formed. This may be
/// caused by square brackets that have not been properly
/// escaped.
class MalformedDelimiterAlert extends PflError {
    String errType() => "Malformed Delimiter Alert";
    MalformedDelimiterAlert(int lineNumber) : super(lineNumber);
}


/// Occurs when there is a delimiter in the BODY section of the
/// document that has no corresponding footnote in the
/// FOOTNOTES section.
class MissingFootnoteAlert extends PflError {
    int id;
    String errType() => "Improper Footnote Alert";
    MissingFootnoteAlert(int lineNumber, this.id) : super(lineNumber);
}

/// Occurs when there is a footnote in the FOOTNOTES section of
/// the document that has no corresponding delimiter in the BODY
/// section.
class UnassignedFootnoteAlert extends PflError {
    String errType() => "Unassigned Footnote Alert";
    UnassignedFootnoteAlert(int lineNumber) : super(lineNumber);
}


/// Occurs when there is a buffer overflow while parsing the
/// document, possibly due to a circular reference.
class TooMuchInformation extends PflError {
    String errType() => "Too Much Information";
    TooMuchInformation(int lineNumber) : super(lineNumber);
}


/// Occurs when a function encounters an invalid value or 
/// another error.
class FunctionError extends PflError {
    String errType() => "Function Error";
    FunctionError(int lineNumber) : super(lineNumber);
}


/// Occurs when the footnote numbers in the FOOTNOTES section
/// are not in sequential order.
class FootnoteSequenceError extends PflError {
    String errType() => "Footnote Sequence Error";
    FootnoteSequenceError(int lineNumber) : super(lineNumber);
}


/// Occurs when this is not a PFL Document: No PFL document
/// identifier was found.
class NotAPflDocument extends PflError {
    String errType() => "Not A PFL Document";
    NotAPflDocument() : super(0);
}

/// Occurs when the version of PFL specified in the PFL document
/// identifier was not recognized by the parser.
class UnrecognizedVersionNumber extends PflError {
    String errType() => "Unrecognized Version Number";
    UnrecognizedVersionNumber(int lineNumber) : super(lineNumber);
}

/// Occurs when a [[PFLEND]] marker was encountered in the BODY
/// section of the document.
class UnexpectedPflendMarker extends PflError {
    String errType() => "Unexpected [PFLEND] Marker";
    UnexpectedPflendMarker(int lineNumber) : super(lineNumber);
}

/// Occurs when no [[PFLEND]] marker is found.
class NoPflEndMarker extends PflError {
    String errType() => "No [PFLEND] Marker";
    NoPflEndMarker() : super(0);
}