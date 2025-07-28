import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cry_analyzer_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final babyName = 'Salar';
    final babyAge = '6 months';
    final babyGender = 'Male';
    final babyDOB = '2025-07-03';
    final aiInsights = [
      {
        'icon': Icons.nightlight_round,
        'title': 'Sleep Pattern',
        'desc': "Baby's sleep improved by 15% this week"
      },
      {
        'icon': Icons.show_chart,
        'title': 'Growth',
        'desc': 'Height and weight on track'
      },
    ];
    final quickActions = [
      {'icon': Icons.emoji_emotions, 'label': 'Cry Analysis'},
      {'icon': Icons.camera_alt, 'label': 'Skin Check'},
      {'icon': Icons.schedule, 'label': 'Schedule'},
      {'icon': Icons.medical_services, 'label': 'First Aid'},
    ];
    final schedule = [
      {
        'time': '9:00 AM',
        'title': 'Vaccination Due',
        'desc': 'DPT Booster Shot',
        'icon': Icons.vaccines,
        'color': const Color(0xFFFFF3E0),
      },
      {
        'time': '2:30 PM',
        'title': "Doctor's Visit",
        'desc': 'Regular Checkup',
        'icon': Icons.local_hospital,
        'color': const Color(0xFFE0F2F1),
      },
    ];
    final growthData = [7.1, 7.2, 7.3, 7.4, 7.5, 7.6];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting & Baby Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.amber[100],
                      child: Icon(Icons.child_care, size: 28, color: Colors.amber[800]),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning!', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                        Text('$babyName, $babyAge', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800])),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // AI Insights
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AI Insights', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                    Text('Updated 2m ago', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: aiInsights.map((insight) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(insight['icon'] as IconData, color: Colors.amber[800]),
                          const SizedBox(height: 6),
                          Text(insight['title'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                          Text(insight['desc'] as String, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[800])),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 18),
                // Quick Actions
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: quickActions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        if (quickActions[i]['label'] == 'Cry Analysis') {
                          if (kIsWeb) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cry Analysis is only available on Android/iOS devices.')),
                            );
                            return;
                          }
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.amber)),
                          );
                          await Future.delayed(const Duration(milliseconds: 400));
                          Navigator.pop(context); // Remove loading
                          Fluttertoast.showToast(msg: 'Opening Cry Analyzer...', gravity: ToastGravity.BOTTOM);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CryAnalyzerScreen()),
                          );
                        }
                        // Add similar feedback for other actions if needed
                      },
                      child: Container(
                        width: 84,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(quickActions[i]['icon'] as IconData, size: 32, color: Colors.amber[800]),
                            const SizedBox(height: 8),
                            Text(quickActions[i]['label'] as String, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Today's Schedule
                Text("Today's Schedule", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 8),
                Column(
                  children: schedule.map((item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item['color'] as Color?,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(item['icon'] as IconData, color: Colors.amber[800]),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                            Text(item['desc'] as String, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[800])),
                          ],
                        ),
                        const Spacer(),
                        Text(item['time'] as String, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
                      ],
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 18),
                // Growth Tracking
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Growth Tracking', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                    Text('View Details', style: GoogleFonts.poppins(fontSize: 13, color: Colors.amber[800], fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: _GrowthChartPainter(growthData),
                    child: Container(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GrowthChartPainter extends CustomPainter {
  final List<double> data;
  _GrowthChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber[800]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path();
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        final x = i * size.width / (data.length - 1);
        final y = size.height - ((data[i] - data.first) / (data.last - data.first + 0.01)) * size.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 