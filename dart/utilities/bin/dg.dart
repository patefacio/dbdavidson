#!/usr/bin/env dart

/// Dart grep.
///
/// Grep a dart package with awareness for imported packages versus local code.
///
import 'dart:io';
import 'package:args/args.dart';
import 'package:ebisu/ebisu.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:quiver/iterables.dart';

// custom <additional imports>

import 'dart:convert';

// end <additional imports>
//! The parser for this script
ArgParser _parser;
//! The comment and usage associated with this script
void _usage() {
  print(r'''
Dart grep.

Grep a dart package with awareness for imported packages versus local code.

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
    _parser.addFlag('exclude-packages',
        help: r'''
If true does not look in packages
''',
        abbr: null,
        defaultsTo: false);
    _parser.addFlag('exclude-local',
        help: r'''
If true looks in packages only
''',
        abbr: null,
        defaultsTo: false);
    _parser.addFlag('help',
        help: r'''
Display this help screen
''',
        abbr: 'h',
        defaultsTo: false);

    _parser.addOption('project-path',
        help: r'''
Path to dart project, if not set looks from current path
''',
        defaultsTo: null,
        allowMultiple: false,
        abbr: 'p',
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
    result['project-path'] = argResults['project-path'];
    result['exclude-packages'] = argResults['exclude-packages'];
    result['exclude-local'] = argResults['exclude-local'];
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

final _logger = new Logger('dg');

main(List<String> args) {
  Logger.root.onRecord.listen(
      (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.OFF;
  Map argResults = _parseArgs(args);
  Map options = argResults['options'];
  List positionals = argResults['rest'];
  // custom <dg main>

  _projectPath(p) => p == '/'
      ? null
      : (new File(join(p, 'pubspec.yaml')).existsSync() &&
              new Directory(join(p, 'packages')).existsSync())
          ? p
          : _projectPath(dirname(p));

  final projectPath =
      _projectPath(options['project-path'] ?? Directory.current.path);

  if (projectPath == null) throw 'not a valid project';

  files(p) => p is File
      ? [p.path]
      : (concat(p.listSync().where((p) {
          final bname = basename(p.path);
          return bname != 'packages' && !bname.startsWith('.');
        }).map(files)));

  final packagesPath = new Directory(join(projectPath, 'packages'));
  final allFiles = concat([
    options['exclude-packages']? [] : files(packagesPath),
    options['exclude-local']? [] : files(new Directory(projectPath))
  ]);

  final commandArgs = concat([['grep', '-s', '-n', '-E'], positionals]).toList();

  Process
    .start('xargs', commandArgs)
      .then((Process process) {
        stderr.addStream(process.stderr);
        process.stdout
        .transform(new Utf8Decoder())
        .transform(new LineSplitter())
        .listen((String line) {
          print(line);
        });

        allFiles.forEach((f) => process.stdin.write('$f\n'));
        process.stdin.close();
        process.exitCode.then((var exitCode) => null);
      });

  // end <dg main>
}

// custom <dg global>
// end <dg global>
