import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:imtihon_7/MainScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 5 sekunddan keyin boshqa ekranga o'tish
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ), // HomePage ni o'zgartiring
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TapTap',
              style: GoogleFonts.lemon(
                fontSize: 72,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -2,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'to Share Your Games',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
