# Surah Annotator - Getting Started

## Quick Setup

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Code (JSON Serialization)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

## How to Use

### 1. Load Files
- **Audio File**: Click "Select Audio File" and choose your Surah recording (MP3, WAV, M4A, etc.)
- **Timestamp File**: Click "Select Timestamp File" and choose your JSON timestamp file

### 2. Sample Timestamp File Format
Use the included `sample_timestamps.json` as a template:

```json
[
  {
    "ayah_number": 1,
    "start_time": 0.0,
    "end_time": 5.5,
    "text": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
  }
]
```

### 3. Main Features

#### Audio Playback
- **Play/Pause**: Control audio playback
- **Seek**: Click on waveform or use slider to jump to any position
- **Skip**: Use forward/backward buttons (10-second jumps)

#### Timestamp Annotation
- **View Ayahs**: Scroll through timestamp cards
- **Edit Timestamps**: Click edit icon to modify start/end times
- **Seek to Position**: Click play buttons next to timestamps
- **Mark as Reviewed**: Click circle icon to mark Ayah as reviewed
- **Batch Changes**: Make multiple edits, then click "Apply Changes"

#### Visual Indicators
- **Currently Playing**: Blue highlight shows currently playing Ayah
- **Pending Changes**: Orange indicator shows unsaved edits
- **Reviewed**: Green checkmark shows reviewed Ayahs

## Supported File Formats

### Audio Files
- MP3, WAV, M4A, AAC, OGG, FLAC

### Timestamp Files
- JSON format only (see sample file)

## Architecture

The app follows a **Feature-First Architecture** with:
- **Riverpod** for state management
- **Material Design 3** for UI
- **Repository Pattern** for data handling
- **Real-time Audio Processing** with just_audio

## Development Notes

### Key Files Created
- `lib/main.dart` - App entry point
- `lib/features/home/home_screen.dart` - Main interface
- `lib/core/models/` - Data models with JSON serialization
- `lib/core/providers/` - Riverpod state management
- `lib/core/repositories/` - Data access layer
- `lib/features/` - Feature-specific widgets and services
- `lib/shared/` - Reusable components and theme

### Next Steps for Enhancement
1. Add audio_waveforms package for better waveform display
2. Implement drag-and-drop timestamp markers on waveform
3. Add word-level timestamp support
4. Implement auto-save functionality
5. Add export/import session features

## Troubleshooting

### Build Issues
If you encounter build errors:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `dart run build_runner build --delete-conflicting-outputs`

### Audio Issues
- Ensure audio file is in supported format
- Check file permissions
- Try smaller audio files first

### Timestamp Issues
- Validate JSON format
- Check that ayah_number is sequential
- Ensure start_time < end_time for each entry
