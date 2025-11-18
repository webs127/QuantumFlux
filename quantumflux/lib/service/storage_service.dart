import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageService with ChangeNotifier{
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final String passwordsKey = "stored_passwords";

  /// SAVE: password + entropy + timestamp
  Future<void> savePassword(String password, double entropy) async {
    List<Map<String, dynamic>> existing = await getPasswords();

    final newPassword = {
      "password": password,
      "entropy": entropy,
      "timestamp": DateTime.now().toIso8601String(),
    };

    existing.add(newPassword);

    await storage.write(
      key: passwordsKey,
      value: jsonEncode(existing),
    );
    notifyListeners();
  }

  /// LOAD: return list of saved passwords
  Future<List<Map<String, dynamic>>> getPasswords() async {
    final stored = await storage.read(key: passwordsKey);

    if (stored == null) {
      return [];
    }

    return List<Map<String, dynamic>>.from(jsonDecode(stored));
  }

  /// DELETE: a single password
  Future<void> deletePassword(int index) async {
    List<Map<String, dynamic>> existing = await getPasswords();
    existing.removeAt(index);

    await storage.write(
      key: passwordsKey,
      value: jsonEncode(existing),
    );
  }

  /// CLEAR ALL
  Future<void> clearAll() async {
    await storage.delete(key: passwordsKey);
  }
}
