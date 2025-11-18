
library pqcrypto_kyber;

export 'src/ffi_bindings.dart';

import 'pqcrypto_kyber_platform_interface.dart';

class PqcryptoKyber {
	Future<String?> getPlatformVersion() {
		return PqcryptoKyberPlatform.instance.getPlatformVersion();
	}
}
