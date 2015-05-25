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

  useDartFormatter = true;
  
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
        'package:ebisu/ebisu.dart',
        'package:path/path.dart',
        'package:quiver/iterables.dart',
      ]
      ..args = [
        scriptArg('filename')
        ..doc = 'The file to compile and run'
        ..isRequired = true
        ..abbr = 'f',
        scriptArg('compile_arg')
        ..doc = 'Arg passed to compiler'
        ..abbr = 'c'
        ..isRequired = false
        ..isMultiple = true,
        scriptArg('link_arg')
        ..doc = 'Arg passed to linker'
        ..abbr = 'l'
        ..isRequired = false        
        ..isMultiple = true,

      ]
      ..enums = [

        enum_('common_lib')
        ..doc = 'Some commonly used libs to pull in if necessary'
        ..hasLibraryScopedValues = true        
        ..values = [ 'boost_regex', 'boost_filesystem', 'boost_system' ],
        enum_('common_include')
        ..doc = 'Some commonly used packages to pull in if necessary'        
        ..hasLibraryScopedValues = true
        ..values = [ 'boost', 'catch_test', ],
      ]
      ..classes = [

        class_('locator')
        ..doc = 'Tries to find any required libs/headers'
        ..members = [
          member('includes')
          ..type = 'List<String>'..classInit = [],
          member('required_libs')
          ..type = 'Set<String>'..type = 'Set'..classInit = 'new Set()',
          member('include_paths')
          ..type = 'Set<String>'..type = 'Set'..classInit = 'new Set()',          
          member('lib_paths')
          ..type = 'Set<String>'..type = 'Set'..classInit = 'new Set()',          
          member('libs')
          ..type = 'Set<String>'..type = 'Set'..classInit = 'new Set()',
        ],
        
        class_('builder')
        ..doc = 'Tries to build the file'        
        ..members = [
          member('filename')..doc = 'File to compile',
          member('includes')
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
