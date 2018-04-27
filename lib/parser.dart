import 'package:pfl/elements.dart';
import 'package:pfl/functions.dart';
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
        String plainTextStr = '';
        String tagText = '';

        int delimiterLevel = 0;

        for (int i = 0; i < str.length; i++) {
            if (inDelimiter) {
                if (str[i] == ']') {
                    delimiterLevel--;

                    if (delimiterLevel == 0) {

                        inDelimiter = false;

                        Element newElem = null;

                        List<Element> params = null;

                        if (tagText.contains(':')) {
                            var paramStrings = getParams(tagText);
                            params = new List<Element>();

                            for (var paramString in paramStrings) {
                                Element param = new Element();
                                scanString(paramString, param);

                                params.add(param);
                            }
                        }

                        // Try each type of function
                        // Parameter Functions
                        if (tagText.startsWith('ADD')) {
                            newElem = new AddFunction();
                        } else if (tagText.startsWith('AND')) {
                            newElem = new AndFunction();
                        } else if (tagText.startsWith('ASCII')) {
                            newElem = new AsciiFunction();
                        } else if (tagText.startsWith('GT')) {
                            newElem = new GTFunction();
                        } else if (tagText.startsWith('HEX')) {
                            newElem = new HexFunction();
                        } else if (tagText.startsWith('IF')) {
                            if (params.length == 2) {
                                newElem = new IfFunction();
                            } else if (params.length == 3) {
                                newElem = new IfElseFunction();
                            } else {
                                print('params: $params');
                                throw new Exception('Bad IF statement');
                            }
                        } else if (tagText.startsWith('INDEX')) {
                            newElem = new IndexFunction();
                            (newElem as IndexFunction).passFootnotes(footnotes);
                        } else if (tagText.startsWith('IS')) {
                            newElem = new IsFunction();
                        } else if (tagText.startsWith('LEN')) {
                            newElem = new LenFunction();
                        } else if (tagText.startsWith('LT')) {
                            newElem = new LTFunction();
                        } else if (tagText.startsWith('NOT')) {
                            newElem = new NotFunction();
                        } else if (tagText.startsWith('ORD')) {
                            newElem = new OrdFunction();
                        } else if (tagText.startsWith('OR')) {
                            newElem = new OrFunction();
                        } else if (tagText.startsWith('SUB')) {
                            newElem = new SubFunction();
                        } else if (tagText.startsWith('XOR')) {
                            newElem = new XorFunction();
                        } 
                        // Constant Functions
                        else if ([
                                'ABC', 'BEEP', 'DATE', 'FALSE', 'HS',
                                'RET', 'SPACE', 'TAB', 'TIME',
                                'TRUE', 'VER', 'ZEN'
                            ].contains(tagText)) {
                            newElem = new ConstFunction(tagText);
                        } else {
                            // The tag is a delimiter (Footnote reference)
                            newElem = new Delimiter(int.parse(tagText));
                            delimiters.add(newElem);
                        }

                        tagText = '';

                        if (params != null) {
                            (newElem as ParamFunction).parameters = params;
                        }

                        targetElement.children.add(newElem);
                    } else {
                        tagText += str[i];
                    }
                } else {
                    if (str[i] == '[') {
                        delimiterLevel++;
                    }
                    
                    tagText += str[i];
                }
            } else {    // Not in delimiter
                if (str[i] == '[') {   

                    if (delimiterLevel == 0) { // Begin delimiter
                        inDelimiter = true;
                        delimiterLevel++;

                        if (plainTextStr.length > 0) {
                            PlainText plainText = new PlainText(plainTextStr);
                            targetElement.children.add(plainText);
                        }

                        plainTextStr = '';
                    } else {
                        delimiterLevel++;
                        tagText+= str[i];
                    }

                } else {
                    plainTextStr += str[i];
                }
            }   // inDelimiter
        }   // for

        if (!inDelimiter) {
            if (plainTextStr.length > 0) {
                PlainText plainText = new PlainText(plainTextStr);
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

    static List<String> getParams(String line) {    // line ex.: ADD:[IF:[TRUE]:1:4]:[ADD:2:3]
        List<String> parts = new List<String>();

        int tagLevel = 0;
        String currentPart = '';

        for (int i = 0; i < line.length; i++) {
            if (line[i] == ':') {
                if (tagLevel == 0) {
                    parts.add(currentPart);
                    currentPart = '';
                    continue;
                }
            } else if (line[i] == '[') {
                tagLevel++;
            } else if (line [i] == ']') {
                tagLevel--;
            }

            currentPart += line[i];
        }

        parts.add(currentPart);

        return parts.sublist(1);
    }
}