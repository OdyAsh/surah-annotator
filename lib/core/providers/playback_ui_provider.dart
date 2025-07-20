import 'package:flutter_riverpod/flutter_riverpod.dart';

// Playback UI State
class PlaybackUIState {
  final double volume;
  final double playbackSpeed;
  final bool showWaveform;
  final double waveformZoom;
  final bool showTimeLabels;
  final bool showMarkers;

  const PlaybackUIState({
    this.volume = 1.0,
    this.playbackSpeed = 1.0,
    this.showWaveform = true,
    this.waveformZoom = 1.0,
    this.showTimeLabels = true,
    this.showMarkers = true,
  });

  PlaybackUIState copyWith({
    double? volume,
    double? playbackSpeed,
    bool? showWaveform,
    double? waveformZoom,
    bool? showTimeLabels,
    bool? showMarkers,
  }) {
    return PlaybackUIState(
      volume: volume ?? this.volume,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      showWaveform: showWaveform ?? this.showWaveform,
      waveformZoom: waveformZoom ?? this.waveformZoom,
      showTimeLabels: showTimeLabels ?? this.showTimeLabels,
      showMarkers: showMarkers ?? this.showMarkers,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlaybackUIState &&
        other.volume == volume &&
        other.playbackSpeed == playbackSpeed &&
        other.showWaveform == showWaveform &&
        other.waveformZoom == waveformZoom &&
        other.showTimeLabels == showTimeLabels &&
        other.showMarkers == showMarkers;
  }

  @override
  int get hashCode {
    return Object.hash(
      volume,
      playbackSpeed,
      showWaveform,
      waveformZoom,
      showTimeLabels,
      showMarkers,
    );
  }
}

// Playback UI Notifier
class PlaybackUINotifier extends StateNotifier<PlaybackUIState> {
  PlaybackUINotifier() : super(const PlaybackUIState());

  void setVolume(double volume) {
    state = state.copyWith(volume: volume.clamp(0.0, 1.0));
  }

  void setPlaybackSpeed(double speed) {
    state = state.copyWith(playbackSpeed: speed.clamp(0.5, 2.0));
  }

  void toggleWaveform() {
    state = state.copyWith(showWaveform: !state.showWaveform);
  }

  void setWaveformZoom(double zoom) {
    state = state.copyWith(waveformZoom: zoom.clamp(0.1, 5.0));
  }

  void zoomIn() {
    const zoomFactor = 1.5;
    final newZoom = (state.waveformZoom * zoomFactor).clamp(0.1, 5.0);
    state = state.copyWith(waveformZoom: newZoom);
  }

  void zoomOut() {
    const zoomFactor = 1.5;
    final newZoom = (state.waveformZoom / zoomFactor).clamp(0.1, 5.0);
    state = state.copyWith(waveformZoom: newZoom);
  }

  void resetZoom() {
    state = state.copyWith(waveformZoom: 1.0);
  }

  void toggleTimeLabels() {
    state = state.copyWith(showTimeLabels: !state.showTimeLabels);
  }

  void toggleMarkers() {
    state = state.copyWith(showMarkers: !state.showMarkers);
  }

  void resetToDefaults() {
    state = const PlaybackUIState();
  }
}

// Playback UI Provider
final playbackUIProvider = StateNotifierProvider<PlaybackUINotifier, PlaybackUIState>((ref) {
  return PlaybackUINotifier();
});
