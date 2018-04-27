import 'package:pfl/PflProgram.dart';
import 'package:pfl/parser.dart';

import 'dart:io';

main(List<String> arguments) {
    print('Procedural Footnote Language Interpreter');
    print('[Version 1.0.0] - (c) Radu Vasilescu, 2018.');
    print('');

    if (arguments.length < 1) {
        print('Invalid command. Syntax: dart bin/main.dart filename.pfl');
        print('');
        exit(1);
    }

    String sourceFilePath = arguments[0];
    Uri sourceFileUri = new Uri.file(sourceFilePath);
    File sourceFile = new File.fromUri(sourceFileUri);

    List<String> fullSource = sourceFile.readAsLinesSync();

    PflProgram program = new PflProgram.fromSourceLines(fullSource);

    // Reads the body and footnote sections, prepares for parsing
    program.parseDocumentStructure();

    // Parse the program
    Parser parser = new Parser(program);
    parser.parseToTree();

    parser.resolveDelimiters();

    // Evaluate the body
    String evaluatedBody = parser.bodyElement.evaluate();

    // Output the result
    print(evaluatedBody);
}