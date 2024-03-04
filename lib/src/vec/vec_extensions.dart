import 'package:rust_std/vec.dart';

extension VecIterableExtension<T> on Iterable<T> {
  Vec<T> collectVec(){
    return Vec(toList());
  }
}

extension VecListExtension<T> on List<T> {
  Vec<T> toVec(){
    return Vec(this);
  }
}