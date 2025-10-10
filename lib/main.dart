// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Pages/landing.dart';

void main() {
  // make status bar icons light to match the design
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
  );
  runApp(const MyTestApp());
}

class MyTestApp extends StatelessWidget {
  const MyTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(),
    );
  }
}

// OnboardingPage is now located in `lib/Pages/landing.dart`.
// ...existing code...