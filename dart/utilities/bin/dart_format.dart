#!/usr/bin/env dart

/// Backup and then format dart code
import 'dart:io';
import 'package:args/args.dart';
import 'package:ebisu/ebisu.dart';
import 'package:logging/logging.dart';

// custom <additional imports>
// end <additional imports>
//! The parser for this script
ArgParser _parser;
//! The comment and usage associated with this script
void _usage() {
  print(r'''
Backup and then format dart code
''');
  print(_parser.getUsage());
}

//! Method to parse command line options.
//! The result is a map containing all options, including positional options
Map _parseArgs(List<String> args) {
  ArgResults argResults;
  Map result = {};
  List remaining = [];

  _parser = new ArgParser();
  try {
    /// Fill in expectations of the parser
    _parser.addFlag('help',
        help: r'''
Display this help screen
''',
        abbr: 'h',
        defaultsTo: false);

    _parser.addOption('filename',
        help: r'''
File to format
''',
        defaultsTo: null,
        allowMultiple: false,
        abbr: 'f',
        allowed: null);
    _parser.addOption('log-level',
        help: r'''
Select log level from:
[ all, config, fine, finer, finest, info, levels,
  off, severe, shout, warning ]

''',
        defaultsTo: null,
        allowMultiple: false,
        abbr: null,
        allowed: null);

    /// Parse the command line options (excluding the script)
    argResults = _parser.parse(args);
    if (argResults.wasParsed('help')) {
      _usage();
      exit(0);
    }
    result['filename'] = argResults['filename'];
    result['help'] = argResults['help'];
    result['log-level'] = argResults['log-level'];

    if (result['log-level'] != null) {
      const choices = const {
        'all': Level.ALL,
        'config': Level.CONFIG,
        'fine': Level.FINE,
        'finer': Level.FINER,
        'finest': Level.FINEST,
        'info': Level.INFO,
        'levels': Level.LEVELS,
        'off': Level.OFF,
        'severe': Level.SEVERE,
        'shout': Level.SHOUT,
        'warning': Level.WARNING
      };
      final selection = choices[result['log-level'].toLowerCase()];
      if (selection != null) Logger.root.level = selection;
    }

    return {'options': result, 'rest': argResults.rest};
  } catch (e) {
    _usage();
    throw e;
  }
}

final _logger = new Logger('dartFormat');
main(List<String> args) {
  Logger.root.onRecord.listen(
      (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.OFF;
  Map argResults = _parseArgs(args);
  Map options = argResults['options'];
  List positionals = argResults['rest'];
  try {
    if (options["filename"] ==
        null) throw new ArgumentError("option: filename is required");
  } on ArgumentError catch (e) {
    print(e);
    _usage();
    exit(-1);
  }
  // custom <dartFormat main>

  final sourceFile = new File(options['filename']);
  final backupFile = options['filename'] + '~';
  final sourceText = sourceFile.readAsStringSync();
  final formatted = dartFormat(sourceText);

  sourceFile.copySync(backupFile);
  sourceFile.writeAsStringSync(formatted);

  if (formatted != sourceText) {
    print('Wrote: $sourceFile');
  } else {
    print('No format change: $sourceFile with guts\n$sourceText');
  }

  // end <dartFormat main>
}

// custom <dartFormat global>
// end <dartFormat global>
