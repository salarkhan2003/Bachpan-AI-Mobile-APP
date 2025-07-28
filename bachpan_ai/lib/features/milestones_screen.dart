import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({super.key});

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Physical', 'Social', 'Language', 'Cognitive'];

  final List<Map<String, dynamic>> _milestones = [
    {
      'title': 'Crawling',
      'desc': 'Your baby started crawling at 7 months',
      'achieved': true,
      'category': 'Physical',
    },
    {
      'title': 'First Words',
      'desc': 'Said "mama" at 8 months',
      'achieved': false,
      'category': 'Language',
    },
    {
      'title': 'Social Smile',
      'desc': 'Smiled at familiar faces at 2 months',
      'achieved': true,
      'category': 'Social',
    },
    {
      'title': 'Standing',
      'desc': 'Pulled up to stand at 9 months',
      'achieved': false,
      'category': 'Physical',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedTab == 0
        ? _milestones
        : _milestones.where((m) => m['category'] == _tabs[_selectedTab]).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Milestones', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
                const SizedBox(height: 12),
                // Milestone Alert
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.amber[800]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('New Milestone Alert', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.amber[800])),
                            Text('Time to check if your baby is starting to pull up to stand! This usually happens around 9-10 months.', style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Overall Progress
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Overall Progress', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                          Text('Age: 9 months', style: GoogleFonts.poppins(fontSize: 14, color: Colors.amber[800], fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          Container(
                            height: 8,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Your baby is progressing well! 15 of 20 milestones achieved.', style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Next Milestone
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/BACHPAN AI IMAGE 2.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Next Milestone: First Steps', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                              Text('Expected around 12 months', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Tabs
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedTab == i ? Colors.amber : Colors.amber[50],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(_tabs[i], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: _selectedTab == i ? Colors.white : Colors.amber[800])),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Milestone List
                Column(
                  children: filtered.map((m) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          m['achieved'] ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: m['achieved'] ? Colors.green : Colors.grey[400],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                              Text(m['desc'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[800])),
                            ],
                          ),
                        ),
                        if (m['achieved'])
                          Text('Achieved', style: GoogleFonts.poppins(fontSize: 13, color: Colors.green, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )).toList(),
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