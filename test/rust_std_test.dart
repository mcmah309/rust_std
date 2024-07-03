import 'package:rust_std/result.dart';
import 'package:test/test.dart';

void main() {
  test("rust_std", () {
    // ignore: unused_local_variable
    Result<int, int> x = Ok(1);
  });
}
