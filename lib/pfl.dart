class PflProgram {
    List<String> fullSource;

    String body;
    String footnotes;

    

    PflProgram.fromSourceLines(this.fullSource);

    void parseDocumentStructure() {
        bool reachedFootnoteOpening = false;

        for (int i = 0; i < fullSource.length; i++) {
            var line = fullSource[i];

            // Is this a footnote opening/closing tag line?
            if (line == '[PFL1.0]') {
                reachedFootnoteOpening = true;
            } else if (line == '[PFLEND]') {
                return;
            }
        }

        // If we got here, we missed either an opening or closing tag!
        if (reachedFootnoteOpening) {
            // Missing ending tag.
            
        }
        
    }

    void execute() {
        // TODO
        throw new UnimplementedError();
    }
}