import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../../../core/models/ayah_timestamp.dart';
import '../../../core/providers/timestamp_providers.dart';
import '../../../core/providers/audio_providers.dart';
import 'timestamp_card.dart';

class TimestampCards extends ConsumerStatefulWidget {
  const TimestampCards({super.key});

  @override
  ConsumerState<TimestampCards> createState() => _TimestampCardsState();
}

class _TimestampCardsState extends ConsumerState<TimestampCards> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timestamps = ref.watch(timestampsProvider);
    final currentAyah = ref.watch(currentAyahProvider);
    final pendingChanges = ref.watch(batchEditProvider);

    if (timestamps.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No timestamps loaded',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Load a timestamp file to begin annotation',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header with sync controls and batch actions
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Ayah Timestamps',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              
              // Sync to current ayah button
              CustomTextButton(
                text: 'Sync to Current',
                icon: Icons.my_location,
                onPressed: currentAyah != null ? () => _scrollToAyah(currentAyah) : null,
              ),
              
              const SizedBox(width: 16),
              
              // Batch changes indicator and action
              if (pendingChanges.isNotEmpty) ...[
                Chip(
                  label: Text('${pendingChanges.length} pending'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                CustomElevatedButton(
                  text: 'Apply Changes',
                  onPressed: _applyPendingChanges,
                ),
              ],
            ],
          ),
        ),
        
        // Timestamp list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: timestamps.length,
            itemBuilder: (context, index) {
              final timestamp = timestamps[index];
              final isCurrentlyPlaying = currentAyah?.ayahNumber == timestamp.ayahNumber;
              final hasPendingChanges = pendingChanges.contains(timestamp.ayahNumber);
              
              return TimestampCard(
                key: ValueKey(timestamp.ayahNumber),
                timestamp: timestamp,
                isCurrentlyPlaying: isCurrentlyPlaying,
                hasPendingChanges: hasPendingChanges,
                onTimestampChanged: (updatedTimestamp) {
                  _onTimestampChanged(updatedTimestamp);
                },
                onSeekToStart: () => _seekTo(timestamp.startTime),
                onSeekToEnd: () => _seekTo(timestamp.endTime),
                onToggleReviewed: () => _toggleReviewed(timestamp),
              );
            },
          ),
        ),
      ],
    );
  }

  void _scrollToAyah(AyahTimestamp ayah) {
    final timestamps = ref.read(timestampsProvider);
    final index = timestamps.indexWhere((t) => t.ayahNumber == ayah.ayahNumber);
    
    if (index != -1 && _scrollController.hasClients) {
      const itemHeight = 120.0; // Approximate height of each card
      final offset = index * itemHeight;
      
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onTimestampChanged(AyahTimestamp updatedTimestamp) {
    // Add to pending changes
    ref.read(batchEditProvider.notifier).addPendingChange(updatedTimestamp.ayahNumber);
    
    // Update the timestamp in the repository
    ref.read(timestampsProvider.notifier).updateTimestamp(updatedTimestamp);
  }

  void _seekTo(double seconds) {
    ref.read(audioControlsProvider.notifier).seek(seconds);
  }

  void _toggleReviewed(AyahTimestamp timestamp) {
    final updatedTimestamp = timestamp.copyWith(isReviewed: !timestamp.isReviewed);
    ref.read(timestampsProvider.notifier).updateTimestamp(updatedTimestamp);
  }

  void _applyPendingChanges() {
    final pendingChanges = ref.read(batchEditProvider);
    
    if (pendingChanges.isEmpty) return;
    
    // Resolve conflicts if any
    ref.read(timestampsProvider.notifier).resolveConflicts();
    
    // Save timestamps
    ref.read(timestampsProvider.notifier).saveToFile();
    
    // Clear pending changes
    ref.read(batchEditProvider.notifier).clearPendingChanges();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied ${pendingChanges.length} changes'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
