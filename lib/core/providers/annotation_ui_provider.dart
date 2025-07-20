import 'package:flutter_riverpod/flutter_riverpod.dart';

// Annotation UI State
class AnnotationUIState {
  final bool syncMode;
  final int? selectedAyah;
  final List<int> expandedAyahs;
  final bool showTimestampValidation;
  final bool batchEditMode;

  const AnnotationUIState({
    this.syncMode = true,
    this.selectedAyah,
    this.expandedAyahs = const [],
    this.showTimestampValidation = false,
    this.batchEditMode = false,
  });

  AnnotationUIState copyWith({
    bool? syncMode,
    int? selectedAyah,
    List<int>? expandedAyahs,
    bool? showTimestampValidation,
    bool? batchEditMode,
  }) {
    return AnnotationUIState(
      syncMode: syncMode ?? this.syncMode,
      selectedAyah: selectedAyah ?? this.selectedAyah,
      expandedAyahs: expandedAyahs ?? this.expandedAyahs,
      showTimestampValidation: showTimestampValidation ?? this.showTimestampValidation,
      batchEditMode: batchEditMode ?? this.batchEditMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnnotationUIState &&
        other.syncMode == syncMode &&
        other.selectedAyah == selectedAyah &&
        other.expandedAyahs == expandedAyahs &&
        other.showTimestampValidation == showTimestampValidation &&
        other.batchEditMode == batchEditMode;
  }

  @override
  int get hashCode {
    return Object.hash(
      syncMode,
      selectedAyah,
      expandedAyahs,
      showTimestampValidation,
      batchEditMode,
    );
  }
}

// Annotation UI Notifier
class AnnotationUINotifier extends StateNotifier<AnnotationUIState> {
  AnnotationUINotifier() : super(const AnnotationUIState());

  void toggleSyncMode() {
    state = state.copyWith(syncMode: !state.syncMode);
  }

  void setSyncMode(bool enabled) {
    state = state.copyWith(syncMode: enabled);
  }

  void setSelectedAyah(int? ayahNumber) {
    state = state.copyWith(selectedAyah: ayahNumber);
  }

  void expandAyah(int ayahNumber) {
    if (!state.expandedAyahs.contains(ayahNumber)) {
      state = state.copyWith(
        expandedAyahs: [...state.expandedAyahs, ayahNumber],
      );
    }
  }

  void collapseAyah(int ayahNumber) {
    state = state.copyWith(
      expandedAyahs: state.expandedAyahs.where((ayah) => ayah != ayahNumber).toList(),
    );
  }

  void toggleAyahExpansion(int ayahNumber) {
    if (state.expandedAyahs.contains(ayahNumber)) {
      collapseAyah(ayahNumber);
    } else {
      expandAyah(ayahNumber);
    }
  }

  void showTimestampValidation() {
    state = state.copyWith(showTimestampValidation: true);
  }

  void hideTimestampValidation() {
    state = state.copyWith(showTimestampValidation: false);
  }

  void toggleTimestampValidation() {
    state = state.copyWith(showTimestampValidation: !state.showTimestampValidation);
  }

  void enableBatchEditMode() {
    state = state.copyWith(batchEditMode: true);
  }

  void disableBatchEditMode() {
    state = state.copyWith(batchEditMode: false);
  }

  void toggleBatchEditMode() {
    state = state.copyWith(batchEditMode: !state.batchEditMode);
  }
}

// Annotation UI Provider
final annotationUIProvider = StateNotifierProvider<AnnotationUINotifier, AnnotationUIState>((ref) {
  return AnnotationUINotifier();
});
