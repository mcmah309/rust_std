import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:rust_std/windows_path.dart';

void main(){
test("filePrefix", () {
  expect(Path("foo.rs").filePrefix().unwrap(), "foo");
  expect(Path("foo\\").filePrefix().unwrap(), "foo"); // Changed slash
  expect(Path(".foo").filePrefix().unwrap(), ".foo");
  expect(Path(".foo.rs").filePrefix().unwrap(), "foo");
  expect(Path("foo").filePrefix().unwrap(), "foo");
  expect(Path("foo.tar.gz").filePrefix().unwrap(), "foo");
  expect(Path("temp\\foo.tar.gz").filePrefix().unwrap(), "foo"); // Changed slash
  expect(Path("C:\\foo\\.tmp.bar.tar").filePrefix().unwrap(), "tmp"); // Added drive letter and changed slashes
  expect(Path("").filePrefix().isNone(), true);
});

test("fileStem", () {
  expect(Path("foo.rs").fileStem().unwrap(), "foo");
  expect(Path("foo\\").fileStem().unwrap(), "foo"); // Changed slash
  expect(Path(".foo").fileStem().unwrap(), ".foo");
  expect(Path(".foo.rs").fileStem().unwrap(), ".foo");
  expect(Path("foo").fileStem().unwrap(), "foo");
  expect(Path("foo.tar.gz").fileStem().unwrap(), "foo.tar");
  expect(Path("temp\\foo.tar.gz").fileStem().unwrap(), "foo.tar"); // Changed slash
  expect(Path("").fileStem().isNone(), true);
});

test("parent", () {
  expect(Path("temp\\foo.rs").parent().unwrap(), Path("temp")); // Changed slash
  expect(Path("foo\\").parent().unwrap(), Path("")); // Changed slash
  expect(Path("C:\\foo\\").parent().unwrap(), Path("C:")); // Added drive letter and changed slashes
  expect(Path(".foo").parent().unwrap(), Path(""));
  expect(Path(".foo.rs").parent().unwrap(), Path(""));
  expect(Path("foo").parent().unwrap(), Path(""));
  expect(Path("foo.tar.gz").parent().unwrap(), Path(""));
  expect(Path("temp\\foo.tar.gz").parent().unwrap(), Path("temp")); // Changed slash
  expect(Path("temp1\\temp2\\foo.tar.gz").parent().unwrap(), Path("temp1\\temp2")); // Changed slashes
  expect(Path("temp1\\temp2\\\\foo.tar.gz").parent().unwrap(), Path("temp1\\temp2")); // Changed slashes
  expect(Path("").parent().isNone(), true);
});

test("ancestors", () {
  var ancestors = Path("C:\\foo\\bar").ancestors().iterator; // Added drive letter and changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("C:\\foo\\bar")); // Added drive letter and changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("C:\\foo")); // Added drive letter and changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("C:")); // Added drive letter and changed slashes
  expect(ancestors.moveNext(), false);

  // Relative paths should work similarly but without drive letters
  ancestors = Path("..\\foo\\bar").ancestors().iterator; // Changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("..\\foo\\bar")); // Changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("..\\foo")); // Changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path(".."));
  ancestors.moveNext();
  expect(ancestors.current, Path(""));
  expect(ancestors.moveNext(), false);

  ancestors = Path("foo\\bar").ancestors().iterator; // Changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("foo\\bar")); // Changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("foo")); // Changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path(""));
  expect(ancestors.moveNext(), false);

  ancestors = Path("foo\\..").ancestors().iterator; // Changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("foo\\..")); // Changed slashes
  ancestors.moveNext();
  expect(ancestors.current, Path("foo")); // Changed slashes
});

test("withExtension",(){
  expect(Path("foo").withExtension("rs"), Path("foo.rs"));
  expect(Path("foo.rs").withExtension("rs"), Path("foo.rs"));
  expect(Path("foo.tar.gz").withExtension("rs"), Path("foo.tar.rs"));
  expect(Path("foo.tar.gz").withExtension(""), Path("foo.tar"));
  expect(Path("foo.tar.gz").withExtension("tar.gz"), Path("foo.tar.tar.gz"));
  expect(Path("C:\\tmp\\foo.tar.gz").withExtension("tar.gz"), Path("C:\\tmp\\foo.tar.tar.gz")); // Added drive letter and changed slashes
  expect(Path("tmp\\foo").withExtension("tar.gz"), Path("tmp\\foo.tar.gz")); // Changed slashes
  expect(Path("tmp\\.foo.tar").withExtension("tar.gz"), Path("tmp\\.foo.tar.gz")); // Changed slashes
});

test("withFileName",(){
  expect(Path("foo").withFileName("bar"), Path("bar"));
  expect(Path("foo.rs").withFileName("bar"), Path("bar"));
  expect(Path("foo.tar.gz").withFileName("bar"), Path("bar"));
  expect(Path("C:\\tmp\\foo.tar.gz").withFileName("bar"), Path("C:\\tmp\\bar")); // Added drive letter and changed slashes
  expect(Path("tmp\\foo").withFileName("bar"), Path("tmp\\bar")); // Changed slashes
  expect(Path("C:\\var").withFileName("bar"), Path("C:\\bar")); // Added drive letter and changed slashes
});

}