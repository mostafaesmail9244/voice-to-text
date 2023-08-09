import 'package:flutter/material.dart';
import 'package:voice_to_text/speech_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice To Text App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SpeechScreen(),
    );
  }
}
