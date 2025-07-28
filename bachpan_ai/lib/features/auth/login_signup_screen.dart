import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bachpan_ai/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers.dart';
import 'package:bachpan_ai/l10n/l10n.dart';

final isLoginProvider = StateProvider<bool>((ref) => true);
final selectedLocaleProvider = StateProvider<Locale>((ref) => const Locale('en'));

class LoginSignupScreen extends ConsumerWidget {
  final VoidCallback? onLogin;
  const LoginSignupScreen({super.key, this.onLogin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(isLoginProvider);
    final locale = ref.watch(selectedLocaleProvider);
    final l10n = AppLocalizations.of(context)!;

    final supportedLocales = L10n.all;
    final languageNames = {
      'en': 'English',
      'hi': 'हिन्दी',
      'bn': 'বাংলা',
      'te': 'తెలుగు',
      'mr': 'मराठी',
      'ta': 'தமிழ்',
      'ur': 'اردو',
      'gu': 'ગુજરાતી',
      'kn': 'ಕನ್ನಡ',
      'ml': 'മലയാളം',
      'or': 'ଓଡ଼ିଆ',
      'pa': 'ਪੰਜਾਬੀ',
      'as': 'অসমীয়া',
    };

    void skipLogin() {
      ref.read(onboardingProvider.notifier).state = false;
      ref.read(loggedInProvider.notifier).state = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.appTitle, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black87)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<Locale>(
              value: locale,
              underline: const SizedBox(),
              icon: const Icon(Icons.language),
              items: supportedLocales.map((loc) {
                return DropdownMenuItem(
                  value: loc,
                  child: Text(languageNames[loc.languageCode] ?? loc.languageCode),
                );
              }).toList(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  ref.read(selectedLocaleProvider.notifier).state = newLocale;
                }
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isLogin ? 'Welcome to BachpanAI!' : 'Create your account',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ToggleButtons(
                isSelected: [isLogin, !isLogin],
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: const Color(0xFFFFC107),
                color: Colors.black87,
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                onPressed: (index) {
                  ref.read(isLoginProvider.notifier).state = index == 0;
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Login'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Sign Up'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _AuthForm(isLogin: isLogin, onLogin: onLogin),
              const SizedBox(height: 16),
              TextButton(
                onPressed: skipLogin,
                child: Text('Skip Login, Explore App', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.teal[700])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final bool isLogin;
  final VoidCallback? onLogin;
  const _AuthForm({required this.isLogin, this.onLogin});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        if (!isLogin)
          TextField(
            decoration: InputDecoration(
              labelText: l10n.name,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        if (!isLogin) const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: l10n.email,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.password,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            if (onLogin != null) onLogin!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(isLogin ? l10n.login : l10n.signup),
        ),
      ],
    );
  }
} 