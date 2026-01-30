import 'package:flutter/material.dart';
import 'package:imtihon_7/DealsScreen.dart';
import 'package:imtihon_7/PlayScreen.dart';
import 'package:imtihon_7/ProfileScreen.dart';
import 'package:imtihon_7/TavernScreen.dart';
import 'package:imtihon_7/homescreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PlayScreen(),
    const DealsScreen(),
    const TavernScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.games_outlined, 'Games', 0),
              _buildNavItem(Icons.play_circle_outline, 'Play', 1),
              _buildNavItem(Icons.discount, '', 2, isCenter: true),
              _buildNavItem(Icons.local_bar_outlined, 'Tavern', 3),
              _buildNavItem(Icons.person_outline, 'Me', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, {bool isCenter = false}) {
    final isSelected = _selectedIndex == index;
    
    if (isCenter) {
      return GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00FF94), Color(0xFF00D67D)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FF94).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.discount,
            color: Colors.black,
            size: 28,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00D67D) : Colors.white.withOpacity(0.5),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF00D67D) : Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}