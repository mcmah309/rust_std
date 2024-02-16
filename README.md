The rust standard library implemented in Dart where it makes sense.

table of **Rust std** vs **Dart std** types
| Rust Type         | Dart Equivalent | Implementation Status | Description                                             |
|-------------------|-----------------|----------------------|---------------------------------------------------------|
| `Vec<T>`          | `List<T>`       | ❌                    | Dynamic array or list.                                  |
| `HashMap<K, V>`   | `Map<K, V>`     | ❌                    | Key-value pairs collection, implemented as a hash table.|
| `HashSet<T>`      | `Set<T>`        | ❌                    | Unordered collection of unique items.                   |
| `BTreeMap<K, V>`  | - | ❌ | Map based on a B-Tree, maintaining sorted order.        |
| `BTreeSet<T>`     | - | ❌ | Set based on a B-Tree, maintaining sorted order.        |
| `Option<T>`       | `T?`            | ✅                    | A type that may hold a value or none.                   |
| `Result<T, E>`    |  - | ✅ | Type used for returning and propagating errors.|                         |
| `VecDeque<T>`     | - | ❌ | Double-ended queue implemented with a growable ring buffer. |
| `LinkedList<T>`   | - | ❌ | Doubly-linked list.
| `PathBuf`         | - | ❌ | Types for file system path manipulation.
| `Path`            | - | ❌ | Types for file system path manipulation.
| `mpsc`            | `StreamController` | ❌ | multi-producer, single-consumer queue for message passing.

- ✅: Implemented
- ❌: No yet implemented
