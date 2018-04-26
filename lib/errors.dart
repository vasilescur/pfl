/// Occurs when a footnote was found in the FOOTNOTES section
/// that was not properly formed.
class ImproperFootnoteAlert implements Exception {}

/// Occurs when a delimiter was found in either the BODY or the
/// FOOTNOTES section that was not properly formed. This may be
/// caused by square brackets that have not been properly
/// escaped.
class MalformedDelimiterAlert implements Exception {}


/// Occurs when there is a delimiter in the BODY section of the
/// document that has no corresponding footnote in the
/// FOOTNOTES section.
class MissingFootnoteAlert implements Exception {}

/// Occurs when there is a footnote in the FOOTNOTES section of
/// the document that has no corresponding delimiter in the BODY
/// section.
class UnassignedFootnoteAlert implements Exception {}


/// Occurs when there is a buffer overflow while parsing the
/// document, possibly due to a circular reference.
class TooMuchInformation implements Exception {}


/// Occurs when the footnote numbers in the FOOTNOTES section
/// are not in sequential order.
class FootnoteSequenceError implements Exception {}


/// Occurs when this is not a PFL Document: No PFL document
/// identifier was found.
class NotAPflDocument implements Exception {}

/// Occurs when the version of PFL specified in the PFL document
/// identifier was not recognized by the parser.
class UnrecognizedVersionNumber implements Exception {}

/// Occurs when a [[PFLEND]] marker was encountered in the BODY
/// section of the document.
class UnexpectedPflendMarker implements Exception {}