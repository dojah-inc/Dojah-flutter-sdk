import 'dojah_flutter_sdk_platform_interface.dart';

class DojahKyc {
  Future<String?> launch(String widgetId,
      {String? referenceId, String? email}) {
    return DojahFlutterSdkPlatform.instance
        .launchDojah(widgetId, referenceId: referenceId, email: email);
  }
}
