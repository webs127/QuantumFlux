import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptography/cryptography.dart';
import 'package:pqcrypto_kyber/pqcrypto_kyber.dart';
import 'package:quantumkey/controller/kyber_provider.dart';
import 'package:quantumkey/manager/color_manager.dart';
import 'package:quantumkey/manager/image_manager.dart';

class KyberDecryptionPage extends StatefulWidget {
  const KyberDecryptionPage({super.key});

  @override
  State<KyberDecryptionPage> createState() => _KyberDecryptionPageState();
}

class _KyberDecryptionPageState extends State<KyberDecryptionPage> {
  String _status = 'Idle';
  String _decrypted = '';
  final AesGcm _aesGcm = AesGcm.with256bits();

  TextEditingController? privateKeyController = TextEditingController();

  Future<void> _decrypt() async {
    setState(() => _status = 'Checking inputs...');
    final provider = context.read<KyberProvider>();
    if (provider.sk == null ||
        provider.kemCt == null ||
        provider.ciphertext == null ||
        provider.nonce == null) {
      setState(() => _status = 'Missing key/ciphertext/nonce in provider');
      return;
    }

    setState(() => _status = 'Decapsulating and decrypting...');
    try {
      final ss = KyberFFI.decapsulate(
        provider.kemCt!.toList(),
        provider.sk!.toList(),
      );
      final ssBytes = Uint8List.fromList(ss);

      final hash = await Sha256().hash(ssBytes);
      final keyBytes = Uint8List.fromList(hash.bytes);
      final secret = SecretKey(keyBytes);

      final clear = await _aesGcm.decrypt(
        SecretBox(
          Uint8List.fromList(provider.ciphertext!),
          nonce: Uint8List.fromList(provider.nonce!),
          mac: Mac(provider.mac ?? []),
        ),
        secretKey: secret,
      );

      setState(() {
        _decrypted = utf8.decode(clear);
        _status = 'Decryption success';
      });
    } catch (e) {
      setState(() => _status = 'Decryption error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.iconColorStart,
                  ColorManager.iconColorend,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              height: 32,
              width: 32,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(ImageManager.icon, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        title: Text(
          'Quantum Decryption',
          style: TextStyle(
            color: ColorManager.textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorManager.black,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showHelp,
            color: ColorManager.white,
            tooltip: 'Help',
          ),
        ],
      ),
      backgroundColor: ColorManager.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(16),
                      color: ColorManager.iconColorStart,
                      onPressed: _decrypt,
                      child: Text(
                        'Decrypt Message',
                        style: TextStyle(
                          color: ColorManager.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Status: $_status',
                style: TextStyle(
                  color: ColorManager.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              if (_decrypted.isNotEmpty) ...[
                Text(
                  'Decrypted message:',
                  style: TextStyle(
                    color: ColorManager.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                SelectableText(
                  _decrypted,
                  style: TextStyle(
                    color: ColorManager.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              SizedBox(height: 12),
              Consumer<KyberProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (provider.kemCt != null) ...[
                        Text(
                          'KEM ciphertext (base64):',
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SelectableText(
                          base64.encode(provider.kemCt!),
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'How this screen works',
          style: TextStyle(
            color: ColorManager.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview:',
                style: TextStyle(
                  color: ColorManager.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'This screen demonstrates a hybrid encryption flow using the Kyber768 KEM and AES-GCM.\n\n'
                'Steps:\n'
                '1) Generate Recipient Keypair — produces a public key (pk) and private key (sk).\n'
                '2) Encrypt (sender): the sender calls encapsulate(pk) to obtain:\n'
                '   - KEM ciphertext (ct) — send this to the recipient\n'
                '   - shared secret (ss; 32 bytes) — used here to derive a symmetric key.\n'
                '   The sender derives a 32-byte AES key from ss (we use SHA-256 for the demo) and encrypts the message with AES-GCM.\n'
                '3) Decrypt (recipient): the recipient calls decapsulate(ct, sk) to recover the same ss, derives the AES key, and decrypts the AES-GCM ciphertext.\n\n',
                style: TextStyle(height: 1.3, fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
              Text(
                'Important buffer sizes (Kyber768):',
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '• Public key: 1184 bytes',
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '• Private key: 2400 bytes',
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '• KEM ciphertext: 1088 bytes',
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '• Shared secret: 32 bytes',
                style: TextStyle(
                  color: ColorManager.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Notes and security:',
                style: TextStyle(
                  color: ColorManager.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '- This demo derives a symmetric key by hashing the Kyber shared secret with SHA-256; in production, prefer an HKDF construction with appropriate context info.\n'
                '- AES-GCM provides authenticated encryption; the MAC is preserved and used for verification during decrypt.\n'
                '- The plugin bundles a portable PQClean Kyber implementation. Ensure you audit/validate any cryptographic code for production use.',
                style: TextStyle(height: 1.3, fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
