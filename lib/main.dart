import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/theme/app_theme.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SurahAnnotatorApp(),
    ),
  );
}

class SurahAnnotatorApp extends StatelessWidget {
  const SurahAnnotatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surah Annotator',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}