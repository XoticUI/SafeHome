// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/root.dart';

void main() {
  // make status bar icons light to match the design
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
  );
  runApp(const MyApp());
}
  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          tooltipTheme: const TooltipThemeData(
            waitDuration: Duration(seconds: 4),
          ),
        ),
        home: const RootScreen(),
      );
    }
  }

// OnboardingPage is now located in `lib/Pages/landing.dart`.
// ...existing code...