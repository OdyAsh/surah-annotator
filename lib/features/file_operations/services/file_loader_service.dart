import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileLoaderService {
  static const List<String> supportedAudioFormats = [
    'mp3', 'wav', 'm4a', 'aac', 'ogg', 'flac'
  ];

  static const List<String> supportedTimestampFormats = ['json'];

  /// Pick and load timestamp file
  Future<String> pickTimestampFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedTimestampFormats,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No file selected');
      }

      final platformFile = result.files.first;
      final filePath = platformFile.path;

      if (filePath == null) {
        throw Exception('Invalid file path');
      }

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found');
      }

      return filePath;
    } catch (e) {
      throw Exception('Failed to load timestamp file: $e');
    }
  }

  /// Pick audio file
  Future<String> pickAudioFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedAudioFormats,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No file selected');
      }

      final platformFile = result.files.first;
      final filePath = platformFile.path;

      if (filePath == null) {
        throw Exception('Invalid file path');
      }

      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found');
      }

      return filePath;
    } catch (e) {
      throw Exception('Failed to load audio file: $e');
    }
  }

  /// Get supported audio file extensions for file picker
  List<String> get supportedAudioExtensions => supportedAudioFormats;

  /// Get supported timestamp file extensions for file picker
  List<String> get supportedTimestampExtensions => supportedTimestampFormats;
}
