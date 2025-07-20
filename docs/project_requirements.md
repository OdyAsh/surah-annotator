# Surah Annotator - Project Requirements

## Project Overview

The Surah Annotator is a Flutter application designed to facilitate the precise annotation and adjustment of Quranic audio timestamps. The application combines audio playback with visual feedback and intuitive editing tools to help users accurately align Quranic text with corresponding audio segments.

## Core Inputs

### Required Inputs
- **Audio File**: A complete Surah recording in standard audio formats (MP3, WAV, etc.)
- **Ayah Timestamps**: A file containing start/end timestamps for each Ayah in the audio

### Optional Inputs
- **Word Timestamps**: A file containing precise word-level timestamps for enhanced text highlighting

## Functional Requirements

### 1. Audio Player Component

#### 1.1 Waveform Audio Player
- **FR-1.1.1**: Display audio as an interactive waveform visualization
- **FR-1.1.2**: Enable audio playback control through the waveform interface
- **FR-1.1.3**: Show real-time playback progress on the waveform
- **FR-1.1.4**: Allow seeking to any position by clicking/tapping on the waveform

#### 1.2 Real-time Display System
- **FR-1.2.1**: Display current timestamp during audio playback
- **FR-1.2.2**: Show the currently playing Ayah text synchronized with audio
- **FR-1.2.3**: Highlight individual words when word timestamps are provided
- **FR-1.2.4**: Dim/fade non-current words based on playback position

### 2. Timestamp Annotation System

#### 2.1 Option 1: Bulk Timestamp Replacement
- **FR-2.1.1**: Accept timestamp file upload with correct Ayah timestamps
- **FR-2.1.2**: Replace existing timestamps with uploaded data
- **FR-2.1.3**: Preserve audio-text synchronization after replacement
- **FR-2.1.4**: Future enhancement: Extract timestamps from YouTube URLs

#### 2.2 Option 2: Interactive Timestamp Adjustment

##### 2.2.1 Ayah Card Display System
- **FR-2.2.1**: Display scrollable list of Ayah cards below the audio player
- **FR-2.2.2**: Each card must show:
  - Ayah number
  - Start timestamp (editable)
  - End timestamp (editable)
  - Seek icons for jumping to start/end positions
  - Review status indicator icon
- **FR-2.2.3**: Highlight currently playing Ayah card with background color change
- **FR-2.2.4**: Enable direct timestamp editing within cards

##### 2.2.2 Synchronization Controls
- **FR-2.2.5**: Provide "Sync to Ayah" button to auto-scroll to current Ayah
- **FR-2.2.6**: Toggle synchronization with "Unsync" functionality
- **FR-2.2.7**: Maintain sync until manual user scroll or button toggle

##### 2.2.3 Visual Timestamp Adjustment
- **FR-2.2.8**: Display draggable timestamp markers on waveform
- **FR-2.2.9**: Show start/end markers for currently playing Ayah
- **FR-2.2.10**: Enable drag-to-adjust timestamp functionality
- **FR-2.2.11**: Trigger "Change Timestamp" button when markers are moved

##### 2.2.4 Timestamp Conflict Resolution
- **FR-2.2.12**: Detect timestamp overlaps between adjacent Ayahs
- **FR-2.2.13**: Auto-adjust overlapping timestamps to prevent conflicts
- **FR-2.2.14**: Maintain chronological order of all timestamps

##### 2.2.5 Batch Processing System
- **FR-2.2.15**: Allow multiple Ayah timestamp modifications before applying
- **FR-2.2.16**: Cache all pending changes until "Change Timestamps" is pressed
- **FR-2.2.17**: Process changes in Ayah number order
- **FR-2.2.18**: Update review status for all modified Ayahs

#### 2.3 Option 3: Advanced Adjustment Features
- **FR-2.3.1**: Requirements to be defined after initial version completion
- **FR-2.3.2**: Will build upon Option 2 functionality with enhancements

## Non-Functional Requirements

### Performance Requirements
- **NFR-1**: Audio playback must be responsive with minimal latency
- **NFR-2**: Waveform rendering should support files up to 2 hours in length
- **NFR-3**: Real-time text highlighting must maintain 60fps performance

### Usability Requirements
- **NFR-4**: Intuitive touch/click interactions for all controls
- **NFR-5**: Clear visual feedback for all user actions
- **NFR-6**: Accessible design following Material Design guidelines

### Data Integrity Requirements
- **NFR-7**: Preserve original timestamp data until explicitly saved
- **NFR-8**: Validate all timestamp inputs for logical consistency
- **NFR-9**: Prevent data loss during editing operations

## Technical Constraints

- **TC-1**: Built using Flutter framework for cross-platform compatibility
- **TC-2**: Must support both Android and iOS platforms
- **TC-3**: Audio processing must work with standard audio formats
- **TC-4**: Timestamp files must use standardized format (JSON/CSV)

## Success Criteria

1. Users can load and play Quranic audio with synchronized text display
2. Timestamp adjustments are intuitive and conflict-free
3. All changes can be saved and exported for future use
4. Application maintains performance with large audio files
5. User workflow is efficient for bulk timestamp corrections