## QuantumFlux Kyber Plugin — Post-Quantum Encryption Module for Flutter

The QuantumFlux Kyber Plugin is a high-performance, post-quantum cryptography module designed to bring NIST-approved PQC security to Flutter applications. Built using Dart FFI, C++, and the Kyber Key Encapsulation Mechanism (KEM), this plugin enables developers to integrate quantum-resistant key exchange and encryption into mobile apps with ease. It is engineered for speed, safety, and real-world usability, serving as the cryptographic engine that powers the QuantumFlux app.

At its core, the plugin provides a complete Kyber implementation capable of performing keypair generation, encapsulation, and decapsulation, ensuring that two parties can establish a secure shared secret even in the presence of adversaries equipped with quantum computers. Unlike classical algorithms such as RSA or ECC—which are vulnerable to Shor’s algorithm—Kyber is built on lattice-based cryptography and is one of the primary algorithms selected by NIST for standardization.

The plugin exposes simple, developer-friendly APIs. With just a few method calls, developers can generate public/private keypairs, encapsulate shared secrets using the recipient’s public key, and decapsulate ciphertexts using the private key. This KEM-generated shared secret can then be passed into any symmetric cipher (such as AES-256-GCM) for fast and secure message encryption. The result is a hybrid system that combines the speed of symmetric encryption with the quantum security of Kyber.

The plugin is implemented in optimized C++ for maximum performance, with Dart FFI bindings that make it fully accessible from Flutter without sacrificing speed. All operations run locally on-device, ensuring no external services, network calls, or cloud dependencies. Data never leaves the device, preserving user privacy and minimizing attack surfaces.

The QuantumFlux Kyber Plugin is ideal for developers building secure messaging apps, password managers, blockchain wallets, IoT systems, or any application that requires long-term, quantum-safe security. As the world transitions into the post-quantum era, this plugin provides a reliable foundation for protecting sensitive data against both classical and future quantum threats.

## PQClean Kyber768 FFI plugin notes

This plugin provides a thin C wrapper around a Kyber768 implementation plus Dart FFI bindings.

Files added by the generator:
- `android/src/main/cpp/kyber_wrapper.c` / `.h` – C wrapper that calls `crypto_kem_*`.
- `android/src/main/cpp/CMakeLists.txt` – compiles PQClean sources (expected under `pqclean/kyber768/`) and the wrapper into `libpqcrypto_kyber.so`.
- `ios/Classes/kyber_wrapper.mm` / `.h` – Objective-C++ wrapper for iOS.
- `lib/src/ffi_bindings.dart` – Dart FFI bindings.
- `lib/pqcrypto_kyber.dart` – exports FFI bindings.
- `example/lib/main.dart` – demo UI that generates a keypair, encapsulates, and decapsulates.

Important: The actual PQClean Kyber768 C sources are not included. To build a functional plugin you must place a Kyber768 implementation that provides the `crypto_kem_keypair`, `crypto_kem_enc`, and `crypto_kem_dec` symbols into the platform build inputs. Recommended: use the PQClean implementation and place its C files under `android/src/main/cpp/pqclean/kyber768/` and `ios/Classes/pqclean/kyber768/`.

If you want, I can add the PQClean Kyber768 sources directly into this plugin (it's several files) or add a fetch script; tell me which you prefer.

