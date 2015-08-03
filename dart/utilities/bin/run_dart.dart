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
    final dartPath = '/usr/lib/dart/lib';
    final dartProgram = args[i];
    final dartArgs = args.sublist(0, i);
    String packagesPath = join(dirname(dartProgram), 'packages');
    final programArgs = args.sublist(i+1);

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

    final subArgs = ['--checked']
      ..addAll(dartArgs)
      ..add(dartProgram)
      ..addAll(programArgs);

    _logger.info('Running: '
        '${Platform.executable} ${dartArgs.join(" ")} ${subArgs.join(" ")}');

    var linesProcessed = 0;

    await Process.start(Platform.executable, subArgs)
      .then((Process process) async {

        stdout.addStream(process.stdout);

        var lineStream = process
        .stderr
        .transform(new Utf8Decoder())
        .transform(new LineSplitter());

        await for (var line in lineStream) {
          print(transformLine(line, packagesPath, dartPath));
          linesProcessed++;
        }

        await process.exitCode.then((int exitCode) {
          print('''
----------------------------------------------------------------------
Completed lines($linesProcessed) rc($exitCode)
''');
        });
      });
  }
}


final _samples = [
  '#0      Logger.level= (package:logging/logging.dart:96:24)',
  "'file:///home/dbdavidson/tmp/abstract.dart': error: line 5 pos 1: unexpected token 'fdsafjlk'",
  "#0      main (file:///home/dbdavidson/tmp/abstract.dart:7:3)"
];

final _stackDartLineRe = new RegExp(r'(.+\.dart):(\d+)(?::(\d+))?(.*)');
final _compilerErrorLineRe = new RegExp(r"'(.+)': error: line (\d+) pos (\d+)");

String transformLine(String originalLine, String packagesPath, String dartPath) {
  try {
    String updated = originalLine;
    var match = _stackDartLineRe.firstMatch(originalLine);
    if(match != null) {
      var fname = match[1];
      fname = fname.replaceAll('package:', 'file://$packagesPath/');
      fname = fname.replaceAll('dart:', '$dartPath/');
      fname = fname.replaceAll('(/', '(file://');
      var line = match[2];
      var column = match[3];
      final trailing = match[4];
      if(column==null) line = 1;
      final pre = originalLine.substring(0, match.start);
      updated = '$pre$fname:$line:$column$trailing';
    } else if((match = _compilerErrorLineRe.firstMatch(originalLine)) != null) {
      var fname = match[1];
      var line = match[2];
      var column = match[3];
      final pre = originalLine.substring(0, match.start);
      final post = originalLine.substring(match.end);
      updated = '($pre$fname:$line:$column)$post';
    }

    return 'STDERR:$updated';
  } catch(e) {
    print('run_dart Caught: $e');
    throw e;
  }
}
