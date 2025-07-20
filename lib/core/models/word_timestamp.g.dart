// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_timestamp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordTimestamp _$WordTimestampFromJson(Map<String, dynamic> json) =>
    WordTimestamp(
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
      word: json['word'] as String,
    );

Map<String, dynamic> _$WordTimestampToJson(WordTimestamp instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
      'word': instance.word,
    };
