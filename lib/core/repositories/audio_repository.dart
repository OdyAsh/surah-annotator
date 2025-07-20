import 'dart:io';
import 'package:just_audio/just_audio.dart';
import '../models/audio_file.dart';

class AudioRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioFile? _currentAudioFile;
  
  AudioPlayer get audioPlayer => _audioPlayer;
  AudioFile? get currentAudioFile => _currentAudioFile;
  bool get hasAudio => _currentAudioFile != null;

  /// Load audio file and return AudioFile model
  Future<AudioFile> loadAudioFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Audio file does not exist: $filePath');
      }

      // Load audio into player
      await _audioPlayer.setFilePath(filePath);
      
      // Get file stats
      final stats = await file.stat();
      final duration = _audioPlayer.duration ?? Duration.zero;
      
      // Extract file info
      final fileName = filePath.split(Platform.pathSeparator).last;
      final fileExtension = fileName.split('.').last.toLowerCase();
      
      _currentAudioFile = AudioFile(
        name: fileName,
        path: filePath,
        duration: duration,
        format: fileExtension,
        fileSize: stats.size,
        createdAt: stats.modified,
      );

      return _currentAudioFile!;
    } catch (e) {
      throw Exception('Failed to load audio file: $e');
    }
  }

  /// Play audio
  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  /// Pause audio
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      throw Exception('Failed to pause audio: $e');
    }
  }

  /// Stop audio
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      throw Exception('Failed to stop audio: $e');
    }
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      throw Exception('Failed to seek to position: $e');
    }
  }

  /// Seek to seconds
  Future<void> seekToSeconds(double seconds) async {
    try {
      final duration = Duration(milliseconds: (seconds * 1000).round());
      await seek(duration);
    } catch (e) {
      throw Exception('Failed to seek to seconds: $e');
    }
  }

  /// Get current position in seconds
  double get currentPositionSeconds {
    final position = _audioPlayer.position;
    return position.inMilliseconds / 1000.0;
  }

  /// Get duration in seconds
  double get durationSeconds {
    final duration = _audioPlayer.duration ?? Duration.zero;
    return duration.inMilliseconds / 1000.0;
  }

  /// Get position stream
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// Get player state stream
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  /// Get playing state stream
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  /// Check if audio is playing
  bool get isPlaying => _audioPlayer.playing;

  /// Check if audio is paused
  bool get isPaused => !_audioPlayer.playing && _audioPlayer.position != Duration.zero;

  /// Check if audio is stopped
  bool get isStopped => !_audioPlayer.playing && _audioPlayer.position == Duration.zero;

  /// Get supported audio formats
  static List<String> get supportedFormats => [
    'mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'
  ];

  /// Check if file format is supported
  static bool isFormatSupported(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return supportedFormats.contains(extension);
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      throw Exception('Failed to set volume: $e');
    }
  }

  /// Set playback speed (0.5 to 2.0)
  Future<void> setSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed.clamp(0.5, 2.0));
    } catch (e) {
      throw Exception('Failed to set playback speed: $e');
    }
  }

  /// Release resources
  Future<void> dispose() async {
    try {
      await _audioPlayer.dispose();
      _currentAudioFile = null;
    } catch (e) {
      // Ignore disposal errors
    }
  }

  /// Clear current audio
  void clear() {
    _audioPlayer.stop();
    _currentAudioFile = null;
  }

  /// Get audio file info without loading into player
  static Future<AudioFile> getFileInfo(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('Audio file does not exist: $filePath');
    }

    final stats = await file.stat();
    final fileName = filePath.split(Platform.pathSeparator).last;
    final fileExtension = fileName.split('.').last.toLowerCase();

    // Create a temporary player to get duration
    final tempPlayer = AudioPlayer();
    Duration duration = Duration.zero;
    
    try {
      await tempPlayer.setFilePath(filePath);
      duration = tempPlayer.duration ?? Duration.zero;
    } catch (e) {
      // If we can't get duration, that's okay
    } finally {
      await tempPlayer.dispose();
    }

    return AudioFile(
      name: fileName,
      path: filePath,
      duration: duration,
      format: fileExtension,
      fileSize: stats.size,
      createdAt: stats.modified,
    );
  }
}
