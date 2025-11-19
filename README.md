

## 🔐QuantumFlux — Quantum-Secure Passwords & Post-Quantum Encryption

QuantumFlux is a next-generation mobile security application built with Flutter, combining quantum-inspired randomness, entropy-based password generation, and post-quantum cryptography (PQC) through a custom Kyber plugin. The project includes both the full mobile application and the underlying QuantumFlux Kyber Plugin, a Dart FFI + C++ module that provides NIST-approved quantum-resistant encryption.

This repository represents a complete exploration of how mobile development, cybersecurity, and quantum computing can meet in a single practical tool.

---

## 🚀 Features

## 🔢 Quantum Random Password Generator

* High-entropy random password generation
* Real-time entropy calculation
* Visual entropy strength indicator
* More secure than classical pseudo-random generators

## 🔐 Post-Quantum Encryption (Kyber + AES-256-GCM)

* Uses Kyber KEM (NIST PQC standard) for quantum-resistant key exchange
* Derives a 256-bit AES key from the Kyber shared secret
* Encrypts and decrypts text securely on-device
* Resistant to quantum attacks capable of breaking RSA/ECC

## 🔒 Secure Local Storage

* Stores generated passwords, entropy levels, and timestamps
* Utilizes Flutter Secure Storage with encrypted keystore/keychain
* No cloud uploads, no external servers

## 📱 Modern UI + Smooth Animations

* Minimalist and intuitive
* Clear visualization of entropy levels
* Fast and responsive experience

---

## 🧩QuantumFlux Kyber Plugin (Built Into This Project)

The QuantumFlux Kyber Plugin is a lightweight, high-performance post-quantum cryptography module that powers the app’s encryption system. Built with C++ and integrated through Dart FFI, it provides:

### Core Capabilities:

* Kyber keypair generation
* Encapsulation (public key → shared secret + ciphertext)
* Decapsulation (private key → restore shared secret)
* Mobile-optimized PQC performance
* Local-only cryptographic operations (no network)

## Developer API:

```dart
final kp = KyberFFI.keypair();
final enc = KyberFFI.encapsulate(kp['pk']);
final ss  = KyberFFI.decapsulate(enc['ct'], kp['sk']);
```

---

# 📚 Technology Stack

* Flutter (Dart)
* Provider state management
* C++ (Kyber KEM implementation)
* Dart FFI
* AES-256-GCM (cryptography package)
* Flutter Secure Storage

---

# 👨‍💻 Use Cases

* Secure messaging
* Password managers
* PQC-ready mobile apps
* Academic PQC research
* Cybersecurity education

---

# 📦 Running the App

```bash
flutter pub get
flutter run
```


