// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const Color background = Color(0xFF7FB57C); // green tone

  Widget _pageIndicators() {
    Widget dot([bool active = false]) {
      return Container(
        width: active ? 22 : 8,
        height: 8,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    return Row(children: [dot(true), dot(), dot()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 18),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: page indicators + Skip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _pageIndicators(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 42),
                  // Heading
                  const Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SafeHome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  // spacer to push content upward
                  const Expanded(child: SizedBox()),
                ],
              ),

              // Circular action button bottom-right
              Positioned(
                right: 12,
                bottom: 12,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.28),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 28,
                      ),
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
// ...existing code...