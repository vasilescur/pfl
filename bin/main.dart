import 'package:pfl/pfl.dart';

import 'dart:io';

main(List<String> arguments) {
    print('Procedural Footnote Language Interpreter');
    print('[Version 0.0.1] - (c) Radu Vasilescu, 2018.');
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

    program.parseDocumentStructure();
}