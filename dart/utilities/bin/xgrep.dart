#!/usr/bin/env dart
/// Grep type function that allows find/grep and/or locate/grep on multiple
/// directories with ability to configure new commonly repeated searches via config
/// file.
///

import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';

//! The parser for this script
ArgParser _parser;

//! The comment and usage associated with this script
void _usage() {
  print('''
Grep type function that allows find/grep and/or locate/grep on multiple
directories with ability to configure new commonly repeated searches via config
file.

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
    _parser.addFlag('intersect',
      help: '''
Set to true if *All* /search_regex/ and /search_string/ must match per
line. False value implies *any* match is a hit (i.e. *or* a.k.a. *union*)
''',
      abbr: null,
      defaultsTo: false
    );
    _parser.addFlag('help',
      help: '''
Display this help screen
''',
      abbr: 'h',
      defaultsTo: false
    );

    _parser.addOption('search-path',
      help: '''
Path(s) to search
''',
      defaultsTo: null,
      allowMultiple: true,
      abbr: 'p',
      allowed: null
    );
    _parser.addOption('search-regex',
      help: '''
Regex to match in search
''',
      defaultsTo: null,
      allowMultiple: true,
      abbr: 'r',
      allowed: null
    );
    _parser.addOption('search-string',
      help: '''
Basic string to match in search - if multiple provided, or logic assumed
''',
      defaultsTo: null,
      allowMultiple: true,
      abbr: null,
      allowed: null
    );
    _parser.addOption('file-type',
      help: '''
Type of file to look at
''',
      defaultsTo: null,
      allowMultiple: true,
      abbr: null,
      allowed: null
    );
    _parser.addOption('file-type-ignore',
      help: '''
Type of file to skip in search
''',
      defaultsTo: null,
      allowMultiple: true,
      abbr: null,
      allowed: null
    );

    /// Parse the command line options (excluding the script)
    argResults = _parser.parse(args);
    if(argResults.wasParsed('help')) {
      _usage();
      exit(0);
    }
    result['search-path'] = argResults['search-path'];
    result['search-regex'] = argResults['search-regex'];
    result['search-string'] = argResults['search-string'];
    result['file-type'] = argResults['file-type'];
    result['file-type-ignore'] = argResults['file-type-ignore'];
    result['intersect'] = argResults['intersect'] != null?
      bool.parse(argResults['intersect']) : null;
    result['help'] = argResults['help'];

    return { 'options': result, 'rest': remaining };

  } catch(e) {
    _usage();
    throw e;
  }
}

final _logger = new Logger('xgrep');

main(List<String> args) {
  Logger.root.onRecord.listen((LogRecord r) =>
      print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.INFO;
  Map argResults = _parseArgs(args);
  Map options = argResults['options'];
  List positionals = argResults['rest'];

  // custom <xgrep main>
  // end <xgrep main>

}

// custom <xgrep global>
// end <xgrep global>

