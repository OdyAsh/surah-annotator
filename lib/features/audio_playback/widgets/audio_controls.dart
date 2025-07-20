import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../core/providers/audio_providers.dart';

class AudioControls extends ConsumerWidget {
  const AudioControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(audioPlayerStateProvider).value ?? false;
    final position = ref.watch(audioPositionProvider).value ?? 0.0;
    final duration = ref.watch(audioDurationProvider);
    final audioControlsNotifier = ref.read(audioControlsProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Time display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(position),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatTime(duration),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress slider
            Slider(
              value: duration > 0 ? (position / duration).clamp(0.0, 1.0) : 0.0,
              onChanged: duration > 0 ? (value) {
                audioControlsNotifier.seek(value * duration);
              } : null,
            ),
            
            const SizedBox(height: 16),
            
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rewind button
                CustomIconButton(
                  icon: Icons.replay_10,
                  onPressed: () {
                    final newPosition = (position - 10).clamp(0.0, duration);
                    audioControlsNotifier.seek(newPosition);
                  },
                  tooltip: 'Rewind 10s',
                ),
                
                const SizedBox(width: 16),
                
                // Play/Pause button
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 32,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        audioControlsNotifier.pause();
                      } else {
                        audioControlsNotifier.play();
                      }
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Forward button
                CustomIconButton(
                  icon: Icons.forward_10,
                  onPressed: () {
                    final newPosition = (position + 10).clamp(0.0, duration);
                    audioControlsNotifier.seek(newPosition);
                  },
                  tooltip: 'Forward 10s',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(double seconds) {
    final duration = Duration(seconds: seconds.round());
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
