# rust_std

[![Pub Version](https://img.shields.io/pub/v/rust_std.svg)](https://pub.dev/packages/rust_std)
[![Dart Package Docs](https://img.shields.io/badge/documentation-pub.dev-blue.svg)](https://pub.dev/documentation/rust_std/latest/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/mcmah309/rust_std/actions/workflows/dart.yml/badge.svg)](https://github.com/mcmah309/rust_std/actions)

The Rust standard library implemented in Dart. Built on top of [rust_core](https://github.com/mcmah309/rust_core).

Implemented ✅:
| Rust Type         | Dart Equivalent | rust_std Implementation | Description                                             |
|-------------------|-----------------|----------------------|---------------------------------------------------------|
| `Vec<T>`          | `List<T>`       | `Vec<T>`                    | Dynamic array or list.                                  |
| `[T; N]`          | `const [...]`/`List<T>(growable: false)` | `Arr<T>`            | Fixed size array or list                                   |
| `Iterator<T>`     | `Iterable<T>`   |  `RIterator<T>`                  | Composable iteration
| `Option<T>`       | `T?`            | `Option<T>`                    | A type that may hold a value or none.                   |
| `Result<T, E>`    |  - | `Result<T, E>`  | Type used for returning and propagating errors.|                         |
| `Path`            | - | `Path`  | Type for file system path manipulation.

Partially Implemented 🚧:
| Rust Type         | Dart Equivalent | rust_std Implementation | Description                                             |
|-------------------|-----------------|----------------------|---------------------------------------------------------|
| `[T]`             | - | `Slice<T>`                    | View into an array or list.                                  |

Not yet Implemented:
| Rust Type         | Dart Equivalent | rust_std Implementation | Description                                             |
|-------------------|-----------------|----------------------|---------------------------------------------------------|
| `HashMap<K, V>`   | `Map<K, V>`     | `HashMap<K, V>`                     | Key-value pairs collection, implemented as a hash table.|
| `HashSet<T>`      | `Set<T>`        | `HashSet<T>`                     | Unordered collection of unique items.                   |
| `BinaryHeap<T>`   | -               | `BinaryHeap<T>`                    | A priority queue implemented with a binary heap.      |
| `BTreeMap<K, V>`  | - | `BTreeMap<K, V>`  | Map based on a B-Tree, maintaining sorted order.        |
| `BTreeSet<T>`     | - | `BTreeSet<T>`  | Set based on a B-Tree, maintaining sorted order.        |
| `VecDeque<T>`     | - | `VecDeque<T>`  | Double-ended queue implemented with a growable ring buffer. |
| `LinkedList<T>`   | - | `LinkedList<T>`  | Doubly-linked list.                      |