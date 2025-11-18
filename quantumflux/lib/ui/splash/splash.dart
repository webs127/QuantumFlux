import 'package:flutter/material.dart';
import 'package:quantumkey/app/route.dart';
import 'package:quantumkey/manager/color_manager.dart';
import 'package:quantumkey/manager/image_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  start() {
    Future.delayed(Duration(seconds: 2), nextPage);
  }

  nextPage() {
    Navigator.pushReplacementNamed(context, RouteManager.landing);
  }

  @override
  void initState() {
    super.initState();
    start();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorManager.containerStart, ColorManager.containerEnd],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.iconColorStart,
                      ColorManager.iconColorend,
                    ],
                  ),
                ),
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Image.asset(ImageManager.icon, fit: BoxFit.contain),
                  ),
                ),
              ),
              SizedBox(
                height: 12
              ),
              Text(
          "Quantum Flux",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: ColorManager.textBlue,
          ),
        ),
            ],
          ),
        ),
      ),
    );
  }
}
