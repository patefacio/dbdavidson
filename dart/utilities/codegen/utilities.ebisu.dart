import "dart:io";
import "dart:convert";
import "package:path/path.dart" as path;
import "package:ebisu/ebisu.dart";
import "package:id/id.dart";
import "package:ebisu/ebisu_dart_meta.dart";

String _topDir = 
  path.dirname(
    path.dirname(
      path.absolute(Platform.script.path)));

main() {
  String scriptName = 'run_dart';
  System utilities = system('utilities')
    ..rootPath = _topDir
    ..pubSpec = (pubspec('utilities')
        ..dependencies = [
          pubdep('pathos'),
          pubdep('args'),
          pubdep('ebisu')
          ..path = ebisuPath
        ]
    )
    ..scripts = [
      script(scriptName)
      ..doc = '''
Script to run a dart file. 

By default it invokes dart with --checked flag.

Additionally, it filters all stderr through a processor that changes the
_package:_ call stack entries with their equivalent _file:_ entries. This allows
for easy navigation from emacs, (although the same effect could have probably
been done with a better regular expression matcher on errors). Currently the
_DartEditor_ does not have good support for jump to error.

USAGE: ${scriptName} [ options ... ] DART_FILE

'''
      ..imports = [ 
        'async', 
        'io',
        'convert',
        '"package:path/path.dart" as PATH',
      ]
      ..args = [
        scriptArg('dart_file')
        ..doc = 'Dart file to run'
        ..position = 0,
        scriptArg('checked')
        ..doc = 'Run in checked mode - the default'
        ..defaultsTo = 'true'
        ..isFlag = true,
      ],
      script('run_d')
      ..doc = '''
Script to run a D file.

This script will run _rdmd_ on the specified file. _rdmd_ itself wraps _dmd_.
'''
      ..imports = [
        'convert'
      ]
      ..args = [
        scriptArg('d_file')
        ..doc = 'D file to run'
        ..position = 0,
      ]
      ,
      script('unit_test_dart'),
      script('unit_test_d'),
      script('git_summary')
      ..imports = [
        'package:path/path.dart',
        'package:plus/paths.dart'
      ],
      script('xgrep')
      ..doc = '''
Grep type function that allows find/grep and/or locate/grep on multiple
directories with ability to configure new commonly repeated searches via config
file.
'''
      ..args = [
        scriptArg('search_path')
        ..doc = 'Path(s) to search'
        ..isMultiple = true
        ..abbr = 'p',
        scriptArg('search_regex')
        ..doc = 'Regex to match in search'
        ..isMultiple = true
        ..abbr = 'r',
        scriptArg('search_string')
        ..doc = 'Basic string to match in search - if multiple provided, or logic assumed'
        ..isMultiple = true,
        scriptArg('file_type')
        ..doc = 'Type of file to look at'
        ..isMultiple = true,
        scriptArg('file_type_ignore')
        ..doc = 'Type of file to skip in search'
        ..isMultiple = true,
        scriptArg('intersect')
        ..doc = '''Set to true if *All* /search_regex/ and /search_string/ must match per
line. False value implies *any* match is a hit (i.e. *or* a.k.a. *union*)'''
        ..isFlag = true
        ..defaultsTo = false
      ]
      ,
    ]
    ..libraries = [
    ];

  utilities.generate();
}

