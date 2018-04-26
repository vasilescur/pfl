import 'package:pfl/elements.dart';
import 'package:pfl/errors.dart';
import 'package:pfl/PflProgram.dart';

class Parser {
    PflProgram program;

    /// The body section of the PFL document is treated as the root node of the AST.
    BodyElement bodyElement;

    /// Holds references to all [Footnote] elements
    List<Footnote> footnotes = new List<Footnote>();

    List<Delimiter> delimiters = new List<Delimiter>();

    Parser(this.program);

    /// Parses the [program]'s source, building the AST based on the [bodyElement].
    void parseToTree() {
        // Parse footnotes
        for (var line in program.footnotes) {
            if (!line.startsWith('[')) {
                throw new ImproperFootnoteAlert(0);
            }

            String footnoteText = new RegExp(r'\[([\d:]+)\]').firstMatch(line).group(1);

            var id = null;
            var maxExecutions = 0;
            var enablePoint = 0;

            if (footnoteText.contains(':')) {
                var components = footnoteText.split(':');

                id = int.parse(components[0]);
                maxExecutions = int.parse(components[1]);
                enablePoint = components.length == 3 ? int.parse(components[2]) : 0;
            } else {
                id = int.parse(footnoteText);
            }

            Footnote footnote = new Footnote(id, maxExecutions, enablePoint);
            
            String footnoteContents = line.substring(line.indexOf(']') + 2);
            
            scanString(footnoteContents, footnote);

            footnotes.add(footnote);
        }

        // Create the root node (bodyElement)
        bodyElement = new BodyElement();

        // Scan the body
        scanString(program.body, bodyElement);
    }

    void scanString(String str, Element targetElement) {
        bool inDelimiter = false;
        String currentText = '';
        String currentDelimText = '';

        for (int i = 0; i < str.length; i++) {
            if (inDelimiter) {
                if (str[i] == ']') {   // End delimiter
                    inDelimiter = false;
                    var delimNum = int.parse(currentDelimText);

                    currentDelimText = '';

                    Delimiter delimiter = new Delimiter(delimNum);
                    targetElement.children.add(delimiter);
                    delimiters.add(delimiter);
                } else {
                    currentDelimText += str[i];
                }
            } else {    // Not in delimiter
                if (str[i] == '[') {   // Begin delimiter
                    inDelimiter = true;

                    if (currentText.length > 0) {
                        PlainText plainText = new PlainText(currentText);
                        targetElement.children.add(plainText);
                    }

                    currentText = '';
                } else {
                    currentText += str[i];
                }
            }   // inDelimiter
        }   // for

        if (!inDelimiter) {
            if (currentText.length > 0) {
                PlainText plainText = new PlainText(currentText);
                targetElement.children.add(plainText);
            }
        }
    }

    void resolveDelimiters() {
        for (var delimiter in delimiters) {
            // Find the target footnote of the delimiter
            var targetFootnote = footnotes
                .firstWhere((footnote) => footnote.id == delimiter.targetId, orElse: null);

            if (targetFootnote == null) {
                throw new MissingFootnoteAlert(-1, delimiter.targetId);
            }

            delimiter.target = targetFootnote;
        }        
    }
}