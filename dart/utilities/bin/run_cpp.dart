#!/usr/bin/env dart

/// Compile the specified C++ file and run it
import 'dart:io';
import 'package:args/args.dart';
import 'package:ebisu/ebisu.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:quiver/iterables.dart';

// custom <additional imports>
// end <additional imports>
//! The parser for this script
ArgParser _parser;
//! The comment and usage associated with this script
void _usage() {
  print(r'''
Compile the specified C++ file and run it
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
The file to compile and run
''',
        defaultsTo: null,
        allowMultiple: false,
        abbr: 'f',
        allowed: null);
    _parser.addOption('compile-arg',
        help: r'''
Arg passed to compiler
''',
        defaultsTo: null,
        allowMultiple: true,
        abbr: 'c',
        allowed: null);
    _parser.addOption('link-arg',
        help: r'''
Arg passed to linker
''',
        defaultsTo: null,
        allowMultiple: true,
        abbr: 'l',
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
    result['compile-arg'] = argResults['compile-arg'];
    result['link-arg'] = argResults['link-arg'];
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

final _logger = new Logger('runCpp');

/// Some commonly used libs to pull in if necessary
enum CommonLib { boostRegex, boostFilesystem, boostSystem }

/// Convenient access to CommonLib.boostRegex with *boostRegex* see [CommonLib].
///
const CommonLib boostRegex = CommonLib.boostRegex;

/// Convenient access to CommonLib.boostFilesystem with *boostFilesystem* see [CommonLib].
///
const CommonLib boostFilesystem = CommonLib.boostFilesystem;

/// Convenient access to CommonLib.boostSystem with *boostSystem* see [CommonLib].
///
const CommonLib boostSystem = CommonLib.boostSystem;

/// Some commonly used packages to pull in if necessary
enum CommonInclude { boost, catchTest }

/// Convenient access to CommonInclude.boost with *boost* see [CommonInclude].
///
const CommonInclude boost = CommonInclude.boost;

/// Convenient access to CommonInclude.catchTest with *catchTest* see [CommonInclude].
///
const CommonInclude catchTest = CommonInclude.catchTest;

/// Tries to find any required libs/headers
class Locator {
  List<String> includes = [];
  Set requiredLibs = new Set();
  Set includePaths = new Set();
  Set libPaths = new Set();
  Set libs = new Set();

  // custom <class Locator>

  static get _home => Platform.environment['HOME'];
  static final _boostIncludePath = '/usr/include/boost';
  static final _boostLibPath = '/usr/lib/x86_64-linux-gnu';
  static final _installPath = join(_home, 'install');
  static final _ebisuIncludePath = join(_home, 'dev/open_source/cpp_ebisu/cpp');
  static final _catchIncludePath = join(_installPath, 'cpp/include/catch');
  static final _spdlogIncludePath = join(_installPath, 'cpp/include/');
  static final _cppFormatInclude = join(_installPath, 'cpp/include/cppformat');

  _addBoost() {
    includePaths.add(_boostIncludePath);
    libPaths.add(_boostLibPath);
  }

  Locator(this.includes) {
    if (includes.any((i) => i.contains('boost/regex.hpp'))) {
      _addBoost();
      requiredLibs.add('boost_regex');
      requiredLibs.add('boost_system');
    }
    if(includes.any((i) => i.contains('boost/date_time'))) {
      requiredLibs.add('boost_date_time');
      requiredLibs.add('boost_system');
    }

    if(includes.any((i) => i.contains('msgpack.hpp'))) {
      requiredLibs.add('msgpack');
    }
    if (includes.any((i) => i.contains('dbclient.h'))) {
      requiredLibs.add('mongoclient');
      _addBoost();
      requiredLibs.add('libboost_system.so.1.55.0');
      libPaths.add('/usr/lib');
    }
    if (includes.any((i) => i.contains('ebisu'))) {
      includePaths.add(_ebisuIncludePath);
    }
    if (includes.any((i) => i.contains('catch.hpp'))) {
      includePaths.add(_catchIncludePath);
    }
    if (true || includes.any((i) => i.contains('spdlog.h'))) {
      includePaths.add(_spdlogIncludePath);
    }
  }

  get cppFlags => concat(
      [includePaths.map((i) => '-I$i'), requiredLibs.map((l) => '-l$l')]);

  // end <class Locator>

}

/// Tries to build the file
class Builder {
  /// File to compile
  String filename;

  /// Files included by filename
  List<String> includes = [];

  // custom <class Builder>

  static RegExp _includeRe = new RegExp(r'#include\s*[<"]([^>"]+)[>"]');
  Builder(this.filename) {
    final cppText = new File(filename).readAsStringSync();
    includes.addAll(_includeRe.allMatches(cppText).map((m) => m.group(1)));
    print('Includes $includes');
    final locator = new Locator(includes);

    final cppFlags = [
      '--std=c++11',
      '-I/home/dbdavidson/dev/open_source/brigand',
    ]..addAll(locator.cppFlags);
    final target = join(Locator._home, 'snippet');
    cppFlags.add(filename);
    cppFlags.addAll(['-o', target, '-lpthread']);
    cppFlags.addAll(locator.libPaths.map((l) => '-L$l'));

    print('Compiling: clang++ ${cppFlags.join(" ")}');

    Process.run('clang++', cppFlags).then((ProcessResult results) {
      print(results.stdout);
      print(results.stderr);
      print('Completed build: (${results.exitCode})');
      if (results.exitCode != 0) {
        exit(results.exitCode);
      }
    }).then((_) => Process.run(target, []).then((ProcessResult results) {
          print(
              '----------------------------------------------------------------------');
          print(results.stdout);
          print(results.stderr);
          exit(results.exitCode);
        }));
  }

  // end <class Builder>

}

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
  // custom <runCpp main>
  print('Compiling $options');

  final builder = new Builder(options['filename']);

  // end <runCpp main>
}

// custom <runCpp global>
// end <runCpp global>
