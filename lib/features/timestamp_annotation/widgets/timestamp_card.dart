import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/models/ayah_timestamp.dart';
import '../../../shared/widgets/custom_buttons.dart';

class TimestampCard extends StatefulWidget {
  final AyahTimestamp timestamp;
  final bool isCurrentlyPlaying;
  final bool hasPendingChanges;
  final Function(AyahTimestamp) onTimestampChanged;
  final VoidCallback onSeekToStart;
  final VoidCallback onSeekToEnd;
  final VoidCallback onToggleReviewed;

  const TimestampCard({
    super.key,
    required this.timestamp,
    this.isCurrentlyPlaying = false,
    this.hasPendingChanges = false,
    required this.onTimestampChanged,
    required this.onSeekToStart,
    required this.onSeekToEnd,
    required this.onToggleReviewed,
  });

  @override
  State<TimestampCard> createState() => _TimestampCardState();
}

class _TimestampCardState extends State<TimestampCard> {
  late TextEditingController _startController;
  late TextEditingController _endController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(
      text: _formatTime(widget.timestamp.startTime),
    );
    _endController = TextEditingController(
      text: _formatTime(widget.timestamp.endTime),
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TimestampCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timestamp != widget.timestamp) {
      _startController.text = _formatTime(widget.timestamp.startTime);
      _endController.text = _formatTime(widget.timestamp.endTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: _getCardColor(theme),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Ayah number
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Ayah ${widget.timestamp.ayahNumber}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Status indicators
                if (widget.isCurrentlyPlaying) ...[
                  Icon(
                    Icons.play_circle,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                
                if (widget.hasPendingChanges) ...[
                  Icon(
                    Icons.edit,
                    color: theme.colorScheme.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                ],
                
                const Spacer(),
                
                // Review status toggle
                CustomIconButton(
                  icon: widget.timestamp.isReviewed 
                      ? Icons.check_circle 
                      : Icons.radio_button_unchecked,
                  color: widget.timestamp.isReviewed 
                      ? Colors.green 
                      : theme.colorScheme.onSurfaceVariant,
                  onPressed: widget.onToggleReviewed,
                  tooltip: widget.timestamp.isReviewed ? 'Reviewed' : 'Mark as reviewed',
                ),
                
                // Edit toggle
                CustomIconButton(
                  icon: _isEditing ? Icons.check : Icons.edit,
                  isSelected: _isEditing,
                  onPressed: () {
                    if (_isEditing) {
                      _saveChanges();
                    } else {
                      setState(() {
                        _isEditing = true;
                      });
                    }
                  },
                  tooltip: _isEditing ? 'Save changes' : 'Edit timestamps',
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Arabic text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.timestamp.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  height: 1.8,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Timestamp controls
            Row(
              children: [
                // Start time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Time',
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: _isEditing
                                ? TextField(
                                    controller: _startController,
                                    decoration: const InputDecoration(
                                      hintText: 'mm:ss.ss',
                                      isDense: true,
                                    ),
                                    style: const TextStyle(fontFamily: 'monospace'),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9:.]')),
                                    ],
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: theme.colorScheme.outline),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _formatTime(widget.timestamp.startTime),
                                      style: const TextStyle(fontFamily: 'monospace'),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          CustomIconButton(
                            icon: Icons.play_arrow,
                            onPressed: widget.onSeekToStart,
                            tooltip: 'Seek to start',
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // End time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Time',
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: _isEditing
                                ? TextField(
                                    controller: _endController,
                                    decoration: const InputDecoration(
                                      hintText: 'mm:ss.ss',
                                      isDense: true,
                                    ),
                                    style: const TextStyle(fontFamily: 'monospace'),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9:.]')),
                                    ],
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: theme.colorScheme.outline),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _formatTime(widget.timestamp.endTime),
                                      style: const TextStyle(fontFamily: 'monospace'),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          CustomIconButton(
                            icon: Icons.play_arrow,
                            onPressed: widget.onSeekToEnd,
                            tooltip: 'Seek to end',
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Duration display
            if (!_isEditing) ...[
              const SizedBox(height: 8),
              Text(
                'Duration: ${_formatTime(widget.timestamp.endTime - widget.timestamp.startTime)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCardColor(ThemeData theme) {
    if (widget.isCurrentlyPlaying) {
      return theme.colorScheme.primaryContainer;
    }
    if (widget.hasPendingChanges) {
      return theme.colorScheme.secondaryContainer;
    }
    if (widget.timestamp.isReviewed) {
      return theme.colorScheme.surfaceVariant;
    }
    return theme.colorScheme.surface;
  }

  String _formatTime(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final minutes = duration.inMinutes;
    final remainingSeconds = (duration.inMilliseconds / 1000) % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toStringAsFixed(2).padLeft(5, '0')}';
  }

  double _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) throw const FormatException();
      
      final minutes = int.parse(parts[0]);
      final seconds = double.parse(parts[1]);
      
      return minutes * 60 + seconds;
    } catch (e) {
      throw const FormatException('Invalid time format');
    }
  }

  void _saveChanges() {
    try {
      final newStartTime = _parseTime(_startController.text);
      final newEndTime = _parseTime(_endController.text);
      
      if (newStartTime >= newEndTime) {
        _showError('Start time must be less than end time');
        return;
      }
      
      if (newStartTime < 0) {
        _showError('Start time cannot be negative');
        return;
      }
      
      final updatedTimestamp = widget.timestamp.copyWith(
        startTime: newStartTime,
        endTime: newEndTime,
      );
      
      widget.onTimestampChanged(updatedTimestamp);
      
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      _showError('Invalid time format. Use mm:ss.ss');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
