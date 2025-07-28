import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:fl_chart/fl_chart.dart';

class CryAnalyzerScreen extends StatefulWidget {
  const CryAnalyzerScreen({super.key});

  @override
  State<CryAnalyzerScreen> createState() => _CryAnalyzerScreenState();
}

class _CryAnalyzerScreenState extends State<CryAnalyzerScreen> {
  final String backendUrl = 'http://127.0.0.1:8000';
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordedFilePath;
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  List<Map<String, dynamic>> _history = [];
  final TextEditingController _manualController = TextEditingController();
  final RecorderController _waveformController = RecorderController();

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _fetchHistory();
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _manualController.dispose();
    super.dispose();
  }

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

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    _waveformController.stop();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _recordedFilePath = result.files.single.path;
      });
      _analyzeCry(File(_recordedFilePath!));
    }
  }

  Future<void> _analyzeCry(File file) async {
    setState(() { _isLoading = true; _result = null; });
    final request = http.MultipartRequest('POST', Uri.parse('$backendUrl/analyze_cry'));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      setState(() { _result = data; });
      _fetchHistory();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Analysis failed.')));
    }
    setState(() { _isLoading = false; });
  }

  Future<void> _fetchHistory() async {
    final response = await http.get(Uri.parse('$backendUrl/cry_history'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _history = data.map((e) => e as Map<String, dynamic>).toList();
      });
    }
  }

  Map<String, int> _cryTypeCounts() {
    final Map<String, int> counts = {};
    for (final h in _history) {
      counts[h['prediction']] = (counts[h['prediction']] ?? 0) + 1;
    }
    return counts;
  }

  Widget _buildPieChart() {
    final counts = _cryTypeCounts();
    if (counts.isEmpty) return const SizedBox();
    final total = counts.values.fold(0, (a, b) => a + b);
    final colors = [Colors.amber, Colors.teal, Colors.pink, Colors.blue, Colors.green, Colors.red];
    int i = 0;
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sections: counts.entries.map((e) {
            final color = colors[i++ % colors.length];
            return PieChartSectionData(
              color: color,
              value: e.value.toDouble(),
              title: '${e.key}\n${((e.value/total)*100).toStringAsFixed(0)}%',
              radius: 50,
              titleStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_result == null) return const SizedBox();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Possible Cause:', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${_result!['prediction']} (${_result!['confidence']}%)', style: GoogleFonts.poppins(fontSize: 22, color: Colors.amber[800], fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(_result!['suggestion'], style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('This was correct'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[400], foregroundColor: Colors.white),
              onPressed: () => _sendFeedback(true),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('This was wrong'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300], foregroundColor: Colors.white),
              onPressed: () => _sendFeedback(false),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendFeedback(bool correct) async {
    if (_result == null) return;
    await http.post(Uri.parse('$backendUrl/feedback'), body: {
      'filename': _result!['filename'],
      'correct': correct.toString(),
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your feedback!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👶 Cry Analyzer'),
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  label: Text(_isRecording ? 'Stop' : 'Record Cry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: _pickFile,
                ),
              ],
            ),
            if (_isRecording)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: AudioWaveforms(
                  enableGesture: false,
                  size: Size(MediaQuery.of(context).size.width * 0.8, 60),
                  recorderController: _waveformController,
                  waveStyle: const WaveStyle(
                    waveColor: Colors.amber,
                    extendWaveform: true,
                    showMiddleLine: false,
                  ),
                ),
              ),
            if (!_isRecording && _recordedFilePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.analytics),
                  label: const Text('Analyze Recording'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () => _analyzeCry(File(_recordedFilePath!)),
                ),
              ),
            const SizedBox(height: 12),
            Text('Or type and explain how your baby is crying:', style: GoogleFonts.poppins(fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
              controller: _manualController,
              decoration: InputDecoration(
                hintText: 'Describe the cry (e.g., high-pitched, continuous, etc.)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // For demo, just show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Manual input sent!')));
                  },
                ),
              ),
              minLines: 1,
              maxLines: 3,
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: Colors.amber),
                    const SizedBox(height: 12),
                    Text('Analyzing your baby\'s cry...', style: GoogleFonts.poppins(fontSize: 16)),
                  ],
                ),
              ),
            _buildResultCard(),
            const SizedBox(height: 16),
            if (_history.isNotEmpty) ...[
              Text('Cry History', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildPieChart(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _history.length,
                itemBuilder: (context, i) {
                  final h = _history[_history.length - 1 - i];
                  return ListTile(
                    leading: const Icon(Icons.history, color: Colors.amber),
                    title: Text(h['prediction'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    subtitle: Text('Confidence: ${h['confidence']}%'),
                    trailing: Text(h['suggestion'], style: GoogleFonts.poppins(fontSize: 13)),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
} 