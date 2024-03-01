library path;

export 'src/path/posix_path.dart' if(Platform.isWindows) 'src/path/windows_path.dart';
export 'src/path/posix_path_buf.dart' if(Platform.isWindows) 'src/path/windows_path_buf.dart';