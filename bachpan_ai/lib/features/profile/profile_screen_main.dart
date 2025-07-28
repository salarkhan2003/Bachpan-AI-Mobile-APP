import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreenMain extends StatelessWidget {
  const ProfileScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    final user = {
      'name': 'Priya Sharma',
      'role': 'Mother of 2',
      'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
      'children': 2,
      'posts': 15,
      'careScore': 89,
      'email': 'priya.sharma@email.com',
      'phone': '+91 98765 43210',
      'location': 'Mumbai, India',
      'childrenProfiles': [
        {'name': 'Aarav Sharma', 'age': '8 months old', 'icon': Icons.child_care, 'color': Color(0xFFFFE0B2)},
        {'name': 'Anaya Sharma', 'age': '2.5 years old', 'icon': Icons.emoji_emotions, 'color': Color(0xFFFFF9C4)},
      ],
    };
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Avatar, Name, Role
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage('assets/images/MOTHER PROFILE PIC.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(user['name'] as String, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
                ),
                Center(
                  child: Text(user['role'] as String, style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700])),
                ),
                const SizedBox(height: 18),
                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ProfileStat(label: 'Children', value: user['children'].toString()),
                    _ProfileStat(label: 'Posts', value: user['posts'].toString()),
                    _ProfileStat(label: 'Care Score', value: '${user['careScore']}%'),
                  ],
                ),
                const SizedBox(height: 18),
                // Personal Info
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Personal Information', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                          Icon(Icons.edit, color: Colors.amber[800], size: 20),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _ProfileInfoRow(label: 'Email', value: user['email'] as String),
                      _ProfileInfoRow(label: 'Phone', value: user['phone'] as String),
                      _ProfileInfoRow(label: 'Location', value: user['location'] as String),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Children Profiles
                Text('Children Profiles', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 10),
                Column(
                  children: List.generate((user['childrenProfiles'] as List).length, (i) {
                    final c = (user['childrenProfiles'] as List)[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: c['color'] as Color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(c['icon'] as IconData, color: Colors.amber[800]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                                Text(c['age'], style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[800])),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber),
                        ],
                      ),
                    );
                  }),
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

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.amber[800])),
        Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[800])),
      ],
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileInfoRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey[700]))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87))),
        ],
      ),
    );
  }
} 