import 'package:flutter/material.dart';
import 'package:quantumkey/manager/color_manager.dart';
import 'package:quantumkey/ui/kyber/kyber_screen.dart';
import 'package:quantumkey/ui/kyber/decryption/kyber_decryption.dart';

class KyberLandingPage extends StatefulWidget {
  const KyberLandingPage({super.key});

  @override
  State<KyberLandingPage> createState() => _KyberLandingPageState();
}

class _KyberLandingPageState extends State<KyberLandingPage> {
  int _currentIndex = 0;

  void _onTap(int index) => setState(() => _currentIndex = index);

  static const List<Widget> _views = [
    KyberScreen(),
    KyberDecryptionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        backgroundColor: ColorManager.black,
        selectedIconTheme: IconThemeData(color: ColorManager.white),
        selectedLabelStyle: TextStyle(color: ColorManager.white,),
        unselectedIconTheme: IconThemeData(color: ColorManager.textGrey),
        unselectedLabelStyle: TextStyle(color: ColorManager.textGrey,),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.enhanced_encryption),
            label: "Encrypt",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.no_encryption),
            label: "Decrypt",
          ),
        ],
      ),
    );
  }
}
