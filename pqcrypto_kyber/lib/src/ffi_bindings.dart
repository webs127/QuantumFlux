import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

final DynamicLibrary _lib = () {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libpqcrypto_kyber.so');
  } else if (Platform.isIOS) {
    return DynamicLibrary.process();
  } else if (Platform.isMacOS) {
    return DynamicLibrary.open('libpqcrypto_kyber.dylib');
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('pqcrypto_kyber.dll');
  }
  throw UnsupportedError('Platform not supported');
}();

// C function signatures
typedef kyber_keypair_c = Int32 Function(Pointer<Uint8> pk, Pointer<Uint8> sk);
typedef kyber_enc_c = Int32 Function(Pointer<Uint8> ct, Pointer<Uint8> ss, Pointer<Uint8> pk);
typedef kyber_dec_c = Int32 Function(Pointer<Uint8> ss, Pointer<Uint8> ct, Pointer<Uint8> sk);

typedef KyberKeypair = int Function(Pointer<Uint8> pk, Pointer<Uint8> sk);
typedef KyberEnc = int Function(Pointer<Uint8> ct, Pointer<Uint8> ss, Pointer<Uint8> pk);
typedef KyberDec = int Function(Pointer<Uint8> ss, Pointer<Uint8> ct, Pointer<Uint8> sk);

final KyberKeypair _kyber_keypair = _lib
    .lookupFunction<kyber_keypair_c, KyberKeypair>('kyber_keypair');
final KyberEnc _kyber_enc = _lib.lookupFunction<kyber_enc_c, KyberEnc>('kyber_enc');
final KyberDec _kyber_dec = _lib.lookupFunction<kyber_dec_c, KyberDec>('kyber_dec');

// Sizes
const int KYBER_PUBLIC_KEY_BYTES = 1184;
const int KYBER_PRIVATE_KEY_BYTES = 2400;
const int KYBER_CIPHERTEXT_BYTES = 1088;
const int KYBER_SHARED_SECRET_BYTES = 32;

class KyberFFI {
  static Map<String, dynamic> keypair() {
    final pk = calloc<Uint8>(KYBER_PUBLIC_KEY_BYTES);
    final sk = calloc<Uint8>(KYBER_PRIVATE_KEY_BYTES);
    try {
      final res = _kyber_keypair(pk, sk);
      if (res != 0) throw Exception('kyber_keypair failed: $res');
      final pub = Uint8List.fromList(pk.asTypedList(KYBER_PUBLIC_KEY_BYTES));
      final priv = Uint8List.fromList(sk.asTypedList(KYBER_PRIVATE_KEY_BYTES));
      return {'pk': pub, 'sk': priv};
    } finally {
      calloc.free(pk);
      calloc.free(sk);
    }
  }

  static Map<String, dynamic> encapsulate(List<int> publicKey) {
    if (publicKey.length != KYBER_PUBLIC_KEY_BYTES) throw ArgumentError('Invalid public key length');
    final pk = calloc<Uint8>(KYBER_PUBLIC_KEY_BYTES);
    final ct = calloc<Uint8>(KYBER_CIPHERTEXT_BYTES);
    final ss = calloc<Uint8>(KYBER_SHARED_SECRET_BYTES);
    try {
      final pkList = pk.asTypedList(KYBER_PUBLIC_KEY_BYTES);
      pkList.setAll(0, publicKey);
      final res = _kyber_enc(ct, ss, pk);
      if (res != 0) throw Exception('kyber_enc failed: $res');
      return {
        'ct': Uint8List.fromList(ct.asTypedList(KYBER_CIPHERTEXT_BYTES)),
        'ss': Uint8List.fromList(ss.asTypedList(KYBER_SHARED_SECRET_BYTES))
      };
    } finally {
      calloc.free(pk);
      calloc.free(ct);
      calloc.free(ss);
    }
  }

  static List<int> decapsulate(List<int> ciphertext, List<int> secretKey) {
    if (ciphertext.length != KYBER_CIPHERTEXT_BYTES) throw ArgumentError('Invalid ciphertext length');
    if (secretKey.length != KYBER_PRIVATE_KEY_BYTES) throw ArgumentError('Invalid secret key length');
    final ct = calloc<Uint8>(KYBER_CIPHERTEXT_BYTES);
    final sk = calloc<Uint8>(KYBER_PRIVATE_KEY_BYTES);
    final ss = calloc<Uint8>(KYBER_SHARED_SECRET_BYTES);
    try {
      ct.asTypedList(KYBER_CIPHERTEXT_BYTES).setAll(0, ciphertext);
      sk.asTypedList(KYBER_PRIVATE_KEY_BYTES).setAll(0, secretKey);
      final res = _kyber_dec(ss, ct, sk);
      if (res != 0) throw Exception('kyber_dec failed: $res');
      return ss.asTypedList(KYBER_SHARED_SECRET_BYTES).toList();
    } finally {
      calloc.free(ct);
      calloc.free(sk);
      calloc.free(ss);
    }
  }
}
