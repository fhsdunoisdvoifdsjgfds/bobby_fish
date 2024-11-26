import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/nav.dart';
import 'preview/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showSplash = prefs.getBool('seen_splash');
  runApp(MyApp(showSplash: showSplash ?? false));
}

class MyApp extends StatelessWidget {
  final bool showSplash;

  const MyApp({super.key, required this.showSplash});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4052EE),
        scaffoldBackgroundColor: const Color(0xFF4052EE),
      ),
      home: !showSplash ? const SplashScreen() : const MainNavigationScreen(),
    );
  }
}
