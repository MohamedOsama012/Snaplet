import 'package:flutter/material.dart';
import 'package:sfs_editor/screens/tabs_screen.dart';

import '../core/ads/ads_loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
     AdsLoader.loadAdBanner();
     AdsLoader.loadInterstitialAd();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabsScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(17, 22, 30, 1),
      body: Center(
        child: Image.asset('assets/icons/new_logo.jpeg'),
      ),
    );
  }
}
