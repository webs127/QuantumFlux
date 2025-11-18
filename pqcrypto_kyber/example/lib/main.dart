import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pqcrypto_kyber/pqcrypto_kyber.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Idle';

  Future<void> _runDemo() async {
    setState(() => _status = 'Generating keypair...');
    try {
      final kp = KyberFFI.keypair();
      final Uint8List pk = kp['pk'];
      final Uint8List sk = kp['sk'];

      setState(() => _status = 'Encapsulating...');
      final enc = KyberFFI.encapsulate(pk);
      final Uint8List ct = enc['ct'];
      final Uint8List ss1 = enc['ss'];

      setState(() => _status = 'Decapsulating...');
      final ss2 = KyberFFI.decapsulate(ct.toList(), sk.toList());

      final equal = base64.encode(ss1) == base64.encode(ss2);

      setState(() => _status = 'Done — shared secrets equal: $equal');
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('pqcrypto_kyber example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _runDemo,
                child: const Text('Run Kyber768 demo'),
              ),
              const SizedBox(height: 16),
              Text(_status),
            ],
          ),
        ),
      ),
    );
  }
}
