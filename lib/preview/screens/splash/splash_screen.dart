import 'package:fish/data/nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _markSplashAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_splash', true);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.alfaSlabOne(
      fontSize: 47.9,
      fontWeight: FontWeight.w400,
      height: 65.57 / 47.9,
      letterSpacing: 0,
      color: Colors.white,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF4052EE),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50.4),
              SizedBox(
                width: 345,
                height: 66,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFFFF8A00),
                        Color(0xFFFF5C00),
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'FISHING\nTRACKER',
                    textAlign: TextAlign.center,
                    style: titleStyle,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/avatar_splash.png',
                height: 200,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'The fishing tracker app offers a number of useful features that will make the process of fishing as comfortable and efficient as possible.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'You will be able to keep a detailed log of catches, recording the time, place, weather and type of bait used',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    _markSplashAsShown();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => const MainNavigationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add Fish',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: const Color(0xFF4052EE),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
