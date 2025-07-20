import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/audio_providers.dart';

class WaveformDisplay extends ConsumerStatefulWidget {
  const WaveformDisplay({super.key});

  @override
  ConsumerState<WaveformDisplay> createState() => _WaveformDisplayState();
}

class _WaveformDisplayState extends ConsumerState<WaveformDisplay> {
  @override
  Widget build(BuildContext context) {
    final currentAudioFile = ref.watch(currentAudioFileProvider);
    final position = ref.watch(audioPositionProvider).value ?? 0.0;
    final duration = ref.watch(audioDurationProvider);
    
    if (currentAudioFile == null) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text('No audio file loaded'),
        ),
      );
    }

    return Card(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Audio file name
            Text(
              currentAudioFile.displayName,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 16),
            
            // Waveform visualization (placeholder)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // Mock waveform bars
                    _buildMockWaveform(context),
                    
                    // Progress overlay
                    if (duration > 0)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 64) * (position / duration),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    
                    // Position indicator
                    if (duration > 0)
                      Positioned(
                        left: (MediaQuery.of(context).size.width - 64) * (position / duration) - 1,
                        top: 0,
                        child: Container(
                          width: 2,
                          height: double.infinity,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      
                    // Clickable overlay for seeking
                    Positioned.fill(
                      child: GestureDetector(
                        onTapDown: (details) {
                          if (duration > 0) {
                            final tapPosition = details.localPosition.dx;
                            final containerWidth = MediaQuery.of(context).size.width - 64;
                            final seekPosition = (tapPosition / containerWidth) * duration;
                            ref.read(audioControlsProvider.notifier).seek(seekPosition);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockWaveform(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(100, (index) {
        final height = (20 + (index % 30)) * 2.0;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0.5),
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      }),
    );
  }
}
