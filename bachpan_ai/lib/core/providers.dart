import 'package:flutter_riverpod/flutter_riverpod.dart';

final loggedInProvider = StateProvider<bool>((ref) => false);
final onboardingProvider = StateProvider<bool>((ref) => true); 