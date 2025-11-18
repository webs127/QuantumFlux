import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pqcrypto_kyber_platform_interface.dart';

/// An implementation of [PqcryptoKyberPlatform] that uses method channels.
class MethodChannelPqcryptoKyber extends PqcryptoKyberPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pqcrypto_kyber');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
