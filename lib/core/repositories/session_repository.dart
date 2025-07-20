import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/session_data.dart';
import '../models/audio_file.dart';

class SessionRepository {
  static const String _sessionFileName = 'session.json';
  SessionData? _currentSession;

  SessionData? get currentSession => _currentSession;
  bool get hasSession => _currentSession != null;

  /// Create a new session
  Future<SessionData> createSession({
    AudioFile? audioFile,
    String? timestampFilePath,
  }) async {
    final sessionId = const Uuid().v4();
    final now = DateTime.now();

    _currentSession = SessionData(
      sessionId: sessionId,
      audioFile: audioFile,
      timestampFilePath: timestampFilePath,
      createdAt: now,
      updatedAt: now,
    );

    await _saveSession();
    return _currentSession!;
  }

  /// Load session from file
  Future<SessionData?> loadSession() async {
    try {
      final sessionFile = await _getSessionFile();
      if (!await sessionFile.exists()) {
        return null;
      }

      final content = await sessionFile.readAsString();
      final jsonData = json.decode(content) as Map<String, dynamic>;
      
      _currentSession = SessionData.fromJson(jsonData);
      return _currentSession;
    } catch (e) {
      // If session loading fails, return null to start fresh
      return null;
    }
  }

  /// Save current session
  Future<void> saveSession() async {
    if (_currentSession == null) return;
    
    _currentSession = _currentSession!.copyWith(
      updatedAt: DateTime.now(),
    );
    
    await _saveSession();
  }

  /// Update session data
  Future<void> updateSession({
    AudioFile? audioFile,
    String? timestampFilePath,
    double? currentPosition,
    int? lastAyah,
    List<int>? unsavedChanges,
    SessionUIState? uiState,
  }) async {
    if (_currentSession == null) return;

    _currentSession = _currentSession!.copyWith(
      audioFile: audioFile ?? _currentSession!.audioFile,
      timestampFilePath: timestampFilePath ?? _currentSession!.timestampFilePath,
      currentPosition: currentPosition ?? _currentSession!.currentPosition,
      lastAyah: lastAyah ?? _currentSession!.lastAyah,
      unsavedChanges: unsavedChanges ?? _currentSession!.unsavedChanges,
      uiState: uiState ?? _currentSession!.uiState,
      updatedAt: DateTime.now(),
    );

    await _saveSession();
  }

  /// Add unsaved change
  Future<void> addUnsavedChange(int ayahNumber) async {
    if (_currentSession == null) return;

    final currentChanges = List<int>.from(_currentSession!.unsavedChanges);
    if (!currentChanges.contains(ayahNumber)) {
      currentChanges.add(ayahNumber);
      
      await updateSession(unsavedChanges: currentChanges);
    }
  }

  /// Remove unsaved change
  Future<void> removeUnsavedChange(int ayahNumber) async {
    if (_currentSession == null) return;

    final currentChanges = List<int>.from(_currentSession!.unsavedChanges);
    if (currentChanges.contains(ayahNumber)) {
      currentChanges.remove(ayahNumber);
      
      await updateSession(unsavedChanges: currentChanges);
    }
  }

  /// Clear all unsaved changes
  Future<void> clearUnsavedChanges() async {
    if (_currentSession == null) return;
    
    await updateSession(unsavedChanges: []);
  }

  /// Update UI state
  Future<void> updateUIState({
    bool? syncMode,
    List<int>? reviewedAyahs,
    int? selectedAyah,
    double? waveformZoom,
  }) async {
    if (_currentSession == null) return;

    final currentUIState = _currentSession!.uiState;
    final newUIState = currentUIState.copyWith(
      syncMode: syncMode,
      reviewedAyahs: reviewedAyahs,
      selectedAyah: selectedAyah,
      waveformZoom: waveformZoom,
    );

    await updateSession(uiState: newUIState);
  }

  /// Add reviewed ayah
  Future<void> addReviewedAyah(int ayahNumber) async {
    if (_currentSession == null) return;

    final reviewedAyahs = List<int>.from(_currentSession!.uiState.reviewedAyahs);
    if (!reviewedAyahs.contains(ayahNumber)) {
      reviewedAyahs.add(ayahNumber);
      
      await updateUIState(reviewedAyahs: reviewedAyahs);
    }
  }

  /// Remove reviewed ayah
  Future<void> removeReviewedAyah(int ayahNumber) async {
    if (_currentSession == null) return;

    final reviewedAyahs = List<int>.from(_currentSession!.uiState.reviewedAyahs);
    if (reviewedAyahs.contains(ayahNumber)) {
      reviewedAyahs.remove(ayahNumber);
      
      await updateUIState(reviewedAyahs: reviewedAyahs);
    }
  }

  /// Clear session
  Future<void> clearSession() async {
    _currentSession = null;
    
    final sessionFile = await _getSessionFile();
    if (await sessionFile.exists()) {
      await sessionFile.delete();
    }
  }

  /// Get session directory
  Future<Directory> getSessionDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final sessionDir = Directory('${documentsDir.path}/SurahAnnotator');
    
    if (!await sessionDir.exists()) {
      await sessionDir.create(recursive: true);
    }
    
    return sessionDir;
  }

  /// Export session to file
  Future<String> exportSession(String exportPath) async {
    if (_currentSession == null) {
      throw Exception('No session to export');
    }

    final file = File(exportPath);
    final jsonContent = const JsonEncoder.withIndent('  ').convert(_currentSession!.toJson());
    
    await file.writeAsString(jsonContent);
    return exportPath;
  }

  /// Import session from file
  Future<SessionData> importSession(String importPath) async {
    final file = File(importPath);
    if (!await file.exists()) {
      throw Exception('Session file does not exist: $importPath');
    }

    final content = await file.readAsString();
    final jsonData = json.decode(content) as Map<String, dynamic>;
    
    _currentSession = SessionData.fromJson(jsonData);
    await _saveSession();
    
    return _currentSession!;
  }

  /// Private method to save session to file
  Future<void> _saveSession() async {
    if (_currentSession == null) return;

    try {
      final sessionFile = await _getSessionFile();
      final jsonContent = const JsonEncoder.withIndent('  ').convert(_currentSession!.toJson());
      
      await sessionFile.writeAsString(jsonContent);
    } catch (e) {
      throw Exception('Failed to save session: $e');
    }
  }

  /// Private method to get session file
  Future<File> _getSessionFile() async {
    final sessionDir = await getSessionDirectory();
    return File('${sessionDir.path}/$_sessionFileName');
  }
}
