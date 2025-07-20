import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4C8C4A);
  static const Color primaryDark = Color(0xFF003D00);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF8BC34A);
  static const Color secondaryLight = Color(0xFFBEF67A);
  static const Color secondaryDark = Color(0xFF5A9216);
  
  // Background Colors
  static const Color background = Color(0xFFF1F8E9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  
  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF1A1C18);
  static const Color onSurface = Color(0xFF1A1C18);
  static const Color onSurfaceVariant = Color(0xFF44483D);
  
  // Status Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color warning = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);
  
  // Audio Player Colors
  static const Color waveformActive = Color(0xFF2E7D32);
  static const Color waveformInactive = Color(0xFFE8F5E8);
  static const Color timestampMarker = Color(0xFFFF5722);
  static const Color currentAyahHighlight = Color(0xFFC8E6C9);
  static const Color reviewedAyah = Color(0xFFE1F5FE);
  static const Color unviewedAyah = Color(0xFFFFF3E0);
  
  // Semantic Colors
  static const Color currentlyPlaying = Color(0xFF81C784);
  static const Color pendingChanges = Color(0xFFFFCC02);
  static const Color conflictError = Color(0xFFE57373);
}

// Color Extensions
extension AppColorsExtension on ColorScheme {
  Color get waveformActive => AppColors.waveformActive;
  Color get waveformInactive => AppColors.waveformInactive;
  Color get timestampMarker => AppColors.timestampMarker;
  Color get currentAyahHighlight => AppColors.currentAyahHighlight;
  Color get reviewedAyah => AppColors.reviewedAyah;
  Color get unviewedAyah => AppColors.unviewedAyah;
  Color get currentlyPlaying => AppColors.currentlyPlaying;
  Color get pendingChanges => AppColors.pendingChanges;
  Color get conflictError => AppColors.conflictError;
}
