library path;

export 'src/path/posix_path.dart' if(Platform.isWindows) 'src/path/windows_path.dart';
export 'src/path/io_error.dart';