// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_timestamp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AyahTimestamp _$AyahTimestampFromJson(Map<String, dynamic> json) =>
    AyahTimestamp(
      ayahNumber: (json['ayah_number'] as num).toInt(),
      startTime: (json['start_time'] as num).toDouble(),
      endTime: (json['end_time'] as num).toDouble(),
      text: json['text'] as String,
      isReviewed: json['isReviewed'] as bool? ?? false,
    );

Map<String, dynamic> _$AyahTimestampToJson(AyahTimestamp instance) =>
    <String, dynamic>{
      'ayah_number': instance.ayahNumber,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'text': instance.text,
      'isReviewed': instance.isReviewed,
    };
