import 'package:flutter_test/flutter_test.dart';
import 'package:pqcrypto_kyber/pqcrypto_kyber.dart';
import 'package:pqcrypto_kyber/pqcrypto_kyber_platform_interface.dart';
import 'package:pqcrypto_kyber/pqcrypto_kyber_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPqcryptoKyberPlatform
    with MockPlatformInterfaceMixin
    implements PqcryptoKyberPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PqcryptoKyberPlatform initialPlatform = PqcryptoKyberPlatform.instance;

  test('$MethodChannelPqcryptoKyber is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPqcryptoKyber>());
  });

  test('getPlatformVersion', () async {
    PqcryptoKyber pqcryptoKyberPlugin = PqcryptoKyber();
    MockPqcryptoKyberPlatform fakePlatform = MockPqcryptoKyberPlatform();
    PqcryptoKyberPlatform.instance = fakePlatform;

    expect(await pqcryptoKyberPlugin.getPlatformVersion(), '42');
  });
}
