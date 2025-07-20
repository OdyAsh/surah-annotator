import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/custom_buttons.dart';
import '../services/file_loader_service.dart';

class FilePickerWidget extends ConsumerStatefulWidget {
  final Function(String)? onAudioFileSelected;
  final Function(String)? onTimestampFileSelected;
  final bool showAudioPicker;
  final bool showTimestampPicker;

  const FilePickerWidget({
    super.key,
    this.onAudioFileSelected,
    this.onTimestampFileSelected,
    this.showAudioPicker = true,
    this.showTimestampPicker = true,
  });

  @override
  ConsumerState<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends ConsumerState<FilePickerWidget> {
  final _fileLoaderService = FileLoaderService();
  bool _isLoadingAudio = false;
  bool _isLoadingTimestamp = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Load Files',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            if (widget.showAudioPicker) ...[
              CustomElevatedButton(
                text: 'Select Audio File',
                icon: Icons.audiotrack,
                isLoading: _isLoadingAudio,
                onPressed: _isLoadingAudio ? null : _pickAudioFile,
              ),
              const SizedBox(height: 8),
              Text(
                'Supported formats: ${_fileLoaderService.supportedAudioExtensions.join(', ').toUpperCase()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
            ],
            
            if (widget.showTimestampPicker) ...[
              CustomElevatedButton(
                text: 'Select Timestamp File',
                icon: Icons.schedule,
                isLoading: _isLoadingTimestamp,
                onPressed: _isLoadingTimestamp ? null : _pickTimestampFile,
              ),
              const SizedBox(height: 8),
              Text(
                'Supported formats: ${_fileLoaderService.supportedTimestampExtensions.join(', ').toUpperCase()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickAudioFile() async {
    setState(() {
      _isLoadingAudio = true;
    });

    try {
      final filePath = await _fileLoaderService.pickAudioFile();
      widget.onAudioFileSelected?.call(filePath);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio file loaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading audio file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
      }
    }
  }

  Future<void> _pickTimestampFile() async {
    setState(() {
      _isLoadingTimestamp = true;
    });

    try {
      final filePath = await _fileLoaderService.pickTimestampFile();
      widget.onTimestampFileSelected?.call(filePath);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timestamp file loaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading timestamp file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTimestamp = false;
        });
      }
    }
  }
}
