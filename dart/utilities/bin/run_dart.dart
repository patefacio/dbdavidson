#!/usr/bin/env dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:quiver/iterables.dart';

final _logger = new Logger('runDart');

main(List<String> args) async {
  Logger.root.onRecord.listen((LogRecord r) =>
      print("${r.loggerName} [${r.level}]:\t${r.message}"));
  Logger.root.level = Level.INFO;

  /// iterate over args and find first arg that is a file:
  int i=0;
  for(; i<args.length; i++) {
    final arg = args[i];
    if(!arg.startsWith('-') && FileSystemEntity.isFileSync(arg)) break;
  }

  if(i==args.length) {
    print('Error: run_dart.dart must specify a file to run: $args');
    exit(-1);
  } else {
    print(args);
    final dartArgs = args.sublist(0, i);
    final dartProgram = args[i];
    final programArgs = args.sublist(i+1);

    String packagesPath = join(dirname(dartProgram), 'packages');
    bool packagesPathExist = FileSystemEntity.isDirectorySync(packagesPath);

    // See if folder containing dartFilePath has 'packages' folder.
    // If not and DEFAULT_DART_PACKAGES env var exists, pass that
    String defaultDartPackages = Platform.environment['DEFAULT_DART_PACKAGES'];
    _logger.info("Default Dart packages env var set ${defaultDartPackages}");
    if(defaultDartPackages != null && !packagesPathExist) {
      _logger.info("Default Dart packages env var set ${defaultDartPackages}");

      if(FileSystemEntity.isDirectorySync(defaultDartPackages)) {
        _logger.info("Using Default Dart Packages");
        dartArgs.insert(0, '--package-root=${defaultDartPackages}');
        packagesPath = defaultDartPackages;
      } else {
        _logger.info("Default Dart Packages Not Exist: ${packagesPath}");
      }
    }

    final subArgs = []
      ..addAll(dartArgs)
      ..add(dartProgram)
      ..addAll(programArgs);

    _logger.info('Running: '
        '${Platform.executable} ${dartArgs.join(" ")} ${subArgs.join(" ")}');

    final _packageFileRe = new RegExp(r"'package:([^']+)':(?:.*line (\d+))?(?:.*pos (\d+))?");
    final _lineColumRe = new RegExp('line (\d+) pos (\d+)');

    await Process.start(Platform.executable, subArgs)
      .then((Process process) async {

        stdout.addStream(process.stdout);

        var lineStream = process
        .stderr
        .transform(new Utf8Decoder())
        .transform(new LineSplitter());

        await for (var line in lineStream) {
          final updated = line.replaceAllMapped(_packageFileRe,
              (var match) {
            var line = match[2];
            var column = match[3];

            _logger.info('Line is $line column is $column');

            if(line == null) line = 1;
            if(column == null) column = 1;

            return "file://${packagesPath}/${match[1]}:$line:$column";
          });
          print(updated);
        }

        await process.exitCode.then((int exitCode) {
          print('''
----------------------------------------------------------------------
Completed ($exitCode)
''');
        });
      });
  }
}
