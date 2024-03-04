import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:rust_std/option.dart';
import 'package:rust_std/iter.dart';
import 'package:rust_std/result.dart';
import 'package:rust_std/src/path/io_error.dart';
import 'package:universal_io/io.dart' as io;

import 'utils.dart';

part 'posix_path_buf.dart';

/// An iterator over the entries within a directory.
typedef ReadDir = List<io.FileSystemEntity>;
typedef Metadata = io.FileStat;


extension type Path._(String path) implements Object {
  static final RegExp regularPathComponent = RegExp(r'^[.\w-]+(\.[\w-]+)*$');
  static final RegExp oneOrmoreSlashes = RegExp(r'/+');
  static final p.Context unix = p.Context(style: p.Style.posix);

  Path(this.path) : assert(_validate(path), "Path must be posix style");

  Iterable<Path> ancestors() sync* {
    yield this;
    Path? current = parent().toNullable();
    while (current != null) {
      yield current;
      current = current.parent().toNullable();
    }
  }

// as_mut_os_str : will not be implemented
// as_os_str : will not be implemented

  Path canonicalize() => Path(unix.canonicalize(path));

  Iterable<Component> components() sync* {
    bool removeLast;
    // trailing slash does not matter
    if (path.endsWith("/")) {
      if (path.length == 1) {
        yield RootDir();
        return;
      }
      removeLast = true;
    } else {
      removeLast = false;
    }
    final splits = path.split(oneOrmoreSlashes);
    if (removeLast) {
      splits.removeLast();
    }

    final iterator = splits.iterator;
    iterator.moveNext();
    var current = iterator.current;
    switch (current) {
      case "":
        yield RootDir();
        break;
      case ".":
        yield CurDir();
        break;
      case "..":
        yield ParentDir();
        break;
      default:
        if (regularPathComponent.hasMatch(current)) {
          yield Normal(current);
        } else {
          yield Prefix(current);
        }
    }
    while (iterator.moveNext()) {
      current = iterator.current;
      switch (current) {
        case ".":
          yield CurDir();
          break;
        case "..":
          yield ParentDir();
          break;
        default:
          yield Normal(current);
      }
    }
  }

  /// String representation of the path
  String display() => toString();

  /// Determines whether other is a suffix of this.
  bool endsWith(Path other) => path.endsWith(other.path);

  /// Determines whether other is a suffix of this.
  bool exists() =>
      io.FileSystemEntity.typeSync(path, followLinks: true) != io.FileSystemEntityType.notFound;

  /// Extracts the extension (without the leading dot) of self.file_name, if possible.
  String extension() => unix.extension(path);

  /// Returns the final component of the Path, if there is one.
  String fileName() => unix.basename(path);

  /// Extracts the portion of the file name before the first "." -
  ///
  /// None, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The portion of the file name before the first non-beginning .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// The portion of the file name before the second . if the file name begins with .
  Option<String> filePrefix() {
    final last = components().lastOrNull;
    if (last is! Normal) {
      return None;
    }
    final value = last.value;
    if (!value.contains(".")) {
      return Some(value);
    }
    if (value.startsWith(".")) {
      final splits = value.split(".");
      if (splits.length == 2) {
        return Some(value);
      } else {
        assert(splits.length > 2);
        return Some(splits[1]);
      }
    }
    return Some(value.split(".").first);
  }

  /// Extracts the portion of the file name before the last "." -
  ///
  /// None, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// Otherwise, the portion of the file name before the final .
  Option<String> fileStem() {
    if (path.endsWith("/")) {
      return None;
    }
    if (!path.contains(".")) {
      return Some(path);
    }
    if (path.startsWith(".")) {
      final splits = path.split(".");
      if (splits.length == 2) {
        return Some(path);
      } else {
        assert(splits.length > 2);
        return Some(splits[1]);
      }
    }
    return Some(unix.basenameWithoutExtension(path));
  }

  /// Returns true if the Path has a root.
  bool hasRoot() => unix.rootPrefix(path) == "/";

  // into_path_buf : will not be implemented, use `toPathBuf`

  /// Returns true if the Path is absolute, i.e., if it is independent of the current directory.
  bool isAbsolute() => unix.isAbsolute(path);

  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  bool isDir() => io.FileSystemEntity.isDirectorySync(path);

  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  bool isFile() => io.FileSystemEntity.isFileSync(path);

  /// Returns true if the Path is relative, i.e., not absolute.
  bool isRelative() => unix.isRelative(path);

  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  bool isSymlink() => io.FileSystemEntity.isLinkSync(path);

  /// Produces an iterator over the path’s components viewed as Strings
  RIterator<String> iter() => RIterator(components().map((e) => e.toString()));

  Path join(Path other) => Path(unix.join(path, other.path));

  /// Queries the file system to get information about a file, directory, etc.
  Metadata metadata() => io.FileStat.statSync(path);

// new : will not be implemented

