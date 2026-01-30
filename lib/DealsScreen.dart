import 'package:flutter/material.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.discount,
                size: 80,
                color: Color(0xFF00FF94),
              ),
              const SizedBox(height: 16),
              Text(
                'Chegirmalar',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}