// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioFile _$AudioFileFromJson(Map<String, dynamic> json) => AudioFile(
  name: json['name'] as String,
  path: json['path'] as String,
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
  format: json['format'] as String,
  fileSize: (json['file_size'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AudioFileToJson(AudioFile instance) => <String, dynamic>{
  'name': instance.name,
  'path': instance.path,
  'duration': instance.duration.inMicroseconds,
  'format': instance.format,
  'file_size': instance.fileSize,
  'created_at': instance.createdAt.toIso8601String(),
};
