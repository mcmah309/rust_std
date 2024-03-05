import 'package:rust_std/vec.dart';

extension VecOnIterableExtension<T> on Iterable<T> {
  Vec<T> collectVec(){
    return Vec(toList());
  }
}

extension VecOnListExtension<T> on List<T> {
  Vec<T> asVec(){
    return Vec(this);
  }
}

extension VecOnListListExtension<T> on List<List<T>> {
  Vec<T> toFlattenedVec(){
    return Vec(expand((element) => element).toList());
  }
}

extension VecOnListVecExtension<T> on List<Vec<T>> {
  Vec<T> toFlattenedVec(){
    return Vec(expand((element) => element).toList());
  }
}

extension VecOnVecVecExtension<T> on Vec<Vec<T>> {
  Vec<T> flatten(){
    return Vec(list.expand<T>((element) => element).toList());
  }
}

extension VecOnVecListExtension<T> on Vec<List<T>> {
  Vec<T> flatten(){
    return Vec(expand<T>((element) => element).toList());
  }
}

extension VecSetExtension<T> on Set<T> {
  Vec<T> toVec(){
    return Vec(toList());
  }
}