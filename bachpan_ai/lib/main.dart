import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'l10n/l10n.dart';
import 'features/auth/login_signup_screen.dart';
import 'l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/profile/baby_profile_model.dart';
import 'features/profile/parent_profile_model.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/onboarding_screen.dart';
import 'features/care_screen.dart';
import 'features/milestones_screen.dart';
import 'features/community_screen.dart';
import 'features/profile/profile_screen_main.dart';
import 'core/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BabyProfileAdapter());
  Hive.registerAdapter(ParentProfileAdapter());
  runApp(const ProviderScope(child: BachpanAIApp()));
}

class BachpanAIApp extends ConsumerWidget {
  const BachpanAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(selectedLocaleProvider);
    final loggedIn = ref.watch(loggedInProvider);
    final showOnboarding = ref.watch(onboardingProvider);
    return MaterialApp(
      title: 'Bubella AI',
      theme: AppTheme.modernTheme,
      darkTheme: AppTheme.modernDarkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: showOnboarding
          ? OnboardingScreen()
          : loggedIn
              ? const MainNavigationShell()
              : LoginSignupScreen(onLogin: () => ref.read(loggedInProvider.notifier).state = true),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    DashboardScreen(),
    CareScreen(),
    MilestonesScreen(),
    CommunityScreen(),
    ProfileScreenMain(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Care'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: 'Milestones'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
