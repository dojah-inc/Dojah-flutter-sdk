import 'flutter_dojah_kyc_platform_interface.dart';

class DojahKyc {
  static Future<String?> launch(String widgetId,
      {String? referenceId, String? email}) {
    return DojahFlutterSdkPlatform.instance
        .launchDojah(widgetId, referenceId: referenceId, email: email);
  }
}
