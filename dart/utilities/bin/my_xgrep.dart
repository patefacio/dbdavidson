#!/usr/bin/env dart
/// Place to flesh out my searching need
import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:id/id.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:xgrep/xgrep.dart';

//! The parser for this script
ArgParser _parser;
//! The comment and usage associated with this script
void _usage() {
  print(r'''
Place to flesh out my searching need
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
    _parser.addFlag('help', help: r'''
Display this help screen
''', abbr: 'h', defaultsTo: false);

    _parser.addOption('log-level', help: r'''
Select log level from:
[ all, config, fine, finer, finest, info, levels,
  off, severe, shout, warning ]

''', defaultsTo: null, allowMultiple: false, abbr: null, allowed: null);

    /// Parse the command line options (excluding the script)
    argResults = _parser.parse(args);
    if (argResults.wasParsed('help')) {
      _usage();
      exit(0);
    }
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
final _logger = new Logger('myXgrep');
main(List<String> args) async {
  Logger.root.onRecord.listen(
      (LogRecord r) => print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.OFF;
  Map argResults = _parseArgs(args);
  Map options = argResults['options'];
  List positionals = argResults['rest'];
  // custom <myXgrep main>

  final home = Platform.environment['HOME'];
  final oss = join(home, 'dev', 'open_source');
  await Indexer.withIndexer((Indexer indexer) async {
    await indexer.removeAllItems();

    final indices = [];

    gitPrune(p) => new PruneSpec([], [join(p, '.git')]);

    dartPrune(p) =>
        new PruneSpec(['.pub'], [join(p, '.git'), join(p, 'cache')]);
    indices.add(new Index.withPruning(idFromString('dm'), dartMine
        .map((p) => join(oss, p))
        .fold({}, (p, e) => p..[e] = dartPrune(e))));

    indices.add(new Index.withPruning(idFromString('ds'), {
      '/usr/lib/dart/lib': new PruneSpec(['core_stubs'], [])
    }));

    cppPrune(p) => new PruneSpec([], [join(p, '.git')]);
    indices.add(new Index.withPruning(idFromString('cm'), cppMine
        .map((p) => join(oss, p))
        .fold({}, (p, e) => p..[e] = cppPrune(e))));

    indices.add(new Index(idFromString('cb'), ['/usr/include/boost']));

    indices.add(new Index(idFromString('tbb'), [
      '/home/dbdavidson/dev/open_source/tbb44_20150728oss'
    ]));

    indices.add(new Index.withPruning(idFromString('cpp_ebisu'), {
      join(oss, 'cpp_ebisu'): new PruneSpec(
          [], [join(oss, 'cpp_ebisu', 'cmake_build'), join(oss, 'cpp_ebisu', 'doc'),])
    }));

    indices.add(new Index.withPruning(idFromString('hist'), {
      join(oss, 'codegen'): gitPrune(join(oss, 'codegen'))
    }));

    indices.add(new Index.withPruning(idFromString('thrift'), {
      join(oss, 'thrift'): gitPrune(join(oss, 'codegen'))
    }));

    indices.add(new Index(idFromString('org'), [join(home, 'orgfiles')]));

    indices.add(new Index(idFromString('plus'), [join(oss, 'plusauri')]));

    indices.add(new Index(idFromString('tins'), [join(oss, 'libtins')]));

    for (final index in indices) {
      await indexer.saveAndUpdateIndex(index);
    }

    final filters = [];
    filters.add(new Filter(idFromString('dart'), true, [r'\.dart$']));

    filters.add(
        new Filter(idFromString('web'), true, [r'\.(?:dart|html|js|ts)$']));

    filters.add(
        new Filter(idFromString('cpp'), true, [r'\.(?:hpp|cpp|c|h|inl|cxx)$']));

    filters.add(new Filter(idFromString('xjs'), false, [r'\.js$']));

    filters.add(new Filter(idFromString('ignore'), false, [
      r'~$',
      r'/pubspec.lock',
      r'/.gitignore\b'
    ]));

    filters.add(new Filter(
        idFromString('rb'), true, [r'\.rb$', r'\.spec$', r'\.gemspec']));

    filters.add(new Filter(idFromString('java'), true, [r'\.java$']));

    for (final filter in filters) {
      await indexer.persistFilter(filter);
    }
  }).catchError((e) => print('Caught Error $e'));

  // end <myXgrep main>

}

// custom <myXgrep global>

final dartMine = const [
  'ebisu',
  'ebisu_cpp',
  'ebisu_cpp_db',
  'ebisu_capnp',
  'ebisu_dlang',
  'ebisu_web_ui',
  'id',
  'json_schema',
  'magus',
  'xgrep',
  'plusauri',
  'simple_schema',
];

final cppMine = const ['cpp_ebisu',];

// end <myXgrep global>
