import 'package:flutter/material.dart';

class CryAnalyzerScreen extends StatefulWidget {
  // ... (existing code)
}

class _CryAnalyzerScreenState extends State<CryAnalyzerScreen> {
  // ... (existing code)

  Future<void> _startRecording() async {
    final path = '/sdcard/Download/baby_cry_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder!.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );
    setState(() {
      _isRecording = true;
      _recordedFilePath = path;
    });
    Future.delayed(const Duration(seconds: 15), () {
      if (_isRecording) _stopRecording();
    });
  }

  // ... (rest of the existing code)
} 