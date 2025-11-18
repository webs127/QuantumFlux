import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pqcrypto_kyber/pqcrypto_kyber_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelPqcryptoKyber platform = MethodChannelPqcryptoKyber();
  const MethodChannel channel = MethodChannel('pqcrypto_kyber');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
