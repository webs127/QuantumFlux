import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantumkey/controller/kyber_provider.dart';
import 'package:quantumkey/manager/color_manager.dart';
import 'package:quantumkey/manager/image_manager.dart';

class KyberScreen extends StatefulWidget {
  const KyberScreen({super.key});

  @override
  State<KyberScreen> createState() => _KyberScreenState();
}

class _KyberScreenState extends State<KyberScreen> {
  final TextEditingController _plainController = TextEditingController();

  Future<void> _generateKeypair() async {
    final provider = context.read<KyberProvider>();
    await provider.generateKeypair();
  }

  Future<void> _encrypt() async {
    final provider = context.read<KyberProvider>();
    await provider.encrypt(_plainController.text);
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
          'Quantum Encrypt',
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
              SizedBox(height: 16),
              InkWell(
                onTap: _generateKeypair,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.iconColorStart,
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: ColorManager.iconColorend,
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        ColorManager.iconColorStart,
                        ColorManager.iconColorend,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 23,
                        height: 26,
                        child: Image.asset(ImageManager.icon),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Generate Recipient Keypair",
                        style: TextStyle(
                          color: ColorManager.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _generateKeypair,
              //   child: Text('Generate Recipient Keypair'),
              // ),
              SizedBox(height: 12),
              TextField(
                controller: _plainController,
                maxLines: 5,
                style: TextStyle(color: ColorManager.white),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Message',
                  labelStyle: TextStyle(
                    color: ColorManager.textWhite,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(16),
                      color: ColorManager.iconColorStart,
                      onPressed: _encrypt,
                      child: Text(
                        'Encrypt Message',
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
              SizedBox(height: 24),
              Consumer<KyberProvider>(
                builder: (context, provider, _) => Text(
                  'Status: ${provider.status}',
                  style: TextStyle(
                    color: ColorManager.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Consumer<KyberProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (provider.ciphertext != null) ...[
                        SizedBox(height: 8),
                        Text(
                          'Encrypted message (base64):',
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SelectableText(
                          base64.encode(provider.ciphertext!),
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                      if (provider.nonce != null) ...[
                        SizedBox(height: 8),
                        Text(
                          'Nonce:',
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SelectableText(
                          base64.encode(provider.nonce!),
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                      if (provider.nonce != null) ...[
                        SizedBox(height: 8),
                        Text(
                          'Mac:',
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SelectableText(
                          base64.encode(provider.mac!),
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
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
                      ],
                      SizedBox(height: 12),
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
