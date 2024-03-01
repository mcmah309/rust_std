import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:rust_std/posix_path.dart';

void main() {
  test("filePrefix", () {
    expect("foo", Path("foo.rs").filePrefix().unwrap());
    expect(true, Path("foo/").filePrefix().isNone());
    expect(".foo", Path(".foo").filePrefix().unwrap());
    expect("foo", Path(".foo.rs").filePrefix().unwrap());
    expect("foo", Path("foo").filePrefix().unwrap());
    expect("foo", Path("foo.tar.gz").filePrefix().unwrap());
    expect("foo", Path("temp/foo.tar.gz").filePrefix().unwrap());
  });

  test("fileStem", () {
    expect("foo", Path("foo.rs").fileStem().unwrap());
    expect(true, Path("foo/").fileStem().isNone());
    expect(".foo", Path(".foo").fileStem().unwrap());
    expect("foo", Path(".foo.rs").fileStem().unwrap());
    expect("foo", Path("foo").fileStem().unwrap());
    expect("foo.tar", Path("foo.tar.gz").fileStem().unwrap());
    expect("foo.tar", Path("temp/foo.tar.gz").fileStem().unwrap());
  });

  test("parent", () {
    expect(Path("temp/"), Path("temp/foo.rs").parent().unwrap());
    expect(true, Path("foo/").parent().isNone());
    expect(Path("/"), Path("/foo/").parent().unwrap());
    expect(true, Path(".foo").parent().isNone());
    expect(true, Path(".foo.rs").parent().isNone());
    expect(true, Path("foo").parent().isNone());
    expect(true, Path("foo.tar.gz").parent().isNone());
    expect(Path("temp/"), Path("temp/foo.tar.gz").parent().unwrap());
    expect(Path("temp1/temp2/"), Path("temp1/temp2/foo.tar.gz").parent().unwrap());
  });
}
