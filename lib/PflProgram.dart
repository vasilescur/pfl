import 'package:pfl/errors.dart';

class PflProgram {
    static const String pflVersion = '1.0';

    List<String> fullSource;

    String body;
    List<String> footnotes;

    PflProgram.fromSourceLines(this.fullSource);

    void parseDocumentStructure() {
        body = "";
        footnotes = new List<String>();

        bool reachedFootnoteOpening = false;

        for (int i = 0; i < fullSource.length; i++) {
            var line = fullSource[i];

            // Is this a footnote opening/closing tag line?
            if (line == '[PFL$pflVersion]') {
                reachedFootnoteOpening = true;
            } else if (line == '[PFLEND]') {
                return;
            }

            if (!reachedFootnoteOpening) {
                body += '$line\n';
            } else {
                if (line != "[PFL$pflVersion]") {
                    footnotes.add(line);
                }
            }
        }

        // End of document.
        // If we got here, we missed either an opening or closing tag!
        if (reachedFootnoteOpening) {
            // Missing ending tag.
            throw new NoPflEndMarker();
        } else {    // Missing opening tag
            throw new NotAPflDocument();
        }
    }
}