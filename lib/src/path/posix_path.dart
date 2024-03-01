import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:rust_std/option.dart';
import 'package:universal_io/io.dart';

import 'utils.dart';

part 'posix_path_buf.dart';

// A path separated by /
extension type Path._(String path) implements Object {
  static final RegExp regularPathComponent = RegExp(r'^[.\w-]+(\.[\w-]+)*$');
  static final RegExp oneOrmoreSlashes = RegExp(r'/+');

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

  Path canonicalize() => Path(p.canonicalize(path));

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

// display
// ends_with

  bool exists() =>
      FileSystemEntity.typeSync(path, followLinks: true) != FileSystemEntityType.notFound;

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
    final last = components().lastOrNull;
    if (last is! Normal) {
      return None();
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
      return None();
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

  /// Returns the Path without its final component, if there is one.
  /// This means it returns Some("") for relative paths with one component.
  /// Returns None if the path terminates in a root or prefix, or if it’s the empty string.
  Option<Path> parent() {
    final comps = components().toList();
    if (comps.length == 1) {
      switch (comps.first) {
        case RootDir():
        case Prefix():
          return None();
        case ParentDir():
        case CurDir():
        case Normal():
          return Some(Path(""));
      }
    }
    if (comps.length > 1) {
      comps.removeLast();
    } else {
      return None();
    }
    return Some(_joinComponents(comps));
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
