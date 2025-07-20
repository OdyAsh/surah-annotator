import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_data.dart';
import '../repositories/session_repository.dart';

// Session Repository Provider
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository();
});

// Current Session Provider
final currentSessionProvider = StateNotifierProvider<SessionNotifier, SessionData?>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return SessionNotifier(repository);
});

// Session UI State Provider
final sessionUIStateProvider = Provider<SessionUIState>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.uiState ?? const SessionUIState();
});

// Sync Mode Provider
final syncModeProvider = Provider<bool>((ref) {
  final uiState = ref.watch(sessionUIStateProvider);
  return uiState.syncMode;
});

// Selected Ayah Provider
final selectedAyahProvider = Provider<int?>((ref) {
  final uiState = ref.watch(sessionUIStateProvider);
  return uiState.selectedAyah;
});

// Reviewed Ayahs Provider
final reviewedAyahsProvider = Provider<List<int>>((ref) {
  final uiState = ref.watch(sessionUIStateProvider);
  return uiState.reviewedAyahs;
});

// Unsaved Changes Provider
final unsavedChangesProvider = Provider<List<int>>((ref) {
  final session = ref.watch(currentSessionProvider);
  return session?.unsavedChanges ?? [];
});

// Session Notifier
class SessionNotifier extends StateNotifier<SessionData?> {
  final SessionRepository _repository;

  SessionNotifier(this._repository) : super(null) {
    _loadSession();
  }

  /// Load session from repository
  Future<void> _loadSession() async {
    try {
      final session = await _repository.loadSession();
      state = session;
    } catch (e) {
      // If loading fails, start with null session
      state = null;
    }
  }

  /// Create new session
  Future<void> createSession({
    String? audioFilePath,
    String? timestampFilePath,
  }) async {
    try {
      final session = await _repository.createSession(
        timestampFilePath: timestampFilePath,
      );
      state = session;
    } catch (e) {
      rethrow;
    }
  }

  /// Update session
  Future<void> updateSession({
    String? audioFilePath,
    String? timestampFilePath,
    double? currentPosition,
    int? lastAyah,
    List<int>? unsavedChanges,
    SessionUIState? uiState,
  }) async {
    try {
      await _repository.updateSession(
        timestampFilePath: timestampFilePath,
        currentPosition: currentPosition,
        lastAyah: lastAyah,
        unsavedChanges: unsavedChanges,
        uiState: uiState,
      );
      state = _repository.currentSession;
    } catch (e) {
      rethrow;
    }
  }

  /// Update current position
  Future<void> updatePosition(double position) async {
    await updateSession(currentPosition: position);
  }

  /// Set last played ayah
  Future<void> setLastAyah(int ayahNumber) async {
    await updateSession(lastAyah: ayahNumber);
  }

  /// Toggle sync mode
  Future<void> toggleSyncMode() async {
    final currentUIState = state?.uiState ?? const SessionUIState();
    final newUIState = currentUIState.copyWith(syncMode: !currentUIState.syncMode);
    await updateSession(uiState: newUIState);
  }

  /// Set selected ayah
  Future<void> setSelectedAyah(int? ayahNumber) async {
    final currentUIState = state?.uiState ?? const SessionUIState();
    final newUIState = currentUIState.copyWith(selectedAyah: ayahNumber);
    await updateSession(uiState: newUIState);
  }

  /// Add unsaved change
  Future<void> addUnsavedChange(int ayahNumber) async {
    await _repository.addUnsavedChange(ayahNumber);
    state = _repository.currentSession;
  }

  /// Remove unsaved change
  Future<void> removeUnsavedChange(int ayahNumber) async {
    await _repository.removeUnsavedChange(ayahNumber);
    state = _repository.currentSession;
  }

  /// Clear unsaved changes
  Future<void> clearUnsavedChanges() async {
    await _repository.clearUnsavedChanges();
    state = _repository.currentSession;
  }

  /// Add reviewed ayah
  Future<void> addReviewedAyah(int ayahNumber) async {
    await _repository.addReviewedAyah(ayahNumber);
    state = _repository.currentSession;
  }

  /// Remove reviewed ayah
  Future<void> removeReviewedAyah(int ayahNumber) async {
    await _repository.removeReviewedAyah(ayahNumber);
    state = _repository.currentSession;
  }

  /// Clear session
  Future<void> clearSession() async {
    await _repository.clearSession();
    state = null;
  }

  /// Save session
  Future<void> saveSession() async {
    await _repository.saveSession();
    state = _repository.currentSession;
  }

  /// Export session
  Future<String> exportSession(String exportPath) async {
    return await _repository.exportSession(exportPath);
  }

  /// Import session
  Future<void> importSession(String importPath) async {
    final session = await _repository.importSession(importPath);
    state = session;
  }
}

// Auto-save Notifier
class AutoSaveNotifier extends StateNotifier<bool> {
  AutoSaveNotifier() : super(false);

  void setAutoSaveEnabled(bool enabled) {
    state = enabled;
  }

  bool get isEnabled => state;
}

final autoSaveProvider = StateNotifierProvider<AutoSaveNotifier, bool>((ref) {
  return AutoSaveNotifier();
});