  /// Returns the Path without its final component, if there is one.
  /// This means it returns Some("") for relative paths with one component.
  /// Returns None if the path terminates in a root or prefix, or if it’s the empty string.
  Option<Path> parent() {
    final comps = components().toList();
    if (comps.length == 1) {
      switch (comps.first) {
        case RootDir():
        case Prefix():
          return None;
        case ParentDir():
        case CurDir():
        case Normal():
          return Some(Path(""));
      }
    }
    if (comps.length > 1) {
      comps.removeLast();
    } else {
      return None;
    }
    return Some(_joinComponents(comps));
  }

  /// Returns an iterator over the entries within a directory.
  Result<ReadDir, IoError> readDir() {
    if (!isDir()) {
      return Err(IoError(IoErrorType.notADirectory, path: this));
    }
    try {
      final dir = io.Directory(path);
      return Ok(dir.listSync());
    } catch (e) {
      return Err(IoError(IoErrorType.unknown, path: this, error: e));
    }
  }

  /// Reads a symbolic link, returning the file that the link points to.
  Result<PathBuf, IoError> readLink() {
    if (!isSymlink()) {
      return Err(IoError(IoErrorType.notAlink, path: this));
    }
    try {
      final link = io.Link(path);
      return Ok(PathBuf([Path(link.resolveSymbolicLinksSync())]));
    } catch (e) {
      return Err(IoError(IoErrorType.unknown, path: this, error: e));
    }
  }

  /// Determines whether other is a prefix of this.
  bool startsWith(Path other) => path.startsWith(other.path);

  /// Returns a path that, when joined onto base, yields this. Returns None if [prefix] is not a subpath of base.
  Option<Path> stripPrefix(Path prefix) {
    if (!startsWith(prefix)) {
      return None;
    }
    final newPath = path.substring(prefix.path.length);
    return Some(Path(newPath));
  }

  Result<Metadata, IoError> symlinkMetadata() {
    if (!isSymlink()) {
      return Err(IoError(IoErrorType.notAlink, path: this));
    }
    try {
      return Ok(io.Link(path).statSync());
    }
    catch(e){
      return Err(IoError(IoErrorType.unknown, path: this, error: e));
    }
  }

  /// Converts to [PathBuf]
  PathBuf toPathBuf() => PathBuf([this]);

// to_str: Implemented by type
// to_string_lossy: Will not be implemented
// try_exists: Will not implement

  /// Creates an PathBuf like this but with the given extension.
  PathBuf withExtension(String extension) {
    final stem = fileStem().unwrapOr("");
    if(extension.isEmpty){
      return PathBuf([Path(stem)]);
    }
    return PathBuf([Path("$stem.$extension")]);
  }

  /// Creates an PathBuf like this but with the given file name.
  PathBuf withFileName(String fileName){
    final parentOption = parent();
    return switch(parentOption){
      None => PathBuf([Path(fileName)]),
      Some(:final v) => PathBuf([v.join(Path(fileName))]),
    };
  }
}

Path _joinComponents(Iterable<Component> components) {
  final buffer = StringBuffer();
  final iterator = components.iterator;
  forEachExceptFirstAndLast(iterator, doFirst: (e) {
    if (e is RootDir) {
      buffer.write("/");
    } else {
      buffer.write(e);
      buffer.write("/");
    }
  }, doRest: (e) {
    buffer.write(e);
    buffer.write("/");
  }, doLast: (e) {
    buffer.write(e);
  }, doIfOnlyOne: (e) {
    buffer.write(e);
  }, doIfEmpty: () {
    return buffer.write("");
  });
  return Path(buffer.toString());
}

//************************************************************************//

bool _validate(String path) {
  if (path.contains("\\")) {
    return false;
  }
  if(RegExp(r'\.\.[^/]').hasMatch(path)){
    return false;
  }
  return true;
}

sealed class Component {
  const Component();
}

class Prefix extends Component {
  final String value;
  const Prefix(this.value);

  @override
  bool operator ==(Object other) => other == value || (other is Prefix && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class RootDir extends Component {
  const RootDir();

  @override
  bool operator ==(Object other) => other == "/" || other is RootDir;

  @override
  int get hashCode => "/".hashCode;

  @override
  String toString() => "/";
}

class CurDir extends Component {
  const CurDir();

  @override
  bool operator ==(Object other) => other == "." || other is CurDir;

  @override
  int get hashCode => ".".hashCode;

  @override
  String toString() => ".";
}

class ParentDir extends Component {
  const ParentDir();

  @override
  bool operator ==(Object other) => other == ".." || other is ParentDir;

  @override
  int get hashCode => "..".hashCode;

  @override
  String toString() => "..";
}

class Normal extends Component {
  final String value;
  Normal(this.value);

  @override
  bool operator ==(Object other) => other == value || (other is Normal && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
