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
      script('my_xgrep')
      ..isAsync = true
      ..doc = 'Place to flesh out my searching need'
      ..imports = [
        'package:id/id.dart',
        'package:xgrep/xgrep.dart',
        'package:path/path.dart',
        'async',
        'io',
      ]
    ]
    ..libraries = [
    ];

  utilities.generate();
}
