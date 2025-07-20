// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionData _$SessionDataFromJson(Map<String, dynamic> json) => SessionData(
  sessionId: json['session_id'] as String,
  audioFile: json['audio_file'] == null
      ? null
      : AudioFile.fromJson(json['audio_file'] as Map<String, dynamic>),
  timestampFilePath: json['timestamp_file_path'] as String?,
  currentPosition: (json['current_position'] as num?)?.toDouble() ?? 0.0,
  lastAyah: (json['last_ayah'] as num?)?.toInt(),
  unsavedChanges:
      (json['unsaved_changes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  uiState: json['ui_state'] == null
      ? const SessionUIState()
      : SessionUIState.fromJson(json['ui_state'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$SessionDataToJson(SessionData instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'audio_file': instance.audioFile,
      'timestamp_file_path': instance.timestampFilePath,
      'current_position': instance.currentPosition,
      'last_ayah': instance.lastAyah,
      'unsaved_changes': instance.unsavedChanges,
      'ui_state': instance.uiState,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

SessionUIState _$SessionUIStateFromJson(Map<String, dynamic> json) =>
    SessionUIState(
      syncMode: json['sync_mode'] as bool? ?? true,
      reviewedAyahs:
          (json['reviewed_ayahs'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      selectedAyah: (json['selected_ayah'] as num?)?.toInt(),
      waveformZoom: (json['waveform_zoom'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$SessionUIStateToJson(SessionUIState instance) =>
    <String, dynamic>{
      'sync_mode': instance.syncMode,
      'reviewed_ayahs': instance.reviewedAyahs,
      'selected_ayah': instance.selectedAyah,
      'waveform_zoom': instance.waveformZoom,
    };
