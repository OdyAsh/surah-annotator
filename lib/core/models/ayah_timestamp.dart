class AyahTimestamp {
  final int ayahNumber;
  final double startTime;
  final double endTime;
  final String text;
  final bool isReviewed;

  const AyahTimestamp({
    required this.ayahNumber,
    required this.startTime,
    required this.endTime,
    required this.text,
    this.isReviewed = false,
  });

  factory AyahTimestamp.fromJson(Map<String, dynamic> json) {
    return AyahTimestamp(
      ayahNumber: json['ayah_number'] as int,
      startTime: (json['start_time'] as num).toDouble(),
      endTime: (json['end_time'] as num).toDouble(),
      text: json['text'] as String,
      isReviewed: json['is_reviewed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ayah_number': ayahNumber,
      'start_time': startTime,
      'end_time': endTime,
      'text': text,
      'is_reviewed': isReviewed,
    };
  }

  AyahTimestamp copyWith({
    int? ayahNumber,
    double? startTime,
    double? endTime,
    String? text,
    bool? isReviewed,
  }) {
    return AyahTimestamp(
      ayahNumber: ayahNumber ?? this.ayahNumber,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      text: text ?? this.text,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }

  Duration get startDuration => Duration(
    milliseconds: (startTime * 1000).round(),
  );

  Duration get endDuration => Duration(
    milliseconds: (endTime * 1000).round(),
  );

  Duration get duration => Duration(
    milliseconds: ((endTime - startTime) * 1000).round(),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AyahTimestamp &&
        other.ayahNumber == ayahNumber &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.text == text &&
        other.isReviewed == isReviewed;
  }

  @override
  int get hashCode {
    return Object.hash(ayahNumber, startTime, endTime, text, isReviewed);
  }

  @override
  String toString() {
    return 'AyahTimestamp(ayahNumber: $ayahNumber, startTime: $startTime, endTime: $endTime, text: $text, isReviewed: $isReviewed)';
  }
}
