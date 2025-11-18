import 'package:flutter/material.dart';
import 'package:quantumkey/ui/kyber/decryption/kyber_decryption.dart';
import 'package:quantumkey/ui/kyber/kyber_screen.dart';
import 'package:quantumkey/ui/landing/landing.dart';
import 'package:quantumkey/ui/splash/splash.dart';

class RouteManager {
  static const String splash = "/";
  static const String landing = "/landing";
  static const String kyber = "/kyber";
  static const String settings = "/decryptionPage";
}

class Routes {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteManager.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteManager.landing:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case RouteManager.kyber:
        return MaterialPageRoute(builder: (_) => const KyberScreen());
      case RouteManager.settings:
        return MaterialPageRoute(builder: (_) => const KyberDecryptionPage());
      default:
        return undefined();
    }
  }

  static Route<dynamic> undefined() {
    return MaterialPageRoute(builder: (_) => const Scaffold());
  }
}
