import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imtihon_7/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set status bar to transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "O'yin Kashfiyoti",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'Inter',
        brightness: Brightness.dark,
      ),
      home: const SplashScreen(),
    );
  }
}