import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:rust_std/posix_path.dart';

void main() {
  test("filePrefix", () {
    expect(Path("foo.rs").filePrefix().unwrap(), "foo");
    expect(Path("foo/").filePrefix().unwrap(), "foo");
    expect(Path(".foo").filePrefix().unwrap(), ".foo");
    expect(Path(".foo.rs").filePrefix().unwrap(), "foo");
    expect(Path("foo").filePrefix().unwrap(), "foo");
    expect(Path("foo.tar.gz").filePrefix().unwrap(), "foo");
    expect(Path("temp/foo.tar.gz").filePrefix().unwrap(), "foo");
  });

  test("fileStem", () {
    expect(Path("foo.rs").fileStem().unwrap(), "foo");
    expect(Path("foo/").filePrefix().unwrap(), "foo");
    expect(Path(".foo").fileStem().unwrap(), ".foo");
    expect(Path(".foo.rs").fileStem().unwrap(), "foo");
    expect(Path("foo").fileStem().unwrap(), "foo");
    expect(Path("foo.tar.gz").fileStem().unwrap(), "foo.tar");
    expect(Path("temp/foo.tar.gz").fileStem().unwrap(), "foo.tar");
  });

  test("parent", () {
    expect(Path("temp/foo.rs").parent().unwrap(), Path("temp"));
    expect(Path("foo/").parent().unwrap(), Path(""));
    expect(Path("/foo/").parent().unwrap(), Path("/"));
    expect(Path(".foo").parent().unwrap(), Path(""));
    expect(Path(".foo.rs").parent().unwrap(), Path(""));
    expect(Path("foo").parent().unwrap(), Path(""));
    expect(Path("foo.tar.gz").parent().unwrap(), Path(""));
    expect(Path("temp/foo.tar.gz").parent().unwrap(), Path("temp"));
    expect(Path("temp1/temp2/foo.tar.gz").parent().unwrap(), Path("temp1/temp2"));
    expect(Path("temp1/temp2//foo.tar.gz").parent().unwrap(), Path("temp1/temp2"));
  });

  test("ancestors", () {
    var ancestors = Path("/foo/bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, Path("/foo/bar"));
    ancestors.moveNext();
    expect(ancestors.current, Path("/foo"));
    ancestors.moveNext();
    expect(ancestors.current, Path("/"));
    expect(ancestors.moveNext(), false);

    ancestors = Path("../foo/bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, Path("../foo/bar"));
    ancestors.moveNext();
    expect(ancestors.current, Path("../foo"));
    ancestors.moveNext();
    expect(ancestors.current, Path(".."));
    ancestors.moveNext();
    expect(ancestors.current, Path(""));
    expect(ancestors.moveNext(), false);

    ancestors = Path("foo/bar").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, Path("foo/bar"));
    ancestors.moveNext();
    expect(ancestors.current, Path("foo"));
    ancestors.moveNext();
    expect(ancestors.current, Path(""));
    expect(ancestors.moveNext(), false);

    ancestors = Path("foo/..").ancestors().iterator;
    ancestors.moveNext();
    expect(ancestors.current, Path("foo/.."));
    ancestors.moveNext();
    expect(ancestors.current, Path("foo"));
  });
}
