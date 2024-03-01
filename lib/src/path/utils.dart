  /// Does a [split] but instead of remove the matches that it is split on, the matches are included. Ex:
  /// ```dart
  /// String string = " word  word word ";
  //  List<String> splits = string.splitWithoutRemoving(" ");
  //  expect(splits, [" ", "word", " ", " ", "word", " ", "word", " "]);
  /// ```
  List<String> splitWithoutRemoving(Pattern pattern, String string) {
    Iterable<Match> matches = pattern.allMatches(string);
    List<String> splits = [];
    int lastEnd = 0;
    for (final match in matches) {
      if (lastEnd != match.start) {
        splits.add(string.substring(lastEnd, match.start));
      }
      splits.add(string.substring(match.start, match.end));
      lastEnd = match.end;
    }
    if (lastEnd != string.length) {
      splits.add(string.substring(lastEnd));
    }
    return splits;
  }