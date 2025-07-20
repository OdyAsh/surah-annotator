class WordTimestamp {
  final double start;
  final double end;
  final String word;

  const WordTimestamp({
    required this.start,
    required this.end,
    required this.word,
  });

  factory WordTimestamp.fromJson(Map<String, dynamic> json) {
    return WordTimestamp(
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
      word: json['word'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'word': word,
    };
  }

  Duration get startDuration => Duration(
    milliseconds: (start * 1000).round(),
  );

  Duration get endDuration => Duration(
    milliseconds: (end * 1000).round(),
  );

  Duration get duration => Duration(
    milliseconds: ((end - start) * 1000).round(),
  );

  bool containsPosition(double position) {
    return position >= start && position <= end;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WordTimestamp &&
        other.start == start &&
        other.end == end &&
        other.word == word;
  }

  @override
  int get hashCode => Object.hash(start, end, word);

  @override
  String toString() => 'WordTimestamp(start: $start, end: $end, word: $word)';
}
