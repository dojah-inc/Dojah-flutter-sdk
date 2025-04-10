import 'package:dojah_kyc_sdk_flutter/dojah_kyc_sdk_flutter_platform_interface.dart';

class DojahKyc {
  static Future<String?> launch(String widgetId,
      {String? referenceId, String? email}) {
    return DojahFlutterSdkPlatform.instance
        .launchDojah(widgetId, referenceId: referenceId, email: email);
  }
}
