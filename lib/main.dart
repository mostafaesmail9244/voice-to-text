import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  Map<String, HighlightedWord> highlightMap = {
    // 'flutter': HighlightedWord(
    //     onTap: () => debugPrint('flutter '),
    //     textStyle: const TextStyle(color: Colors.red)),
    // 'Mustafa': HighlightedWord(
    //     onTap: () => debugPrint('Mustfa'),
    //     textStyle: const TextStyle(color: Colors.blue)),
  };
  double? confidence;
  stt.SpeechToText? _speech;
  String _text = 'press to recorde';
  bool _isListening = false;
  @override
  void initState() {
    _speech = stt.SpeechToText();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice To Text'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 70,
        duration: const Duration(milliseconds: 2000),
        animate: _isListening,
        glowColor: Colors.red,
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: listen,
          child:
              _isListening ? const Icon(Icons.mic) : const Icon(Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 100),
          child: TextHighlight(text: _text, words: highlightMap),
        ),
      ),
    );
  }

  void listen() async {
    bool? available;
    if (!_isListening) {
      available = await _speech!.initialize(
          onStatus: (val) => debugPrint('state is $val'),
          onError: (val) => debugPrint('error is $val'));
    }
    if (available == true) {
      setState(() => _isListening = true);
      _speech!.listen(
          onResult: (val) => setState(() {
                _text = val.recognizedWords;
                if (val.hasConfidenceRating && val.confidence > 0) {
                  confidence = val.confidence;
                }
              }));
    } else {
      setState(() => _isListening = false);
      _speech!.stop();
    }
  }
}
