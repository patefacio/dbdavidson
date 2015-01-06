#!/usr/bin/env dart
/// Script to run a D file.
///
/// This script will run _rdmd_ on the specified file. _rdmd_ itself wraps _dmd_.
///

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';

//! The parser for this script
ArgParser _parser;

//! The comment and usage associated with this script
void _usage() {
  print('''
Script to run a D file.

This script will run _rdmd_ on the specified file. _rdmd_ itself wraps _dmd_.

''');
  print(_parser.getUsage());
}

//! Method to parse command line options.
//! The result is a map containing all options, including positional options
Map _parseArgs(List<String> args) {
  ArgResults argResults;
  Map result = { };
  List remaining = [];

  _parser = new ArgParser();
  try {
    /// Fill in expectations of the parser
    _parser.addFlag('help',
      help: '''
Display this help screen
''',
      abbr: 'h',
      defaultsTo: false
    );

    /// Parse the command line options (excluding the script)
    argResults = _parser.parse(args);
    if(argResults.wasParsed('help')) {
      _usage();
      exit(0);
    }
    result['help'] = argResults['help'];
    // Pull out positional args as they were named
    remaining = new List.from(argResults.rest);
    if(0 >= remaining.length) {
      throw new
        ArgumentError('Positional argument d-file (position 0) not available - not enough args');
    }
    result['d-file'] = remaining.removeAt(0);

    return { 'options': result, 'rest': remaining };

  } catch(e) {
    _usage();
    throw e;
  }
}

final _logger = new Logger('runD');

main(List<String> args) {
  Logger.root.onRecord.listen((LogRecord r) =>
      print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.INFO;
  Map argResults = _parseArgs(args);
  Map options = argResults['options'];
  List positionals = argResults['rest'];

  // custom <runD main>
  // end <runD main>

}

// custom <runD global>
// end <runD global>

