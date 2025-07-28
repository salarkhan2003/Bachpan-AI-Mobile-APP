import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CareScreen extends StatelessWidget {
  const CareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final essentials = [
      {'icon': Icons.restaurant, 'label': 'Feeding Guide'},
      {'icon': Icons.bedtime, 'label': 'Sleep Schedule'},
      {'icon': Icons.bathtub, 'label': 'Bath Time'},
      {'icon': Icons.health_and_safety, 'label': 'Health Check'},
    ];
    final tips = [
      {
        'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        'title': 'Better Sleep Habits',
        'desc': 'Create a consistent bedtime routine to help your baby sleep better',
      },
      {
        'image': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        'title': 'Essential Products Guide',
        "desc": "Must-have items for your baby's daily care routine",
      },
    ];
    final concerns = [
      {'icon': Icons.thermostat, 'label': 'Fever Management'},
      {'icon': Icons.healing, 'label': 'Rash Care'},
      {'icon': Icons.sick, 'label': 'Colic Relief'},
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/BABY IMAGES FOR BACHPAN AI APP.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Baby Care Guide', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87)),
                Text('Expert advice for your little one', style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700])),
                const SizedBox(height: 16),
                // Emergency & First Aid
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.phone_in_talk, color: Colors.pink[400]),
                            const SizedBox(height: 8),
                            Text('Emergency Help', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.medical_services, color: Colors.amber[800]),
                            const SizedBox(height: 8),
                            Text('First Aid Guide', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Daily Care Essentials
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Daily Care Essentials', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: essentials.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.8,
                  ),
                  itemBuilder: (context, i) => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(essentials[i]['icon'] as IconData, color: Colors.amber[800]),
                        const SizedBox(width: 8),
                        Text(essentials[i]['label'] as String, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Today's Care Tips
                Text("Today's Care Tips", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 10),
                Column(
                  children: tips.map((tip) {
                    final t = tip as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              t['image'],
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 56,
                                height: 56,
                                color: Colors.grey[200],
                                child: Icon(Icons.broken_image, color: Colors.grey[400], size: 28),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                                Text(t['desc'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[800])),
                                Text('Read more', style: GoogleFonts.poppins(fontSize: 12, color: Colors.amber[800], fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Common Concerns
                Text('Common Concerns', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 10),
                Column(
                  children: concerns.map((c) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(c['icon'] as IconData, color: Colors.amber[800]),
                        const SizedBox(width: 10),
                        Expanded(child: Text(c['label'] as String, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87))),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.amber),
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