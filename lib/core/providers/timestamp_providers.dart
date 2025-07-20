import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ayah_timestamp.dart';
import '../repositories/timestamp_repository.dart';
import 'audio_providers.dart';

// Timestamp Repository Provider
final timestampRepositoryProvider = Provider<TimestampRepository>((ref) {
  return TimestampRepository();
});

// All Timestamps Provider
final timestampsProvider = StateNotifierProvider<TimestampsNotifier, List<AyahTimestamp>>((ref) {
  final repository = ref.watch(timestampRepositoryProvider);
  return TimestampsNotifier(repository);
});

// Current Ayah Provider (derived from audio position and timestamps)
final currentAyahProvider = Provider<AyahTimestamp?>((ref) {
  final position = ref.watch(audioPositionProvider).value;
  final timestamps = ref.watch(timestampsProvider);
  final repository = ref.watch(timestampRepositoryProvider);

  if (position == null || timestamps.isEmpty) return null;

  return repository.getCurrentAyah(position);
});

// Timestamp Validation Provider
final timestampValidationProvider = Provider<List<String>>((ref) {
  final repository = ref.watch(timestampRepositoryProvider);
  return repository.validateTimestamps();
});

// Review Progress Provider
final reviewProgressProvider = Provider<double>((ref) {
  final repository = ref.watch(timestampRepositoryProvider);
  return repository.reviewProgress;
});

// Timestamps Notifier
class TimestampsNotifier extends StateNotifier<List<AyahTimestamp>> {
  final TimestampRepository _repository;

  TimestampsNotifier(this._repository) : super([]);

  /// Load timestamps from file
  Future<void> loadFromFile(String filePath) async {
    try {
      final timestamps = await _repository.loadFromFile(filePath);
      state = timestamps;
    } catch (e) {
      rethrow;
    }
  }

  /// Save timestamps to file
  Future<void> saveToFile([String? filePath]) async {
    try {
      await _repository.saveToFile(filePath);
    } catch (e) {
      rethrow;
    }
  }

  /// Replace all timestamps
  void replaceTimestamps(List<AyahTimestamp> newTimestamps) {
    _repository.replaceTimestamps(newTimestamps);
    state = _repository.timestamps;
  }

  /// Update a single timestamp
  void updateTimestamp(AyahTimestamp updatedTimestamp) {
    _repository.updateTimestamp(updatedTimestamp);
    state = [..._repository.timestamps];
  }

  /// Update multiple timestamps
  void updateTimestamps(List<AyahTimestamp> updatedTimestamps) {
    _repository.updateTimestamps(updatedTimestamps);
    state = [..._repository.timestamps];
  }

  /// Mark ayah as reviewed
  void markAsReviewed(int ayahNumber, bool isReviewed) {
    final timestamp = _repository.getByAyahNumber(ayahNumber);
    if (timestamp != null) {
      final updated = timestamp.copyWith(isReviewed: isReviewed);
      updateTimestamp(updated);
    }
  }

  /// Resolve timestamp conflicts
  void resolveConflicts() {
    _repository.resolveConflicts();
    state = [..._repository.timestamps];
  }

  /// Clear all timestamps
  void clear() {
    _repository.clear();
    state = [];
  }

  /// Get timestamp by ayah number
  AyahTimestamp? getByAyahNumber(int ayahNumber) {
    return _repository.getByAyahNumber(ayahNumber);
  }
}

// Batch Edit Notifier for handling multiple timestamp changes
class BatchEditNotifier extends StateNotifier<List<int>> {
  BatchEditNotifier() : super([]);

  /// Add ayah to pending changes
  void addPendingChange(int ayahNumber) {
    if (!state.contains(ayahNumber)) {
      state = [...state, ayahNumber];
    }
  }

  /// Remove ayah from pending changes
  void removePendingChange(int ayahNumber) {
    state = state.where((ayah) => ayah != ayahNumber).toList();
  }

  /// Clear all pending changes
  void clearPendingChanges() {
    state = [];
  }

  /// Check if ayah has pending changes
  bool hasPendingChanges(int ayahNumber) {
    return state.contains(ayahNumber);
  }

  /// Get all pending changes
  List<int> get pendingChanges => state;

  /// Check if there are any pending changes
  bool get hasAnyPendingChanges => state.isNotEmpty;
}

final batchEditProvider = StateNotifierProvider<BatchEditNotifier, List<int>>((ref) {
  return BatchEditNotifier();
});
