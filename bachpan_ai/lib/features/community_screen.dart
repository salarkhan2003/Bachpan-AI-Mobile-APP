import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = [
    'All Posts',
    'Feeding Tips',
    'Sleep Schedule',
    'First Aid',
  ];

  final List<Map<String, dynamic>> _stories = [
    {'type': 'add', 'label': 'Add Story'},
    {'image': 'assets/images/COMMUNITY POST PROFILE.jpg', 'label': "Priya's Tips"},
    {'image': 'assets/images/COMMUNITY POST 2 PROFILE.jpg', 'label': "Nani's Care"},
  ];

  final List<Map<String, dynamic>> _posts = [
    {
      'user': 'Dr. Meera Sharma',
      'role': 'Pediatrician · Child Specialist',
      'avatar': 'assets/images/COMMUNITY POST PROFILE.jpg',
      'time': '2h ago',
      'content': "Essential tips for new parents: Creating a sleep schedule that works for both baby and parents. Here's what worked for most of my patients...",
      'image': 'assets/images/BACHPAN AI IMAGE 5.jpg',
      'likes': '2.4k',
      'comments': '148',
      'saved': false,
    },
    {
      'user': 'Anjali Desai',
      'role': 'Mother of 2 · Parenting Blogger',
      'avatar': 'assets/images/COMMUNITY POST 2 PROFILE.jpg',
      'time': '5h ago',
      'content': "Found this amazing trick for picky eaters! Mix finely chopped vegetables in roti dough.",
      'image': 'assets/images/BACHPAN AI IMAGE 4.jpg',
      'likes': '1.1k',
      'comments': '67',
      'saved': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Community', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
                    const SizedBox(height: 12),
                    // Stories
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _stories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final s = _stories[i];
                          if (s['type'] == 'add') {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.amber[50],
                                  child: Icon(Icons.add, color: Colors.amber[800], size: 28),
                                ),
                                const SizedBox(height: 2),
                                Text(s['label'], style: GoogleFonts.poppins(fontSize: 11, color: Colors.black87)),
                              ],
                            );
                          }
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: NetworkImage(s['image']),
                                onBackgroundImageError: (_, __) {},
                                child: s['image'] == null ? Icon(Icons.person, color: Colors.grey[400]) : null,
                              ),
                              const SizedBox(height: 2),
                              Text(s['label'], style: GoogleFonts.poppins(fontSize: 11, color: Colors.black87)),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tabs
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
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
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final p = _posts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: NetworkImage(p['avatar']),
                                onBackgroundImageError: (_, __) {},
                                child: p['avatar'] == null ? Icon(Icons.person, color: Colors.grey[400]) : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p['user'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                                    Text(p['role'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
                                  ],
                                ),
                              ),
                              Text(p['time'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                          if (p['image'] != null) ...[
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: Image.asset(
                                      p['image'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  p['image'],
                                  height: 100,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 100,
                                    width: 120,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Text(p['content'], style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.favorite, color: Colors.pink[300], size: 20),
                              const SizedBox(width: 4),
                              Text(p['likes'], style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800])),
                              const SizedBox(width: 16),
                              Icon(Icons.chat_bubble_outline, color: Colors.amber[800], size: 20),
                              const SizedBox(width: 4),
                              Text(p['comments'], style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800])),
                              const SizedBox(width: 16),
                              Icon(p['saved'] ? Icons.bookmark : Icons.bookmark_border, color: Colors.amber[800], size: 20),
                              const SizedBox(width: 4),
                              Text('Save', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _posts.length,
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
} 