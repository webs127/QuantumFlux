import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantumkey/app/route.dart';
import 'package:quantumkey/controller/app_controller.dart';
import 'package:quantumkey/controller/kyber_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppController()),
        ChangeNotifierProvider(create: (_) => KyberProvider()),
      ],
      child: MaterialApp(
        title: 'QuantumFlux',
        initialRoute: RouteManager.splash,
        onGenerateRoute: Routes.getRoute,
      ),
    );
  }
}