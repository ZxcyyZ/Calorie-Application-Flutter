import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isTextToSpeechEnabled = false;

  bool get isTextToSpeechEnabled => _isTextToSpeechEnabled;

  void toggleTextToSpeech() {
    _isTextToSpeechEnabled = !_isTextToSpeechEnabled;
    notifyListeners();
  }
}