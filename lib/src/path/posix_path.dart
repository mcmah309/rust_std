import 'package:path/path.dart' as p;
import 'package:rust_std/option.dart';
import 'package:universal_io/io.dart';

import 'utils.dart';

extension type Path._(String path) implements Object {

    Path(this.path): assert(!path.contains("\\"), "Path must be either posix style");
// ancestors
    // Iterable<Path> ancestors() sync* {
    //     var current = this;
    //     while (current != current.parent()) {
    //         yield current;
    //         current = current.parent();
    //     }
    // }
// as_mut_os_str : will not be implemented
// as_os_str : will not be implemented
Path canonicalize() => Path(p.canonicalize(path));
// components
// display
// ends_with
bool exists() => FileSystemEntity.typeSync(path, followLinks: true) != FileSystemEntityType.notFound;

String extension() => p.extension(path);

String fileName() => p.basename(path);

/// Extracts the portion of the file name before the first "." -
/// 
/// None, if there is no file name;
/// The entire file name if there is no embedded .;
/// The portion of the file name before the first non-beginning .;
/// The entire file name if the file name begins with . and has no other .s within;
/// The portion of the file name before the second . if the file name begins with .
Option<String> filePrefix() {
    if(path.endsWith("/")){
        return None();
    }
    if(!path.contains(".")){
        return Some(path);
    }
    if(path.startsWith(".")){
        final splits = path.split(".");
        if(splits.length == 2){
        return Some(path);
        }
        else {
            assert(splits.length > 2);
            return Some(splits[1]);
        }
    }
    return Some(path.split(".").first);
}

/// Extracts the portion of the file name before the last "." -
///
/// None, if there is no file name;
/// The entire file name if there is no embedded .;
/// The entire file name if the file name begins with . and has no other .s within;
/// Otherwise, the portion of the file name before the final .
Option<String> fileStem() {
    if(path.endsWith("/")){
        return None();
    }
    if(!path.contains(".")){
        return Some(path);
    }
    if(path.startsWith(".")){
        final splits = path.split(".");
        if(splits.length == 2){
        return Some(path);
        }
        else {
            assert(splits.length > 2);
            return Some(splits[1]);
        }
    }
    return Some(p.basenameWithoutExtension(path));
}

// has_root
// into_path_buf
// is_absolute
// is_dir
// is_file
// is_relative
// is_symlink
// iter
// join
// metadata
// new : will not be implemented
Option<Path> parent() {
    if(!path.contains("/")){
        return None();
    }
    int index;
    if(path.endsWith("/")){
        index = 2;
    }
    else {
        index = 1;
    }
    final splits = splitWithoutRemoving("/", path);
    final end = splits.length - index;
    if(end == 0){
        return None();
    }
    return Some(Path(splits.sublist(0, end).join()));
}
// read_dir
// read_link
// starts_with
// strip_prefix
// symlink_metadata
// to_path_buf
// to_str
// to_string_lossy
// try_exists
// with_extension
// with_file_name
// Trait Implementations
// AsRef<OsStr>
// AsRef<Path>
}