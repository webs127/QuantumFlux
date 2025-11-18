import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quantumkey/manager/color_manager.dart';
import 'package:quantumkey/model/quantumvalue_model.dart';
import 'package:quantumkey/service/api_service.dart';
import 'package:quantumkey/service/storage_service.dart';

class AppController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SecureStorageService storageService = SecureStorageService();
  double entropyLevel = 0.0;
  double passwordStrength = 10.0;
  double min = 10;
  bool uint8 = true;
  String booltype = "";
  double max = 100;
  late QuantumValue quantumValue;
  List<Map<String, dynamic>> _passwords = [];
  List<Map<String, dynamic>> get passwords => _passwords;

  AppController() {
    loadPasswords();
    //testKyber();
  }
//   void testKyber() async {
//   try {
//     final result = await Kyber.keygen();
//     print("Public key length: ${result.publicKey.length}");
//     print("Private key length: ${result.privateKey.length}");
//   } catch (e) {
//     print("Kyber error: $e");
//   }
// }


  bool isLoading = false;

  /// Load all saved passwords
  Future<void> loadPasswords() async {
    isLoading = true;
    notifyListeners();

    _passwords = await storageService.getPasswords();

    isLoading = false;
    notifyListeners();
  }

  /// Save a new password + entropy + timestamp
  Future<void> addPassword(String password, double entropy) async {
    await storageService.savePassword(password, entropy);
    await loadPasswords(); // refresh list
  }

  /// Delete a password
  Future<void> deletePassword(int index) async {
    await storageService.deletePassword(index);
    await loadPasswords();
  }

  /// Clear all saved passwords
  Future<void> clearAll() async {
    await storageService.clearAll();
    await loadPasswords();
  }

  String generatedQuantumValue = "";
  bool loading = false;
  onEntropyChanged(double value) {
    entropyLevel = value;
    notifyListeners();
  }

  onPasswordStrengthChanged(double value) {
    passwordStrength = value;
    notifyListeners();
  }

  onTypeChanged(bool? value) {
    uint8 = value!;
    notifyListeners();
  }

  void getData(int length, String type) async {
    loading = true;
    try {
      quantumValue = await _apiService.getQuantumValues(passwordStrength, type);
      generateQuantumPassword();
      final List<int> dataInts = (quantumValue.data).cast<int>();
      entropyLevel = entropyLevelPercentage(dataInts);
      addPassword(generatedQuantumValue, entropyLevel);
    } catch (e) {
      print(e);
    } finally {
      loading = false;
    }
    notifyListeners();
  }

  generateQuantumPassword() {
    const asciiChars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()";
    Random random = Random.secure();

    generatedQuantumValue = List.generate(
      passwordStrength.toInt(),
      (i) => asciiChars[random.nextInt(asciiChars.length)],
    ).join();
  }

  void copyToClipBoard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: generatedQuantumValue));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Password copid to clipboard.",
          style: TextStyle(
            color: ColorManager.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        backgroundColor: ColorManager.black,
      ),
    );
  }

  List<SettingsModel> settings = [
    SettingsModel(
      title: "Auto-clear History",
      subTitle: "Clear passwords after 24 hours",
      active: false,
    ),
    SettingsModel(
      title: "Biometric Lock",
      subTitle: "Require fingerprint to access",
      active: false,
    ),
    SettingsModel(
      title: "Quantum Verification",
      subTitle: "Enhanced entropy validation",
      active: false,
    ),
  ];

  onSettingsChanged(bool? value, int index) {
    settings[index].active = value!;
    notifyListeners();
  }

  double calculateEntropy(List<int> values) {
    if (values.isEmpty) return 0;

    final freq = <int, int>{};
    for (var v in values) {
      freq[v] = (freq[v] ?? 0) + 1;
    }

    double entropy = 0;
    final length = values.length.toDouble();

    // Shannon entropy
    freq.forEach((value, count) {
      double p = count / length;
      entropy += -p * (log(p) / log(2)); // log base 2
    });

    return entropy;
  }

  double entropyLevelPercentage(List<int> values) {
    double h = calculateEntropy(values);
    return (h / 8.0) * 100.0;
  }

}


class SettingsModel {
  final String title;
  final String subTitle;
  bool active;

  SettingsModel({
    required this.title,
    required this.subTitle,
    required this.active,
  });
}
