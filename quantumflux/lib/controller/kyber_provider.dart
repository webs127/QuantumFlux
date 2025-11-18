import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:cryptography/cryptography.dart';
//import 'package:flutter/material.dart' show TextEditingController;
import 'package:pqcrypto_kyber/pqcrypto_kyber.dart';

class KyberProvider extends ChangeNotifier {
  String _status = 'Idle';
  String get status => _status;

  Uint8List? _pk;
  Uint8List? get pk => _pk;

  Uint8List? _sk;
  Uint8List? get sk => _sk;

  Uint8List? _kemCt;
  Uint8List? get kemCt => _kemCt;

  List<int>? _ciphertext;
  List<int>? get ciphertext => _ciphertext;

  List<int>? _nonce;
  List<int>? get nonce => _nonce;

  List<int>? _mac;
  List<int>? get mac => _mac;

  String _plain = '';
  String get plain => _plain;

  final AesGcm _aesGcm = AesGcm.with256bits();

  // Provider is UI-agnostic. UI screens should consume this provider
  // and render views as needed. The provider exposes data and actions only.

  Future<void> generateKeypair() async {
    _status = 'Generating keypair...';
    notifyListeners();
    try {
      final kp = KyberFFI.keypair();
      _pk = kp['pk'] as Uint8List;
      _sk = kp['sk'] as Uint8List;
      _status = 'Keypair generated';
    } catch (e) {
      _status = 'Error generating keypair: $e';
    }
    notifyListeners();
  }

  Future<void> encrypt(String plaintext) async {
    if (_pk == null) {
      _status = 'Generate recipient keypair first';
      notifyListeners();
      return;
    }
    if (plaintext.isEmpty) {
      _status = 'Enter a message to encrypt';
      notifyListeners();
      return;
    }
    _status = 'Encapsulating and encrypting...';
    notifyListeners();
    try {
      final enc = KyberFFI.encapsulate(_pk!.toList());
      final ct = enc['ct'] as Uint8List;
      final ss = enc['ss'] as Uint8List; // 32 bytes

      // Derive 32-byte key by hashing the Kyber shared secret with SHA-256
      final hash = await Sha256().hash(ss);
      final keyBytes = Uint8List.fromList(hash.bytes);

      // Encrypt with AES-GCM
      final nonce = _aesGcm.newNonce();
      final secret = SecretKey(keyBytes);
      final encrypted = await _aesGcm.encrypt(
        utf8.encode(plaintext),
        secretKey: secret,
        nonce: nonce,
      );

      _kemCt = ct;
      _ciphertext = encrypted.cipherText;
      _nonce = nonce;
      _mac = encrypted.mac.bytes;
      _plain = plaintext;
      _status = 'Encryption done';
    } catch (e) {
      _status = 'Encryption error: $e';
    }
    notifyListeners();
  }

  // String _decryptedStatus = 'Idle';
  // String _decrypted = '';

  // TextEditingController? privateKeyController = TextEditingController();
  // TextEditingController? kemCtController = TextEditingController();
  // TextEditingController? nonceController = TextEditingController();
  // TextEditingController? ciphertextController = TextEditingController();
  // TextEditingController? macController = TextEditingController();

  // //final AesGcm _aesGcm = AesGcm.with256bits();

  // String get decryptedStatus => _decryptedStatus;
  // String get decrypted => _decrypted;

  // Future<void> _decrypt(
  //   Uint8List? sk,
  //   Uint8List? kemCt,
  //   Uint8List? nonce,
  //   List<int>? cipherText,
  //   List<int>? mac,
  // ) async {
  //   _decryptedStatus = 'Checking inputs...';
  //   if (sk == null || kemCt == null || ciphertext == null || nonce == null) {
  //     _status = 'Missing key/ciphertext/nonce in provider';
  //     notifyListeners();
  //     return;
  //   }
  //   _decryptedStatus = 'Decapsulating and decrypting...';
  //   notifyListeners();
  //   try {
  //     final ss = KyberFFI.decapsulate(kemCt.toList(), sk.toList());
  //     final ssBytes = Uint8List.fromList(ss);

  //     final hash = await Sha256().hash(ssBytes);
  //     final keyBytes = Uint8List.fromList(hash.bytes);
  //     final secret = SecretKey(keyBytes);

  //     final clear = await _aesGcm.decrypt(
  //       SecretBox(
  //         Uint8List.fromList(ciphertext!),
  //         nonce: Uint8List.fromList(nonce!),
  //         mac: Mac(mac ?? []),
  //       ),
  //       secretKey: secret,
  //     );

  //     _decrypted = utf8.decode(clear);
  //     _decryptedStatus = 'Decryption success';

  //     notifyListeners();
  //   } catch (e) {
  //     _decryptedStatus = 'Decryption error: $e';
  //     notifyListeners();
  //   }
  // }

  // Helpers to export data as base64 for UI
  String? get kemCtBase64 => _kemCt == null ? null : base64.encode(_kemCt!);
  String? get ciphertextBase64 =>
      _ciphertext == null ? null : base64.encode(_ciphertext!);
}
