import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'support_form_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('email', _emailController.text);
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildSettingButton(String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CupertinoButton(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () => _launchURL(url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4052EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildProfileField('Name', _nameController),
              const SizedBox(height: 16),
              _buildProfileField('Username', _usernameController),
              const SizedBox(height: 16),
              _buildProfileField('E-mail', _emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 32),
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white.withOpacity(0.1),
                  child: const Text(
                    'Privacy policy',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _launchURL(
                      'https://docs.google.com/document/d/1M_k1JAXbLHDluONZCoHO0Mwroj3vB4TUKd4FoTpRxGQ/edit?usp=sharing'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white.withOpacity(0.1),
                  child: const Text(
                    'Terms & Conditions',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _launchURL(
                      'https://docs.google.com/document/d/1KnDrUUcoV_u1_fb1O3MJKNwdtvM7sohJxqJ-trmhUAY/edit?usp=sharing'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white.withOpacity(0.1),
                  child: const Text(
                    'Write Support',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const SupportReport(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          keyboardType: keyboardType,
          onChanged: (_) => _saveUserData(),
        ),
      ],
    );
  }
}
