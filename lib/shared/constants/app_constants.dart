class AppConstants {
  // App Info
  static const String appName = 'Surah Annotator';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A Flutter app for annotating Quranic audio with precise timestamps.';

  // File Extensions
  static const List<String> supportedAudioFormats = [
    'mp3',
    'wav',
    'm4a',
    'aac',
    'ogg',
    'flac',
  ];

  static const List<String> supportedTimestampFormats = [
    'json',
  ];

  // Audio Settings
  static const double defaultVolume = 1.0;
  static const double defaultPlaybackSpeed = 1.0;
  static const double minPlaybackSpeed = 0.5;
  static const double maxPlaybackSpeed = 2.0;

  // UI Settings
  static const double defaultWaveformZoom = 1.0;
  static const double minWaveformZoom = 0.1;
  static const double maxWaveformZoom = 5.0;
  static const Duration autoSaveInterval = Duration(seconds: 30);
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Layout Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardElevation = 2.0;

  // Audio Player Constants
  static const double waveformHeight = 100.0;
  static const double markerWidth = 2.0;
  static const double markerHeight = 80.0;
  static const int positionStreamIntervalMs = 16; // ~60fps

  // Timestamp Constants
  static const double minAyahDuration = 0.5; // minimum 0.5 seconds
  static const double maxOverlapTolerance = 0.1; // 0.1 seconds overlap tolerance

  // File Size Limits
  static const int maxAudioFileSize = 500 * 1024 * 1024; // 500MB
  static const int maxTimestampFileSize = 10 * 1024 * 1024; // 10MB

  // Error Messages
  static const String audioLoadError = 'Failed to load audio file';
  static const String timestampLoadError = 'Failed to load timestamp file';
  static const String saveError = 'Failed to save file';
  static const String fileNotFoundError = 'File not found';
  static const String unsupportedFormatError = 'Unsupported file format';
  static const String fileSizeExceededError = 'File size exceeded limit';

  // Success Messages
  static const String audioLoadSuccess = 'Audio loaded successfully';
  static const String timestampLoadSuccess = 'Timestamps loaded successfully';
  static const String saveSuccess = 'File saved successfully';
  static const String exportSuccess = 'Session exported successfully';
  static const String importSuccess = 'Session imported successfully';

  // Validation Messages
  static const String timestampConflictWarning = 'Timestamp conflicts detected';
  static const String invalidTimestampError = 'Invalid timestamp values';
  static const String emptyTimestampError = 'No timestamps found';

  // Feature Flags
  static const bool enableAutoSave = true;
  static const bool enableTimestampValidation = true;
  static const bool enableBatchEdit = true;
  static const bool enableWaveformDisplay = true;

  // Debug Settings
  static const bool enableDebugMode = false;
  static const bool enablePerformanceMonitoring = false;
}
