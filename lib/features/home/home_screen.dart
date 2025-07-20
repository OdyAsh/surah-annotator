import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../file_operations/widgets/file_picker_widget.dart';
import '../audio_playback/widgets/audio_controls.dart';
import '../audio_playback/widgets/waveform_display.dart';
import '../timestamp_annotation/widgets/timestamp_cards.dart';
import '../../core/providers/audio_providers.dart';
import '../../core/providers/timestamp_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasAudioFile = false;
  bool _hasTimestampFile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surah Annotator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: _hasAudioFile && _hasTimestampFile
          ? _buildMainInterface()
          : _buildFileLoadingInterface(),
    );
  }

  Widget _buildFileLoadingInterface() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.audiotrack,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Surah Annotator',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Load an audio file and timestamp file to begin annotating',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: FilePickerWidget(
                onAudioFileSelected: _onAudioFileSelected,
                onTimestampFileSelected: _onTimestampFileSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInterface() {
    return Column(
      children: [
        // Audio playback section
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const WaveformDisplay(),
              const SizedBox(height: 16),
              const AudioControls(),
            ],
          ),
        ),
        
        // Divider
        const Divider(height: 1),
        
        // Timestamp annotation section
        Expanded(
          child: const TimestampCards(),
        ),
      ],
    );
  }

  Future<void> _onAudioFileSelected(String filePath) async {
    try {
      // Load audio file
      await ref.read(audioControlsProvider.notifier).loadAudio(filePath);
      setState(() {
        _hasAudioFile = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load audio file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _onTimestampFileSelected(String filePath) async {
    try {
      // Load timestamp file
      await ref.read(timestampsProvider.notifier).loadFromFile(filePath);
      setState(() {
        _hasTimestampFile = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load timestamp file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
