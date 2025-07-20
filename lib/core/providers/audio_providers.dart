import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/audio_repository.dart';

// Audio Repository Provider
final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  final repository = AudioRepository();
  ref.onDispose(() => repository.dispose());
  return repository;
});

// Current Audio Position Provider (Fine-grained, real-time)
final audioPositionProvider = StreamProvider<double>((ref) {
  final audioRepository = ref.watch(audioRepositoryProvider);
  
  return audioRepository.positionStream.map((position) {
    return position.inMilliseconds / 1000.0; // Convert to seconds
  });
});

// Audio Player State Provider
final audioPlayerStateProvider = StreamProvider<bool>((ref) {
  final audioRepository = ref.watch(audioRepositoryProvider);
  return audioRepository.playingStream;
});

// Audio Duration Provider
final audioDurationProvider = Provider<double>((ref) {
  final audioRepository = ref.watch(audioRepositoryProvider);
  return audioRepository.durationSeconds;
});

// Audio File Provider
final currentAudioFileProvider = Provider((ref) {
  final audioRepository = ref.watch(audioRepositoryProvider);
  return audioRepository.currentAudioFile;
});

// Audio Controls Notifier
class AudioControlsNotifier extends StateNotifier<AsyncValue<void>> {
  final AudioRepository _audioRepository;

  AudioControlsNotifier(this._audioRepository) : super(const AsyncValue.data(null));

  Future<void> play() async {
    state = const AsyncValue.loading();
    try {
      await _audioRepository.play();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> pause() async {
    state = const AsyncValue.loading();
    try {
      await _audioRepository.pause();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> stop() async {
    state = const AsyncValue.loading();
    try {
      await _audioRepository.stop();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> seek(double seconds) async {
    try {
      await _audioRepository.seekToSeconds(seconds);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _audioRepository.setVolume(volume);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setSpeed(double speed) async {
    try {
      await _audioRepository.setSpeed(speed);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadAudio(String filePath) async {
    state = const AsyncValue.loading();
    try {
      await _audioRepository.loadAudioFile(filePath);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final audioControlsProvider = StateNotifierProvider<AudioControlsNotifier, AsyncValue<void>>((ref) {
  final audioRepository = ref.watch(audioRepositoryProvider);
  return AudioControlsNotifier(audioRepository);
});
