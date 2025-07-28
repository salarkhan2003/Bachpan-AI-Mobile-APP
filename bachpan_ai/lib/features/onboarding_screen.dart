import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'image': 'assets/images/FIRST ONBOARD SCREEN IMAGE.jpg',
      'title': 'Welcome to BachpanAI',
      'desc': "Your trusted companion for your baby's first 1,000 days journey",
      'isCircle': false,
    },
    {
      'image': 'assets/images/BACHPAN AI IMAGE 3.jpg',
      'title': 'Smart Features for Smart Parents',
      'desc': 'Powered by AI to make parenting decisions simpler and more confident',
      'isCircle': false,
    },
    {
      'image': 'assets/images/BABY IMAGES FOR BACHPAN AI APP.jpg',
      'title': 'Ready to Begin?',
      'desc': "Let's start your journey towards confident parenting with BachpanAI",
      'isCircle': true,
    },
  ];

  void _finishOnboarding({bool guest = false}) {
    ref.read(onboardingProvider.notifier).state = false;
    if (guest) {
      ref.read(loggedInProvider.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6E8),
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final page = _pages[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => _finishOnboarding(),
                          child: Text('Skip', style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      page['isCircle']
                          ? CircleAvatar(
                              radius: 100,
                              backgroundImage: AssetImage(page['image']),
                              child: null,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: SizedBox(
                                height: i == 0 ? 400 : 220,
                                width: double.infinity,
                                child: Image.asset(
                                  page['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.grey[200],
                                    child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 32),
                      Text(
                        page['title'],
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        page['desc'],
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      if (i == _pages.length - 1)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFC107),
                                  foregroundColor: Colors.black87,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () => _finishOnboarding(),
                                child: Text('Get Started', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => _finishOnboarding(),
                              child: Text('Already have an account? Sign in', style: GoogleFonts.poppins(fontSize: 15, color: Colors.amber[800], fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => _finishOnboarding(guest: true),
                              child: Text('Skip Login, Explore App', style: GoogleFonts.poppins(fontSize: 15, color: Colors.teal[700], fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      if (i < _pages.length - 1)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFC107),
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                            },
                            child: Text('Next', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                        ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
            // Dots indicator
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _page == i ? const Color(0xFFFFC107) : Colors.amber[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 