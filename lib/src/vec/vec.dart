import 'package:rust_std/prelude.dart';
import 'package:rust_std/slice.dart';
import 'package:rust_std/iter.dart';
import 'package:rust_std/option.dart';

extension type Vec<T>._(List<T> list) {
  Vec(this.list);

  Iterator<T> get iterator => list.iterator;

  operator [](int index) => list[index];

  operator []=(int index, T value) => list[index] = value;

// allocator: will not be implemented

  /// Adds all of other's elements to this Vec.
  void append(Vec<T> other) {
    list.addAll(other.list);
  }

// as_mut_ptr: will not be implemented
// as_mut_slice: will not be implemented
// as_ptr: will not be implemented

  /// Returns a slice of the Vec from the start index to the end index.
  Slice<T> asSlice() => Slice.fromList(list);

// capacity: will not be implemented, not possible

  /// Clears the Vec, removing all values.
  void clear() => list.clear();

// clone: will not be implemented, not possible

  /// Removes consecutive repeated elements in the vector according to `==`. If the vector is sorted, this removes all duplicates.
  void dedup() {
    late T last;
    bool first = true;
    list.removeWhere((element) {
      if (first) {
        last = element;
        first = false;
        return false;
      }
      if (element == last) {
        return true;
      }
      last = element;
      return false;
    });
  }

  /// Removes all but the first of consecutive elements in the vector satisfying a given equality relation. If the vector is sorted, this removes all duplicates.
  void dedupBy(bool Function(T a, T b) f) {
    late T last;
    bool first = true;
    list.removeWhere((element) {
      if (first) {
        last = element;
        first = false;
        return false;
      }
      if (f(element, last)) {
        return true;
      }
      last = element;
      return false;
    });
  }

  /// Removes all but the first of consecutive elements in the vector for which the given predicate returns true. If the vector is sorted, this removes all duplicates.
  void dedupByKey<K>(K Function(T) f) {
    late K last;
    bool first = true;
    list.removeWhere((element) {
      if (first) {
        last = f(element);
        first = false;
        return false;
      }
      if (f(element) == last) {
        return true;
      }
      last = f(element);
      return false;
    });
  }

  /// Removes the element at the given index from the Vec and returns it.
  Iterable<T> drain(int start, int end) {
    //todo change to array
    final range = list.getRange(start, end).toList(growable: false);
    list.removeRange(start, end);
    return range;
  }

  /// Appends all elements in a slice to the Vec.
  void extendFromSlice(Slice<T> slice) {
    list.addAll(slice);
  }

  // Appends all the elements in range to the end of the vector.
  void extendFromWithin(int start, int end) {
    list.addAll(list.getRange(start, end));
  }

  /// Creates an [RIterator] which uses a closure to determine if an element should be removed.
  /// If the closure returns true, then the element is removed and yielded. If the closure returns false,
  /// the element will remain in the vector and will not be yielded by the iterator.
  RIterator<T> extractIf(bool Function(T) f) => RIterator(ExtractIfIterable(this, f));

// from_raw_parts: will not be implemented, not possible
// from_raw_parts_in: will not be implemented, not possible

  /// Inserts an element at position index within the vector, shifting all elements after it to the right.
  void insert(int index, T element) {
    list.insert(index, element);
  }

// into_boxed_slice: will not implement, box is not a thing in dart
// into_flattened: //todo add with an extension
// into_raw_parts: will not be implemented, not possible
// into_raw_parts_with_alloc: will not be implemented, not possible

  bool isEmpty() => list.isEmpty;

// leak: will not be implemented, not possible

  /// Returns the length of the Vec.
  int len() => list.length;

// new: will not not implement, already has a constructor
// new_in: will not implement, not possible

  /// Removes the last element from the Vec and returns it, or None if it is empty.
  Option<T> pop() {
    if (list.isEmpty) {
      return None;
    }
    return Some(list.removeLast());
  }

  /// Appends an element to the end of the Vec.
  void push(T element) => list.add(element);

// push_within_capacity: will not implement, no point

  /// Removes the element at the given index from the Vec. Will throw if out of bounds.
  T remove(int index) => list.removeAt(index);

// reserve: Will not implement, would require another param to keep track of allocation vs vec size
// reserve_exact: Will not implement, not possible

  /// Resizes the Vec in-place so that len is equal to [newLen].
  /// If [newLen] is greater than len, the Vec is extended by the difference,
  /// with each additional slot filled with value. If new_len is less than len,
  /// the Vec is simply truncated.
  void resize(int newLen, T value) {
    if (newLen > list.length) {
      final doFor = newLen - list.length;
      for (int i = 0; i < doFor; i++) {
        list.add(value);
      }
    } else {
      list.length = newLen;
    }
  }

  /// Resizes the Vec in-place so that len is equal to [newLen].
  /// If [newLen] is greater than len, the Vec is extended by the difference,
  /// with each additional slot filled with the result of f. If new_len is less than len,
  /// the Vec is simply truncated.
  void resizeWith(int newLen, T Function() f) {
    if (newLen > list.length) {
      final doFor = newLen - list.length;
      for (int i = 0; i < doFor; i++) {
        list.add(f());
      }
    } else {
      list.length = newLen;
    }
  }

  /// Retains only the elements specified by the predicate where the result is true.
  void retain(bool Function(T) f) {
    list.retainWhere(f);
  }

// retain_mut: Will not implement, functionality implemented by `retain`
// set_len: Will not implement, not possible
// shrink_to: Will not implement, not possible
// shrink_to_fit: will not implement, not possible
// spare_capacity_mut: Will not implement, not possible

  /// Creates a splicing iterator that replaces the specified range in the vector with the given
  /// [replaceWith] iterator and yields the removed items. replace_with does not need to be the same length as range.
  RIterator<T> splice(int start, int end, Iterable<T> replaceWith) {
    final range = list.getRange(start, end).toList(growable: false);
    list.replaceRange(start, end, replaceWith);
    return RIterator(range);
  }

// split_at_spare_mut: Will not implement, not possible

  /// Splits the collection into two at the given index.
  /// Returns a newly allocated vector containing the elements in the range
  /// [at, len). After the call, the original vector will be left containing the elements [0, at).
  Vec<T> splitOff(int at) {
    final split = list.sublist(at);
    list.removeRange(at, list.length);
    return Vec(split);
  }

  /// Removes an element from the vector and returns it.
  /// The removed element is replaced by the last element of the vector.
  T swapRemove(int index) {
    final removed = list[index];
    list[index] = list.removeLast();
    return removed;
  }

  /// Shortens the vector, keeping the first len elements and dropping the rest.
  void truncate(int newLen) {
    list.length = newLen;
  }

// try_reserve: Will not implement, would require another param to keep track of allocation vs vec size
// try_reserve_exact: Will not implement, not possible
// with_capacity_in: Will not implement, would require another param to keep track of allocation vs vec size

  //************************************************************************//

  RIterator<T> iter() => RIterator(list);
}
