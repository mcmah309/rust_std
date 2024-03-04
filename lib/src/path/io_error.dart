import 'package:rust_std/path.dart';

class IoError implements Exception {
  final IoErrorType type;
  final Path? path;
  final Object? error;

  IoError(this.type, {this.path, this.error});

  @override
  String toString() {
    final additional = "${path != null ? "\nPath: '$path'": ""}${error != null ? "\nError: '$error'" : ""}";
    return switch(type){
      IoErrorType.notADirectory => "The path is not a directory.$additional",
      IoErrorType.notAFile => "The path is not a file.$additional",
      IoErrorType.notAlink => "The path is not a link.$additional",
      IoErrorType.notAValidPath => "The path is not a valid path.$additional",
      IoErrorType.unknown => "An unknown error occurred.$additional",
    };
  }
}

enum IoErrorType {
  notADirectory,
  notAFile,
  notAlink,
  notAValidPath,
  unknown,
}