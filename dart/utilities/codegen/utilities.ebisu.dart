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

      script('run_cpp')
      ..doc = 'Compile the specified C++ file and run it'
      ..imports = [
        
      ]
      ..args = [
        scriptArg('filename')
        ..doc = 'The file to compile and run'
        ..abbr = 'f'
      ]
      ..classes = [
        class_('builder')
        ..members = [
          member('filename')..doc = 'File to compile',
          member('include')
          ..doc = 'Files included by filename'
          ..type = 'List<String>'..classInit = [],
        ]
      ],
      
      
      script('my_xgrep')
      ..isAsync = true
      ..doc = 'Place to flesh out my searching need'
      ..imports = [
        'package:id/id.dart',
        'package:xgrep/xgrep.dart',
        'package:path/path.dart',
        'async',
        'io',
      ],

      script('header_deps')
      ..doc = '''
In comes output from compiles with -H, out comes a dot file
'''
      ..imports = [
        'async',
        'io',
      ]
      ..classes = [
        class_('cpp_dependencies')
        ..doc = '''
Consumes a stream of compile statements with their header statements as output
with -H compile switch and determines transitive closure of dependencies
'''
        ..members = [
          member('input')
          ..doc = '''
Stream of input lines - will cull all lines that do not
look like output from compilation with -H switch
'''
          ..type = 'Stream'..ctors = [''],
        ]
      ]
    ]
    ..libraries = [
    ];

  utilities.generate();
}
