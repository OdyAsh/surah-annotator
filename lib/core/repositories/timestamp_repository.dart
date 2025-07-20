import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/ayah_timestamp.dart';

class TimestampRepository {
  List<AyahTimestamp> _timestamps = [];
  String? _currentFilePath;

  List<AyahTimestamp> get timestamps => List.unmodifiable(_timestamps);
  String? get currentFilePath => _currentFilePath;

  /// Load timestamps from JSON file
  Future<List<AyahTimestamp>> loadFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Timestamp file does not exist: $filePath');
      }

      final content = await file.readAsString();
      final List<dynamic> jsonList = json.decode(content);
      
      _timestamps = jsonList
          .map((json) => AyahTimestamp.fromJson(json as Map<String, dynamic>))
          .toList();
      
      // Sort by ayah number to ensure correct order
      _timestamps.sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber));
      
      _currentFilePath = filePath;
      return _timestamps;
    } catch (e) {
      throw Exception('Failed to load timestamps: $e');
    }
  }

  /// Save timestamps to JSON file
  Future<void> saveToFile([String? filePath]) async {
    try {
      final path = filePath ?? _currentFilePath;
      if (path == null) {
        throw Exception('No file path specified for saving timestamps');
      }

      final file = File(path);
      final jsonList = _timestamps.map((timestamp) => timestamp.toJson()).toList();
      final content = const JsonEncoder.withIndent('  ').convert(jsonList);
      
      await file.writeAsString(content);
      _currentFilePath = path;
    } catch (e) {
      throw Exception('Failed to save timestamps: $e');
    }
  }

  /// Replace all timestamps with new data
  void replaceTimestamps(List<AyahTimestamp> newTimestamps) {
    _timestamps = List.from(newTimestamps);
    _timestamps.sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber));
  }

  /// Update a single timestamp
  void updateTimestamp(AyahTimestamp updatedTimestamp) {
    final index = _timestamps.indexWhere(
      (t) => t.ayahNumber == updatedTimestamp.ayahNumber,
    );
    
    if (index != -1) {
      _timestamps[index] = updatedTimestamp;
    }
  }

  /// Update multiple timestamps
  void updateTimestamps(List<AyahTimestamp> updatedTimestamps) {
    for (final updated in updatedTimestamps) {
      updateTimestamp(updated);
    }
  }

  /// Get timestamp by ayah number
  AyahTimestamp? getByAyahNumber(int ayahNumber) {
    try {
      return _timestamps.firstWhere((t) => t.ayahNumber == ayahNumber);
    } catch (e) {
      return null;
    }
  }

  /// Get current ayah based on position
  AyahTimestamp? getCurrentAyah(double position) {
    for (final timestamp in _timestamps) {
      if (position >= timestamp.startTime && position <= timestamp.endTime) {
        return timestamp;
      }
    }
    return null;
  }

  /// Validate timestamps for conflicts
  List<String> validateTimestamps() {
    final errors = <String>[];
    
    for (int i = 0; i < _timestamps.length - 1; i++) {
      final current = _timestamps[i];
      final next = _timestamps[i + 1];
      
      // Check for overlaps
      if (current.endTime > next.startTime) {
        errors.add(
          'Ayah ${current.ayahNumber} overlaps with Ayah ${next.ayahNumber}: '
          '${current.endTime}s > ${next.startTime}s'
        );
      }
      
      // Check for invalid durations
      if (current.startTime >= current.endTime) {
        errors.add(
          'Ayah ${current.ayahNumber} has invalid duration: '
          'start (${current.startTime}s) >= end (${current.endTime}s)'
        );
      }
    }
    
    return errors;
  }

  /// Auto-resolve overlapping timestamps
  void resolveConflicts() {
    for (int i = 0; i < _timestamps.length - 1; i++) {
      final current = _timestamps[i];
      final next = _timestamps[i + 1];
      
      if (current.endTime > next.startTime) {
        // Adjust the boundary to the midpoint
        final midpoint = (current.endTime + next.startTime) / 2;
        
        _timestamps[i] = current.copyWith(endTime: midpoint);
        _timestamps[i + 1] = next.copyWith(startTime: midpoint);
      }
    }
  }

  /// Get default save directory
  Future<Directory> getDefaultSaveDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final surahDir = Directory('${documentsDir.path}/SurahAnnotator');
    
    if (!await surahDir.exists()) {
      await surahDir.create(recursive: true);
    }
    
    return surahDir;
  }

  /// Clear all timestamps
  void clear() {
    _timestamps.clear();
    _currentFilePath = null;
  }

  /// Get total number of reviewed ayahs
  int get reviewedCount => _timestamps.where((t) => t.isReviewed).length;

  /// Get total number of ayahs
  int get totalCount => _timestamps.length;

  /// Get review progress (0.0 to 1.0)
  double get reviewProgress {
    if (totalCount == 0) return 0.0;
    return reviewedCount / totalCount;
  }
}
