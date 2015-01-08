#!/usr/bin/env dart
/// Script to run a dart file. 
///
/// By default it invokes dart with --checked flag.
///
/// Additionally, it filters all stderr through a processor that changes the
/// _package:_ call stack entries with their equivalent _file:_ entries. This allows
/// for easy navigation from emacs, (although the same effect could have probably
/// been done with a better regular expression matcher on errors). Currently the
/// _DartEditor_ does not have good support for jump to error.
///
/// USAGE: run_dart [ options ... ] DART_FILE
///
///

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as PATH;

//! The parser for this script
ArgParser _parser;

//! The comment and usage associated with this script
void _usage() {
  print('''
Script to run a dart file. 

By default it invokes dart with --checked flag.

Additionally, it filters all stderr through a processor that changes the
_package:_ call stack entries with their equivalent _file:_ entries. This allows
for easy navigation from emacs, (although the same effect could have probably
been done with a better regular expression matcher on errors). Currently the
_DartEditor_ does not have good support for jump to error.

USAGE: run_dart [ options ... ] DART_FILE


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
    _parser.addFlag('checked',
      help: '''
Run in checked mode - the default
''',
      abbr: null,
      defaultsTo: true
    );
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
    result['checked'] = argResults['checked'];
    result['help'] = argResults['help'];
    // Pull out positional args as they were named
    remaining = new List.from(argResults.rest);
    if(0 >= remaining.length) {
      throw new
        ArgumentError('Positional argument dart-file (position 0) not available - not enough args');
    }
    result['dart-file'] = remaining.removeAt(0);

    return { 'options': result, 'rest': remaining };

  } catch(e) {
    _usage();
    throw e;
  }
}

final _logger = new Logger('runDart');

main(List<String> args) {
  Logger.root.onRecord.listen((LogRecord r) =>
      print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.INFO;
  Map argResults = _parseArgs(args);
  Map options = argResults['options'];
  List positionals = argResults['rest'];

  // custom <runDart main>

  RegExp packageRe = new RegExp(r"#\d+.*\(package:[^)]+\)");
  String dartFilePath = options['dart-file'];
  File dartFile = new File(dartFilePath);
  if(!dartFile.existsSync()) {
    print("The file ${dartFilePath} does not exist");
    _usage();
    exit(-1);
  }

  String packagesPath = PATH.join(PATH.dirname(dartFilePath), 'packages');
  bool packagesPathExist =
    (new Directory(packagesPath.toString())).existsSync();
  List procArgs = [ dartFilePath ];

  // See if folder containing dartFilePath has 'packages' folder.
  // If not and DEFAULT_DART_PACKAGES env var exists, pass that
  String defaultDartPackages = Platform.environment['DEFAULT_DART_PACKAGES'];
  if(defaultDartPackages != null && !packagesPathExist) {
    _logger.info("Default Dart packages env var set ${defaultDartPackages}");

    if((new Directory(defaultDartPackages.toString()).existsSync())) {
      _logger.info("Using Default Dart Packages");
      procArgs.insert(0, '--package-root=${defaultDartPackages}');
      packagesPath = defaultDartPackages;
    } else {
      _logger.info("Default Dart Packages Not Exist: ${packagesPath}");
    }
  }

  if(options['checked']) {
    procArgs.insert(0, '--checked');
  }
  procArgs.insert(0, '--enable-async');
  procArgs.addAll(positionals);

  print("Running: dart ${procArgs.join(' ')}");
  var task = Process.run(Platform.executable, procArgs)
    .then((ProcessResult processResult) {

      print(processResult.stdout);

      if(processResult.stderr.length > 0) {
        stdout.write('STDERR| ');
        print(processResult
            .stderr
            .split('\n')
            .map((l) {
              Match m = packageRe.firstMatch(l);
              return (m != null)?
                m.group(0).replaceFirst("package:", "file://${packagesPath}/") : l;
            })
            .join('\nSTDERR| '));
      }

      if(processResult.exitCode != 0)
        print("ExitCode: ${processResult.exitCode}");

    });

  Future.wait([task])
    .then((_) {
      print("Done - closing streams");
      return Future.wait( [
        stdout.close(), stderr.close()
      ]).then((_) {
        exit(0);
      });
    });

  // end <runDart main>

}

// custom <runDart global>
// end <runDart global>

