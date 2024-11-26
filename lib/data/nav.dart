import 'package:fish/preview/screens/add_fish/add_fish_screen.dart';
import 'package:fish/preview/screens/home/home_screen.dart';
import 'package:fish/preview/screens/profile/profile_screen.dart';
import 'package:fish/preview/screens/puzzle/puzzle_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AddFishScreen(),
    const ProfileScreen(),
    const PuzzleScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: const Color(0xFF4052EE),
        activeColor: Colors.white,
        inactiveColor: Colors.white.withOpacity(0.5),
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.plus_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.viewfinder),
            label: 'Puzzle',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
