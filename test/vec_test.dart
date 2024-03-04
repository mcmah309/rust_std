import 'package:rust_std/option.dart';
import 'package:rust_std/slice.dart';
import 'package:test/test.dart';

import 'package:rust_std/vec.dart';

main() {
  test("append", () {
    var vec = Vec([1, 2, 3]);
    vec.append(Vec([4, 5, 6]));
    expect(vec, [1, 2, 3, 4, 5, 6]);
  });

  test("asSlice", () {
    var vec = Vec([1, 2, 3]);
    var slice = vec.asSlice();
    expect(slice, [1, 2, 3]);
  });

  test("clear", () {
    var vec = Vec([1, 2, 3]);
    vec.clear();
    expect(vec, []);
  });

  test("dedup", () {
    var vec = Vec([1, 2, 2, 3, 3, 3, 4, 5, 5, 5, 5]);
    vec.dedup();
    expect(vec, [1, 2, 3, 4, 5]);
  });

  test("dedupBy", () {
    var vec = Vec([1, 2, 2, 3, 3, 3, 4, 5, 5, 5, 5]);
    vec.dedupBy((a, b) => a == b);
    expect(vec, [1, 2, 3, 4, 5]);
  });

  test("dedupByKey", () {
    var vec = Vec([1, 2, 2, 3, 3, 3, 4, 5, 5, 5, 5]);
    vec.dedupByKey((a) => a);
    expect(vec, [1, 2, 3, 4, 5]);
  });

  test("drain", () {
    var vec = Vec([1, 2, 3, 4, 5]);
    var drained = vec.drain(1, vec.len() - 1);
    expect(drained, [2, 3, 4]);
    expect(vec, [1, 5]);
  });

  test("extendFromSlice", () {
    var vec = Vec([1, 2, 3]);
    vec.extendFromSlice(Slice([4, 5, 6], 0, 3));
    expect(vec, [1, 2, 3, 4, 5, 6]);
  });

  test("extendFromWithin", () {
    var vec = Vec([1, 2, 3]);
    vec.extendFromWithin(0, 3);
    expect(vec, [1, 2, 3, 1, 2, 3]);
  });

  test("extractIf", (){
    var vec = Vec([1, 2, 3, 4, 5, 6]);
    var extracted = vec.extractIf((e) => e % 2 == 0);
    expect(extracted.take(1), [2]);
    expect(vec, [1, 3, 4, 5, 6]);
    expect(extracted.toList(), [4, 6]);
    expect(vec, [1, 3, 5]);
  });

  test("insert", () {
    var vec = Vec([1, 2, 3]);
    vec.insert(1, 4);
    expect(vec, [1, 4, 2, 3]);
  });

  test("pop", () {
    var vec = Vec([1, 2, 3]);
    var popped = vec.pop();
    expect(popped, Some(3));
    expect(vec, [1, 2]);
  });

  test("push", () {
    var vec = Vec([1, 2, 3]);
    vec.push(4);
    expect(vec, [1, 2, 3, 4]);
  });

  test("remove", () {
    var vec = Vec([1, 2, 3]);
    var removed = vec.remove(1);
    expect(removed, 2);
    expect(vec, [1, 3]);
  });

  test("resize", () {
    var vec = Vec([1, 2, 3]);
    vec.resize(5, 4);
    expect(vec, [1, 2, 3, 4, 4]);

    vec.resize(2, 4);
    expect(vec, [1, 2]);
  });

  test("resizeWith", () {
    var vec = Vec([1, 2, 3]);
    vec.resizeWith(5, () => 4);
    expect(vec, [1, 2, 3, 4, 4]);

    vec.resizeWith(2, () => 4);
    expect(vec, [1, 2]);
  });

  test("splice", () {
    var vec = Vec([1, 2, 3, 4]);
    var spliced = vec.splice(1, 3, [7, 8, 9]);
    expect(vec, [1, 7, 8, 9, 4]);
    expect(spliced, [2, 3]);
  });

  test("splitOff", () {
    var vec = Vec([1, 2, 3, 4]);
    var split = vec.splitOff(2);
    expect(vec, [1, 2]);
    expect(split, [3, 4]);
  });

  test("swapRemove", () {
    var vec = Vec([1, 2, 3, 4]);
    vec.swapRemove(1);
    expect(vec, [1, 4, 3]);
  });

  // Slice
  //************************************************************************//

  group("Verify vec slice methods", () {
    test("swap", () {
      var vec = Vec([1, 2, 3, 4]);
      vec.asSlice().swap(1, 3);
      expect(vec, [1, 4, 3, 2]);
    });
  });

  // Validation
  //************************************************************************//

  test("Ensure can use Option in Vec", () {
    var vec = Vec<Option<int>>([Some(1), None, Some(3)]);
    var filtered = vec.iter().filter((e) => e.isSome()).map((e) => e.unwrap());
    expect(filtered, [1, 3]);
  });

  test("Ensure can use null in Vec", () {
    var vec = Vec<int?>([1, null, 3]);
    var filtered = vec.iter().filter((e) => e != null).map((e) => e);
    expect(filtered, [1, 3]);
  });
}
