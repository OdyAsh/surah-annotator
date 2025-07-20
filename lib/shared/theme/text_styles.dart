import 'package:flutter/material.dart';

class AppTextStyles {
  // Arabic Text Styles (for Quran text)
  static const TextStyle arabicTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.8,
    fontFamily: 'Amiri', // Consider adding Arabic font in pubspec
  );

  static const TextStyle arabicBody = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.6,
    fontFamily: 'Amiri',
  );

  static const TextStyle arabicCaption = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFamily: 'Amiri',
  );

  // English Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // Timestamp Styles
  static const TextStyle timestampLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'monospace',
    height: 1.2,
  );

  static const TextStyle timestampValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'monospace',
    height: 1.2,
  );

  static const TextStyle timestampInput = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'monospace',
    height: 1.2,
  );

  // Audio Controls Styles
  static const TextStyle audioPosition = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: 'monospace',
    height: 1.2,
  );

  static const TextStyle audioDuration = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'monospace',
    height: 1.2,
  );
}

// Text Theme Extension
extension AppTextTheme on TextTheme {
  TextStyle get arabicTitle => AppTextStyles.arabicTitle;
  TextStyle get arabicBody => AppTextStyles.arabicBody;
  TextStyle get arabicCaption => AppTextStyles.arabicCaption;
  TextStyle get timestampLabel => AppTextStyles.timestampLabel;
  TextStyle get timestampValue => AppTextStyles.timestampValue;
  TextStyle get timestampInput => AppTextStyles.timestampInput;
  TextStyle get audioPosition => AppTextStyles.audioPosition;
  TextStyle get audioDuration => AppTextStyles.audioDuration;
}
