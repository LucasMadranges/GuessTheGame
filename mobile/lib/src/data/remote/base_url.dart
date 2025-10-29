import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

String defaultBaseUrl() {
  if (kIsWeb) return 'http://localhost:4000';
  // Android Emulator: 10.0.2.2, iOS Simulator/macOS: localhost
  return Platform.isAndroid ? 'http://10.0.2.2:4000' : 'http://localhost:4000';
}