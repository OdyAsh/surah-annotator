import 'audio_file.dart';

class SessionData {
  final String sessionId;
  final AudioFile? audioFile;
  final String? timestampFilePath;
  final double currentPosition;
  final int? lastAyah;
  final List<int> unsavedChanges;
  final SessionUIState uiState;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SessionData({
    required this.sessionId,
    this.audioFile,
    this.timestampFilePath,
    this.currentPosition = 0.0,
    this.lastAyah,
    this.unsavedChanges = const [],
    this.uiState = const SessionUIState(),
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      sessionId: json['session_id'] as String,
      audioFile: json['audio_file'] != null
          ? AudioFile.fromJson(json['audio_file'] as Map<String, dynamic>)
          : null,
      timestampFilePath: json['timestamp_file_path'] as String?,
      currentPosition: (json['current_position'] as num?)?.toDouble() ?? 0.0,
      lastAyah: json['last_ayah'] as int?,
      unsavedChanges: (json['unsaved_changes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      uiState: json['ui_state'] != null
          ? SessionUIState.fromJson(json['ui_state'] as Map<String, dynamic>)
          : const SessionUIState(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'audio_file': audioFile?.toJson(),
      'timestamp_file_path': timestampFilePath,
      'current_position': currentPosition,
      'last_ayah': lastAyah,
      'unsaved_changes': unsavedChanges,
      'ui_state': uiState.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SessionData copyWith({
    String? sessionId,
    AudioFile? audioFile,
    String? timestampFilePath,
    double? currentPosition,
    int? lastAyah,
    List<int>? unsavedChanges,
    SessionUIState? uiState,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionData(
      sessionId: sessionId ?? this.sessionId,
      audioFile: audioFile ?? this.audioFile,
      timestampFilePath: timestampFilePath ?? this.timestampFilePath,
      currentPosition: currentPosition ?? this.currentPosition,
      lastAyah: lastAyah ?? this.lastAyah,
      unsavedChanges: unsavedChanges ?? this.unsavedChanges,
      uiState: uiState ?? this.uiState,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasUnsavedChanges => unsavedChanges.isNotEmpty;
  
  bool get isValidSession => audioFile != null && timestampFilePath != null;
}

class SessionUIState {
  final bool syncMode;
  final List<int> reviewedAyahs;
  final int? selectedAyah;
  final double waveformZoom;

  const SessionUIState({
    this.syncMode = true,
    this.reviewedAyahs = const [],
    this.selectedAyah,
    this.waveformZoom = 1.0,
  });

  factory SessionUIState.fromJson(Map<String, dynamic> json) {
    return SessionUIState(
      syncMode: json['sync_mode'] as bool? ?? true,
      reviewedAyahs: (json['reviewed_ayahs'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      selectedAyah: json['selected_ayah'] as int?,
      waveformZoom: (json['waveform_zoom'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sync_mode': syncMode,
      'reviewed_ayahs': reviewedAyahs,
      'selected_ayah': selectedAyah,
      'waveform_zoom': waveformZoom,
    };
  }

  SessionUIState copyWith({
    bool? syncMode,
    List<int>? reviewedAyahs,
    int? selectedAyah,
    double? waveformZoom,
  }) {
    return SessionUIState(
      syncMode: syncMode ?? this.syncMode,
      reviewedAyahs: reviewedAyahs ?? this.reviewedAyahs,
      selectedAyah: selectedAyah ?? this.selectedAyah,
      waveformZoom: waveformZoom ?? this.waveformZoom,
    );
  }
}
