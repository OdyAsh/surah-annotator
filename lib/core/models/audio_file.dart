class AudioFile {
  final String name;
  final String path;
  final Duration duration;
  final String format;
  final int fileSize;
  final DateTime createdAt;

  const AudioFile({
    required this.name,
    required this.path,
    required this.duration,
    required this.format,
    required this.fileSize,
    required this.createdAt,
  });

  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      name: json['name'] as String,
      path: json['path'] as String,
      duration: Duration(microseconds: json['duration_microseconds'] as int),
      format: json['format'] as String,
      fileSize: json['file_size'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'duration_microseconds': duration.inMicroseconds,
      'format': format,
      'file_size': fileSize,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get displayName => name.replaceFirst(RegExp(r'\.[^.]*$'), '');

  String get sizeFormatted {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String get durationFormatted {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioFile &&
        other.name == name &&
        other.path == path &&
        other.duration == duration &&
        other.format == format &&
        other.fileSize == fileSize &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(name, path, duration, format, fileSize, createdAt);
  }

  @override
  String toString() {
    return 'AudioFile(name: $name, path: $path, duration: $duration, format: $format, fileSize: $fileSize, createdAt: $createdAt)';
  }
}
