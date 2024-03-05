The rust standard library implemented in Dart where it makes sense.

table of **Rust std** vs **Dart std** types
| Rust Type         | Dart Equivalent | Implementation | Description                                             |
|-------------------|-----------------|----------------------|---------------------------------------------------------|
| `Vec<T>`          | `List<T>`       | `Vec<T>` ✅                    | Dynamic array or list.                                  |
| `[T]`             | - | `Slice<T>` 🚧                    | View into an array or list.                                  |
| `[T; N]`          | `const [...]`/`List<T>(growable: false)` | `Array`✅            | Fixed size array or list                                   |
| `Iterator<T>`     | `Iterable<T>`   |  `RIterator<T>` 🚧                  | Composable iteration
| `HashMap<K, V>`   | `Map<K, V>`     | `HashMap<K, V>` ❌                    | Key-value pairs collection, implemented as a hash table.|
| `HashSet<T>`      | `Set<T>`        | `HashSet<T>` ❌                    | Unordered collection of unique items.                   |
| `BTreeMap<K, V>`  | - | `BTreeMap<K, V>` ❌ | Map based on a B-Tree, maintaining sorted order.        |
| `BTreeSet<T>`     | - | `BTreeSet<T>` ❌ | Set based on a B-Tree, maintaining sorted order.        |
| `Option<T>`       | `T?`            | `Option<T>` ✅                    | A type that may hold a value or none.                   |
| `Result<T, E>`    |  - | `Result<T, E>` ✅ | Type used for returning and propagating errors.|                         |
| `VecDeque<T>`     | - | `VecDeque<T>` ❌ | Double-ended queue implemented with a growable ring buffer. |
| `LinkedList<T>`   | - | `LinkedList<T>` ❌ | Doubly-linked list.
| `Path`            | - | `Path` ✅ | Type for file system path manipulation.
| `mpsc`            | `StreamController` | TBD ❌ | multi-producer, single-consumer queue for message passing.

- ✅: Implemented
- ❌: Not yet implemented
- 🚧: Being developed
