import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Animation<Color?> backgroundAnimation;
  late Animation<double> logoSizeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Scale animation for bouncy entrance
    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    // Background color animation
    backgroundAnimation =
        ColorTween(begin: const Color(0xffEF7D17), end: Colors.white).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
          ),
        );

    // Logo size animation for dynamic sizing
    logoSizeAnimation = Tween<double>(begin: 100.0, end: 200.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    controller.forward();

    // Add listener to update UI
    controller.addListener(() {
      setState(() {});
    });

    // Navigate after animation completes + delay
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundAnimation.value,
      body: Center(
        child: Hero(
          tag: 'logoHero',
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              width: logoSizeAnimation.value,
              height: logoSizeAnimation.value,
              child: Image.asset(
                "assets/images/laxmiLogo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
