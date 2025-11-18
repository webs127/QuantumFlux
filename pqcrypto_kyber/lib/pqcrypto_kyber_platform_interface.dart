import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pqcrypto_kyber_method_channel.dart';

abstract class PqcryptoKyberPlatform extends PlatformInterface {
  /// Constructs a PqcryptoKyberPlatform.
  PqcryptoKyberPlatform() : super(token: _token);

  static final Object _token = Object();

  static PqcryptoKyberPlatform _instance = MethodChannelPqcryptoKyber();

  /// The default instance of [PqcryptoKyberPlatform] to use.
  ///
  /// Defaults to [MethodChannelPqcryptoKyber].
  static PqcryptoKyberPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PqcryptoKyberPlatform] when
  /// they register themselves.
  static set instance(PqcryptoKyberPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
